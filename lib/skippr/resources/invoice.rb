module Skippr
  class Invoice < Api

    ACCOUNTED = 0
    PRINTED = 1
    DRAFT = 4

    def accounted?
      state == ACCOUNTED
    end

    def printed?
      state <= PRINTED
    end

    def draft?
      state == DRAFT
    end

  end
end
