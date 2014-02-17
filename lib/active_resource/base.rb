class ActiveResource::Base
  # for thread safety, delegate to thread safe class for connection attributes
  class << self

    def reset_connection
      @connection = nil
    end

    def site
      Skippr::Endpoint.site
    end
    def site=site
      site_uri = create_site_uri_from(site)

      subdomain, *domain = site_uri.host.split(/\./) # expect subdomain for our api

      user = URI.parser.unescape(site_uri.user) if site_uri.user
      password = URI.parser.unescape(site_uri.password) if site_uri.password

      Skippr::Endpoint.configure({
          protocol:   site_uri.scheme,
          subdomain:  subdomain,
          domain:     domain.join('.'),
          port:       site_uri.port,
          path:       site_uri.path,
          user:       user,
          password:   password,
      })
    end


    def user
      Skippr::Endpoint.user
    end
    def user=user
      raise "Monkey patched, don't use"
    end


    def password
      Skippr::Endpoint.password
    end
    def password=password
      raise "Monkey patched, don't use"
    end

  end
end
