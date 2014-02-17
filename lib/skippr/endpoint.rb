module Skippr

  class Endpoint

    class << self

      def configure(configuration_hash)
        configuration_hash.each do |key, value|
          self.thread_container["#{key}"] = value
        end
      end

      def site
        assert_configuration!(self.thread_container)

        URI.parse("#{self.protocol}://#{self.subdomain}.#{self.domain}#{":" + self.port.to_s if self.port.present?}#{self.path}")
      end


      def protocol
        self.thread_container['protocol'] || "https"
      end

      def subdomain
        self.thread_container['subdomain']
      end

      def domain
        self.thread_container['domain'] || "skippr.com"
      end

      def port
        self.thread_container['port']
      end

      def path
        self.thread_container['path'] || "/api/v1/"
      end

      def user
        self.thread_container['user']
      end

      def password
        self.thread_container['password']
      end

      def thread_container
        Thread.current['skippr.endpoint.conf'] ||= {}
        Thread.current['skippr.endpoint.conf']
      end

      def assert_configuration!(conf_hash)

        unknowns = conf_hash.symbolize_keys.except(:protocol, :subdomain, :domain, :port, :path, :user, :password)
        unless unknowns.empty?
          raise Skippr::UnknownConfigurationError.new("#{unknowns.keys} are unknown endpoint options")
        end

        required_confs = [:subdomain]

        missings = required_confs - conf_hash.symbolize_keys.keys
        unless missings.empty?
          raise Skippr::MissingConfigurationError.new("Missing in api configuration: #{missings}")
        end
      end
    end
  end

end
