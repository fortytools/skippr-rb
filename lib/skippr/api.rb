module Skippr

  class Api < ActiveResource::Base

    cattr_accessor :client_name, :app_key, :app_token, :client_user_api_key, :client_user_api_token

    self.timeout = 30
    self.include_root_in_json = false

    class << self

      def site
        endpoint.site
      end

      def endpoint
        @endpoint ||= Skippr::Endpoint.new
        @endpoint.subdomain = self.client_name
        @endpoint
      end

      def credentials= credentials
        credentials.each do |key, value|
          self.send("#{key}=", value)
        end
      end

      def credentials
        {
          app_key: self.app_key,
          app_token: self.app_token,
          client_user_api_key: self.client_user_api_key,
          client_user_api_token: self.client_user_api_token
        }
      end

      def authentication
        valid_until = 1.hour.from_now
        sig_src = [self.client_user_api_token, self.app_token, valid_until.to_time.to_i.to_s].join(":")
        signature = Digest::SHA2.hexdigest(sig_src)
        { app: self.app_key,
          user: self.client_user_api_key,
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
      [:app_key, :app_token, :client_user_api_key, :client_user_api_token, :client_name].each do |required_config|
        raise Skippr::MissingCredentialsError.new("#{required_config} is missing")
      end
    end

  end

end


