class DeployMailer < ApplicationMailer
  include InlineStylesMailer
  default from: 'deployments@invoca.net'
  use_stylesheet 'table.scss'

  def deployment_email(jira_issues)
    @jira_issues = jira_issues
    mail(to: 'deploy@invoca.com', subject: "Deploy #{Time.now.strftime('%m/%d/%y').getlocal}")
  end
end
