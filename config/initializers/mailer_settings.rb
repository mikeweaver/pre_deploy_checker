# Setup mailer
#
require_relative '../secrets_config'

puts "Abc"
smtp_settings = InvocaSecrets["email", "smtp", "default"]
puts "123"
Rails.application.config.action_mailer.smtp_settings = smtp_settings
Mail.defaults { delivery_method :smtp, smtp_settings }
