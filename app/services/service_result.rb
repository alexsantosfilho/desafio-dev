class ServiceResult
  attr_reader :error_message

  def initialize(success:, error_message: nil)
    @success = success
    @error_message = error_message
  end

  def success?
    @success
  end

  def self.success
    new(success: true)
  end

  def self.failure(error_message)
    new(success: false, error_message: error_message)
  end
end
