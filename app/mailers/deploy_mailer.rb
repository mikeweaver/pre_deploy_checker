class DeployMailer < ApplicationMailer
  include InlineStylesMailer
  default from: "deployments@invoca.com"
  use_stylesheet "table.scss"

  def jira_url_for_issue(jira_issue)
    "#{Rails.application.secrets.jira['site']}/browse/#{jira_issue.key}"
  end

  def deployment_email(jira_issues)
    @jira_issues = jira_issues
    mail(to: "tstarck@invoca.com", subject: "Web Deploy #{Time.now.strftime('%m/%d/%y')}")
  end
end