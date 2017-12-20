module HasEnabled
  extend ActiveSupport::Concern
  included do

    def self.enabled
      where(enabled: true)
    end

    def self.disabled
      where(enabled: false)
    end
    
  end
end
