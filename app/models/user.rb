class User < ActiveRecord::Base
  include GitModels::User

  def self.create_from_jira_data!(jira_user_data)
    User.where(name: jira_user_data.displayName, email: jira_user_data.emailAddress).first_or_create!
  end
end
