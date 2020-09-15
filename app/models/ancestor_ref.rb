# frozen_string_literal: true

class AncestorRef < ActiveRecord::Base
  DEFAULT_ANCESTOR_BRANCH = 'master'

  fields do
    ref          :string, limit: 40,  required: true, default: 'master'
    service_name :string, limit: 255, required: true
  end

  validates_presence_of :service_name, :ref
end
