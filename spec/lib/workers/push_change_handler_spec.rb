require 'spec_helper'

describe 'PushChangeHandler' do
  let(:payload) { Github::Api::PushHookPayload.new(load_json_fixture('github_push_payload')) }
  let(:push) { Push.create_from_github_data!(payload).first }

  before(:all) do
    AncestorRef.find_or_create_by!(service_name: 'web')
  end

  def mock_status_request(state, description)
    api = instance_double(Github::Api::Status)
    expect(api).to receive(:set_status).with('OwnerName/reponame',
                                             '6d8cc7db8021d3dbf90a4ebd378d2ecb97c2bc25',
                                             PushChangeHandler::CONTEXT_NAME,
                                             state.to_s,
                                             description,
                                             anything).and_return({})
    expect(Github::Api::Status).to receive(:new).and_return(api)
  end

  def mock_failed_status_request
    api = instance_double(Github::Api::Status)
    expect(api).to receive(:set_status).and_raise(Net::HTTPClientException.new(nil, nil))
    expect(Github::Api::Status).to receive(:new).and_return(api)
  end

  it 'can create be constructed' do
    handler = PushChangeHandler.new
    expect(handler).not_to be_nil
  end

  it 'sets GitHub push and push model status when submitted for processing' do
    mock_status_request(
      Github::Api::Status::STATE_PENDING,
      PushChangeHandler::STATE_DESCRIPTIONS[Github::Api::Status::STATE_PENDING]
    )

    push.status = Github::Api::Status::STATE_FAILED
    push.save!
    PushChangeHandler.new.submit_push_for_processing!(push)

    # a job should be queued
    expect(Delayed::Job.count).to eq(1)

    # the model status should be updated
    expect(push.reload.status).to eq(Github::Api::Status::STATE_PENDING.to_s)
  end

  it 'sets GitHub push status after processing' do
    mock_status_request(
      Github::Api::Status::STATE_SUCCESS,
      PushChangeHandler::STATE_DESCRIPTIONS[Github::Api::Status::STATE_SUCCESS]
    )

    expect(PushManager).to receive(:process_push!) do |push|
      push.status = Github::Api::Status::STATE_SUCCESS.to_s
      push.save!
      push
    end

    PushChangeHandler.new.process_push!(push.id)

    # a job should be queued
    expect(Delayed::Job.count).to eq(1)

    # process the job
    expect(Delayed::Worker.new.work_off).to eq([1, 0])
  end

  it 'retries if it cannot set the GitHub push status' do
    mock_failed_status_request

    expect(PushManager).to receive(:process_push!) do |push|
      push.status = Github::Api::Status::STATE_SUCCESS.to_s
      push.save!
      push
    end

    PushChangeHandler.new.process_push!(push.id)

    # a job should be queued
    expect(Delayed::Job.count).to eq(1)

    # process the job, it will fail
    expect(Delayed::Worker.new.work_off).to eq([0, 1])

    # the job should still be queued
    expect(Delayed::Job.count).to eq(1)
  end
end
