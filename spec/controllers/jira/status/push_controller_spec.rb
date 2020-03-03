require 'spec_helper'

describe Jira::Status::PushController, type: :controller do
  render_views

  describe 'email' do
    before(:each) do
      user = User.create!(name: 'First Last', email: 'flast@email.com')
      repo = Repository.new(name: 'master')
      repo.save!
      branch = Branch.create!(author: user, repository: repo, name: 'feature_branch', git_updated_at: Time.now)
      commit = Commit.create!(sha: '12345678', message: 'This is the head commit', author: user)
      @push = Push.create!(status: :success, branch: branch, head_commit: commit)
    end

    after(:each) do
      DeployEmailInterceptor.clear_email
    end

    it 'sends an email and returns success for push' do
      get :deploy_email, id: '12345678'
      expect(response).to have_http_status(200)
      expect(response.body).to match(/Email has been sent/)

      sent_email = DeployEmailInterceptor.intercepted_email
      expect(sent_email.to).to eq ['deploy@invoca.com']
      expect(sent_email.from).to eq ['deployments@invoca.net']
      expect(sent_email.subject).to eq("Deploy #{Time.now.strftime('%m/%d/%y').getlocal}")
    end

    it 'doesnt send an email and returns success if email has already been sent' do
      @push.update_attributes(email_sent: true)
      get :deploy_email, id: '12345678'
      expect(response).to have_http_status(200)
      expect(response.body).to match(/Email was already sent/)
      expect(DeployEmailInterceptor.intercepted_email).to eq(nil)
    end

    it 'redirects to summary page if not commit not found with sha matchin id' do
      get :deploy_email, id: 'abc'
      expect(response).to have_http_status(302)
      expect(response.redirect_url).to eq('http://test.host/400')
    end
  end
end
