class User < ActiveRecord::Base
  include GitModels::User

  def self.create_from_jira_data!(jira_user_data)
    # JIRA removed emailAddress from their API so we create a fake one here. It is only used to guarantee uniqueness
    User.where(name: jira_user_data.displayName, email: "#{jira_user_data.name}@email.com").first_or_create!
  end
end
