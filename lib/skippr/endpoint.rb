module Skippr

  class Endpoint

    attr_accessor :user_agent, :user, :password, :subdomain, :protocol, :endpoint_domain, :port, :api_path, :api_version

    def user_agent
      @user_agent ||= "skippr-rb #{Skippr::VERSION}"
    end

    def subdomain
      @subdomain ||= "batzen3000" # FIXME
    end

    def site
      @site ||= URI.parse("#{protocol}://#{subdomain}.#{endpoint_domain}#{":" + port.to_s if port}#{api_path}/#{api_version}/")
    end

    def protocol
      "http"
    end

    def endpoint_domain
      "skippr.local"
    end

    def port
      3000
    end

    def api_path
      "/api"
    end

    def api_version
      "v1"
    end

  end

end
