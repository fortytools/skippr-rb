class ActiveResource::Base
  class << self

    def reset_connection
      @connection = nil
    end

    def site=site
      thread_container['site'] = site
    end
    def site
      s = thread_container['site']
      if s.is_a?(String)
        URI.parse(s)
      else
        s
      end
    end

    def password=password
      thread_container['password'] = password
    end
    def password
      thread_container['password']
    end

    def user=user
      thread_container['user'] = user
    end
    def user
      thread_container['user']
    end

    def thread_container
      Thread.current['active_resource.conf'] ||= {}
      Thread.current['active_resource.conf']
    end


  end
end
