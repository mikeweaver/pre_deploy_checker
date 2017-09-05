class Branch < ApplicationRecord
  include GitModels::Branch

  has_many :pushes, class_name: Push, dependent: :destroy
end
