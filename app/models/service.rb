# frozen_string_literal: true

class Service < ActiveRecord::Base
  DEFAULT_ANCESTOR_BRANCH = 'master'

  fields do
    name :string, limit: 255, required: true
    ref  :string, limit: 255,  required: true, default: 'master'
  end

  index [:name], unique: true
  validates_presence_of :name, :ref
  validates_uniqueness_of :name
end
