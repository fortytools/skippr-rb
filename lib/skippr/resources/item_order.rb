module Skippr
  class ItemOrder < Api

    def draft?
      number.nil?
    end

    def printed?
      !draft?
    end

  end
end
