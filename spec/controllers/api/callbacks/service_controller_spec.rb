# frozen_string_literal: true

require "spec_helper"

module Api
  module Callbacks
    describe ServiceController, type: :controller do
      before(:all) do
        Service.create(name: "web", ref: "production")
      end

      let(:new_sha_value) { "bb8d05495e55a2f2311ccfe9521be955ca7d6395" }
      subject { Service.find_by(name: "web") }

      describe "POST #update" do
        it "returns success if service name is valid" do
          params = { service_name: "web", ref: new_sha_value }
          set_auth_header(params)
          post :update, params: params

          expect(response).to have_http_status(200)
          expect(subject.ref).to eq(new_sha_value)
        end

        it "returns bad request if service name is not valid" do
          params = { service_name: "coconuts", ref: new_sha_value }
          set_auth_header(params)
          post :update, params: params

          expect(response).to have_http_status(404)
          expect(JSON.parse(response.body)).to eq({ "error" => "Not Found" })
        end
      end

      describe "Authorization" do
        let(:params) { { service_name: "we_be_authing", ref: "hey" } }

        it "allows requests that have the correct MAC in the Authorization header" do
          set_auth_header(params)
          post :update, params: params

          expect(response).to have_http_status(200)
        end

        it "rejects requests that have incorrect MAC in the Authorization header" do
          digest = set_auth_header(params)
          set_auth_header(params, mac: '1234')
          post :update, params: params

          expect(response).to have_http_status(401)
          expect(JSON.parse(response.body)).to eq({ "error" => "Unauthorized Request: Authorization Header '1234' does not match Computed Digest '#{digest}'" })
        end

        it "rejects requests that do not have the Authorization header" do
          post :update, params: params

          expect(response).to have_http_status(401)
          expect(JSON.parse(response.body)).to eq({ "error" => "Unauthorized Request: Missing Authorization header" })
        end
      end

      def set_auth_header(body, mac: nil, secret_key: InvocaSecrets['pre_deploy_checker', 'service', 'secret_key'])
        @request.env['HTTP_AUTHORIZATION'] = mac || OpenSSL::HMAC.hexdigest('SHA256', secret_key, body.deep_stringify_keys.sort.to_s)
      end
    end
  end
end
