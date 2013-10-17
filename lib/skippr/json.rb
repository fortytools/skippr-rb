require 'active_support/json'

module Skippr
  module Json
    extend self
    def extension
      "json"
    end

    def mime_type
      "application/json"
    end

    def encode(hash, options={})
      hash.to_json(options)
    end

    def decode(json)
      ActiveSupport::JSON.decode(json)
    end
  end
end


