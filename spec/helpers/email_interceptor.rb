class DeployEmailInterceptor
  class << self
    attr_reader :intercepted_email

    def clear_email
      @intercepted_email = nil
    end

    def delivering_email(message)
      @intercepted_email = message
    end
  end
end
