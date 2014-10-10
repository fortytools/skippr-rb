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

      domain_fragments = site_uri.host.split(/\./) # expect subdomain for our api

      subdomain = domain_fragments.take(domain_fragments.size - 2)
      domain = domain_fragments.drop(domain_fragments.size - 2)

      subdomain = nil if subdomain.empty?

      user = URI.parser.unescape(site_uri.user) if site_uri.user
      password = URI.parser.unescape(site_uri.password) if site_uri.password

      Skippr::Endpoint.configure({
          protocol:   site_uri.scheme,
          subdomain:  subdomain.try(:join,'.'),
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
