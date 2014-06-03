module Skippr

  class Api < ActiveResource::Base


    def get(custom_method_name, options={})
      super(custom_method_name, options.merge(self.class.auth_params))
    end
    def post(custom_method_name, options={})
      super(custom_method_name, options.merge(self.class.auth_params))
    end
    def put(custom_method_name, options={})
      super(custom_method_name, options.merge(self.class.auth_params))
    end
    def delete(custom_method_name, options={})
      super(custom_method_name, options.merge(self.class.auth_params))
    end


    class << self

      ### ActiveResource API
      timeout = 30
      def include_root_in_json
        false
      end

      # Thread safety for active_resource, see monkey patch in monkey.rb

      def element_path(id, prefix_options = {}, query_options = nil)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        query_options = ( query_options || {} ).merge(self.auth_params)
        "#{prefix(prefix_options)}#{collection_name}/#{id}#{query_string(query_options)}"
      end

      def collection_path(prefix_options = {}, query_options = nil)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        query_options = ( query_options || {} ).merge(self.auth_params)
        "#{prefix(prefix_options)}#{collection_name}#{query_string(query_options)}"
      end

      def get(custom_method_name, options={})
        super(custom_method_name, options.merge(self.auth_params))
      end
      def post(custom_method_name, options={})
        super(custom_method_name, options.merge(self.auth_params))
      end
      def put(custom_method_name, options={})
        super(custom_method_name, options.merge(self.auth_params))
      end
      def delete(custom_method_name, options={})
        super(custom_method_name, options.merge(self.auth_params))
      end

      ### END ActiveResource API

      def valid?
        begin
          uri = URI.parse(self.site.to_s + 'auth/valid?' + self.auth_params.to_param)
          http = Net::HTTP.new(uri.host, uri.port)
          if Endpoint.protocol == 'https'
            http.use_ssl= true
          end
          rq = Net::HTTP::Get.new(uri.request_uri)
          unless Endpoint.user.blank?
            rq.basic_auth(Endpoint.user, Endpoint.password)
          end
          response = http.request(rq)
          body = response.read_body
          if response.code == '200' && body == 'Ok'
            true
          else
            Rails.logger.info "Server responded: (#{response.code}) #{body}"
            false
          end

        rescue Timeout::Error
          Rails.logger.warn "timeout"
          false
        rescue Errno::ECONNREFUSED
          Rails.logger.warn "no api connection"
          false
        rescue
          Rails.logger.info "exception when trying to authenticate"
          false
        end
      end

      # Thread safe auth params
      def auth_params
        assert_configuration!(self.thread_container)

        valid_until = 1.hour.from_now
        sig_src = [self.client_user_api_token, self.app_token, valid_until.to_time.to_i.to_s].join(":")
        signature = Digest::SHA2.hexdigest(sig_src)
        {
          app:        self.app_key,
          user:       self.client_user_api_key,
          validuntil: valid_until.to_time.to_i.to_s,
          signature:  signature
        }
      end


      def configure(configuration_hash)
        configuration_hash.each do |key, value|
          self.thread_container["#{key}"] = value
        end

        Endpoint.configure({subdomain: client_name})

        reset_connection
      end

      def configure_endpoint(configuration_hash)
        Endpoint.configure(configuration_hash)

        reset_connection
      end

      def client_name
        self.thread_container['client_name']
      end

      def app_key
        self.thread_container['app_key']
      end

      def app_token
        self.thread_container['app_token']
      end

      def client_user_api_key
        self.thread_container['client_user_api_key']
      end

      def client_user_api_token
        self.thread_container['client_user_api_token']
      end

      def thread_container
        Thread.current['skippr.api.conf'] ||= {}
        Thread.current['skippr.api.conf']
      end

      def assert_configuration!(conf_hash)
        required_confs = [:app_key, :app_token, :client_user_api_key, :client_user_api_token, :client_name]

        unknowns = conf_hash.symbolize_keys.except(*required_confs)
        unless unknowns.empty?
          raise Skippr::UnknownConfigurationError.new("Unknown in api configuration: #{unknowns.keys}")
        end

        missings = required_confs - conf_hash.symbolize_keys.keys
        unless missings.empty?
          raise Skippr::MissingConfigurationError.new("Missing in api configuration: #{missings}")
        end
      end
    end


  end

  # Delegator for convenience, checks whether current skippr api settings allow for a valid connection
  def self.valid?
    Api.valid?
  end
end


