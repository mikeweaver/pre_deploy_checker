# frozen_string_literal: true

require 'spec_helper'

describe Jira::Status::PushController, type: :controller do
  render_views

  before(:each) do
    user = User.create!(name: 'First Last', email: 'flast@email.com')
    repo = Repository.new(name: 'master')
    repo.save!
    branch = Branch.create!(author: user, repository: repo, name: 'feature_branch', git_updated_at: Time.now)
    commit = Commit.create!(sha: '12345678', message: 'This is the head commit', author: user)
    @push = Push.create!(status: :success, branch: branch, head_commit: commit)
  end

  describe 'email' do
    after(:each) do
      DeployEmailInterceptor.clear_email
    end

    it 'sends an email and returns success for push' do
      allow(Time).to receive(:now).and_return(Time.gm(2020, 7, 4, 12, 0))
      get :deploy_email, params: { id: '12345678' }
      expect(response).to have_http_status(302)
      expect(flash[:alert]).to match(/Email has been sent/)

      sent_email = DeployEmailInterceptor.intercepted_email
      expect(sent_email.to).to eq ['deploy@invoca.com']
      expect(sent_email.from).to eq ['deploy@invoca.com']
      expect(sent_email.subject).to eq("Web Deploy 07/04/20 05:00 -0700")
      expect(@push.reload.email_sent).to eq(true)
    end

    it 'doesnt send an email and returns success if email has already been sent' do
      @push.update_attributes(email_sent: true)
      get :deploy_email, params: { id: '12345678' }
      expect(response).to have_http_status(302)
      expect(flash[:alert]).to match(/Email was already sent/)
      expect(DeployEmailInterceptor.intercepted_email).to eq(nil)
    end

    it 'does not set email_sent to true if sending the email raises an error' do
      exception = ArgumentError.new("Bad args")
      expect(DeployMailer).to receive(:deployment_email) { raise exception }

      expect { get :deploy_email, params: { id: '12345678' } }.to raise_error(exception)
      expect(@push.reload.email_sent).to eq(false)
    end

    it 'redirects to summary page if commit not found with sha matching id' do
      get :deploy_email, params: { id: 'abc' }
      expect(response).to have_http_status(302)
      expect(response.redirect_url).to eq('http://test.host/400')
    end
  end

  describe "ancestor_sha" do
    subject { @push }

    it "is set to master by default" do
      expect(subject.ancestor_sha).to eq("master")
    end

    context "when updating" do
      it "is overriden with the new value" do
        new_sha_value = "bb8d05495e55a2f2311ccfe9521be955ca7d6395"
        post :ancestor_sha, id: "12345678", ancestor_sha: new_sha_value
        expect(response).to have_http_status(200)

        expect(subject.reload.ancestor_sha).to eq(new_sha_value)
      end
    end

    context "when getting" do
      it "returns the current value" do
        get :ancestor_sha, id: "12345678"
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq({ "ancestor_sha" => "master" })
      end

      it "handles invalid pushes" do
        expected_body = "<html><body>You are being <a href=\"http://test.host/400\">redirected</a>.</body></html>"
        get :ancestor_sha, id: "bogus_push"
        expect(response).to have_http_status(302)
        expect(response.body).to eq(expected_body)
      end
    end
  end
end
