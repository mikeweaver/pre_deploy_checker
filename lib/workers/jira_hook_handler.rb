class JiraHookHandler
  PROCESSING_QUEUE = 'jira_hook_handler'.freeze

  def queue!(payload)
    Rails.logger.info('Processing JIRA hook')
    jira_issue = JIRA::Resource::IssueFactory.new(nil).build(payload['issue'])
    Rails.logger.info(payload)

    pushes = Push.with_jira_issue(jira_issue.key)
    if pushes.any?
      Rails.logger.info("Queueing #{pushes.length} pushes related to JIRA issue #{jira_issue.key}")
      pushes.each do |push|
        PushChangeHandler.new.submit_push_for_processing!(push)
      end
    else
      Rails.logger.info("Ignoring JIRA issue #{jira_issue.key} because it is not related to any existing pushes")
    end
  end
  handle_asynchronously(:queue!, queue: PROCESSING_QUEUE)
end
