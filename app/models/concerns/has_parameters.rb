module HasParameters
  extend ActiveSupport::Concern
  
  included do
    serialize :parameters, Hash
    attr_accessor :parameters_text

    validate :validate_parameters_text
    before_save :assign_parameters
  end

  def parameters_text
    JSON.pretty_generate(self.parameters)
  end

  def validate_parameters_text
    return unless text = @parameters_text.presence
    begin
      JSON.load(text).symbolize_keys
    rescue Exception => e
      errors.add :parameters_text, "format error: #{e.message}"
      return
    end
  end

  def assign_parameters
    return if @parameters_text.blank?
    return unless v = self.validate_parameters_text
    # todo need compare
    if self.parameters != v
      self.parameters = v
    end
  end

end
