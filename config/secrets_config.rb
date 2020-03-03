# frozen_string_literal: true

require 'invoca_secrets'

# Note: normally we'd put this in config/initializers, but the web repo needs to have secrets configured very early
# so that ActiveTableSet can be configured very early to support the bootstrap process. Both are configured from
# application.rb.

InvocaSecrets.instance =
  if ENV['VAULT_TOKEN'].present?
    InvocaSecrets.factory(environment: Rails.env,
                          config_folder: Rails.root.join('config'),
                          console: defined?(Rails::Console))
  else
    InvocaSecrets::Stores::Local.new(Rails.root.join('config', 'dev_secrets.yml'))
  end
