require 'spec_helper'

describe 'JiraHookHandler' do
  def jira_payload
    @jira_payload ||= load_json_fixture('jira_hook_payload')
  end

  def github_payload
    @github_payload ||= Github::Api::PushHookPayload.new(load_json_fixture('github_push_payload'))
  end

  it 'can create be constructed' do
    handler = JiraHookHandler.new
    expect(handler).not_to be_nil
  end

  it 'should submit pushes for processing' do
    push = Push.create_from_github_data!(github_payload)
    JiraIssuesAndPushes.create_or_update!(create_test_jira_issue(key: 'STORY-4380'), push)

    expect_any_instance_of(PushChangeHandler).to receive(:submit_push_for_processing!)

    JiraHookHandler.new.queue!(jira_payload)

    # a job should be queued
    expect(Delayed::Job.count).to eq(1)

    # process the job
    expect(Delayed::Worker.new.work_off(1)).to eq([1, 0])
  end

  it 'does not process hooks for issues that have no pushes associated with them' do
    expect_any_instance_of(PushChangeHandler).not_to receive(:submit_push_for_processing!)
    GlobalSettings.jira.ignore_branches << '.*branch_name'

    JiraHookHandler.new.queue!(jira_payload)

    # a job should be queued
    expect(Delayed::Job.count).to eq(1)

    # process the job
    expect(Delayed::Worker.new.work_off(1)).to eq([1, 0])
  end
end
