# frozen_string_literal: true

require 'invoca_secrets'

InvocaSecrets.instance =
  if ENV['VAULT_TOKEN'].present?
    InvocaSecrets.factory(environment: Rails.env,
                          config_folder: Rails.root.join('config'),
                          console: defined?(Rails::Console))
  else
    InvocaSecrets::Stores::Local.new(Rails.root.join('config', 'dev_secrets.yml'))
  end
