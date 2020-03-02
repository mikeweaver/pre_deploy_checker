# Setup mailer

smtp_settings = InvocaSecrets['email', 'smtp', 'default'].symbolize_keys
Rails.application.config.action_mailer.smtp_settings = smtp_settings
Mail.defaults { delivery_method :smtp, smtp_settings }
