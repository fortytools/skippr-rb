module Skippr

  class Api < ActiveResource::Base

    cattr_accessor :client, :app_key, :app_secret, :user_key, :user_secret

    self.timeout = 30
    self.include_root_in_json = false

    # nasty hack to disable the root element
    def to_json(options={})
      as_json.to_json(options)
    end

    class << self

      def site
        endpoint.site
      end

      def endpoint
        @endpoint ||= Skippr::Endpoint.new
        @endpoint.subdomain = self.client
        return @endpoint
      end

      def credentials= credentials
        credentials.each do |key, value|
          self.send("#{key}=", value)
        end
      end

      def credentials
        {
          app_key: self.app_key,
          app_secret: self.app_secret,
          user_key: self.user_key,
          user_secret: self.user_secret
        }
      end

      def authentication
        valid_until = 1.hour.from_now
        sig_src = [self.user_secret, self.app_secret, valid_until.to_time.to_i.to_s].join(":")
        signature = Digest::MD5.hexdigest(sig_src)
        { app: self.app_key,
          user: self.user_key,
          validuntil: valid_until.to_time.to_i.to_s,
          signature: signature
        }
      end

      def element_path(id, prefix_options = {}, query_options = nil)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        query_options = ( query_options || {} ).merge(self.authentication)
        "#{prefix(prefix_options)}#{collection_name}/#{id}#{query_string(query_options)}"
      end

      def collection_path(prefix_options = {}, query_options = nil)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        query_options = ( query_options || {} ).merge(self.authentication)
        "#{prefix(prefix_options)}#{collection_name}#{query_string(query_options)}"
      end
    end

    private

    def assert_configuration!
      [:app_key, :app_secret, :user_key, :user_secret, :client].each do |required_config|
        raise Skippr::MissingCredentialsError.new("#{required_config} is missing")
      end
    end

  end

end


