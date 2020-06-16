module Skippr
  class CaseEntry < Api

    self.prefix = version_prefix + "cases/:case_id/"

    class << self
      def collection_name
        'entries'
      end
    end

  end
end
