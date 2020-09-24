# frozen_string_literal: true

require "spec_helper"

module Api
  module Callbacks
    describe ServiceController, type: :controller do
      before(:all) do
        Service.create(name: "web", ref: "production")
      end

      let(:new_sha_value) { "bb8d05495e55a2f2311ccfe9521be955ca7d6395" }
      let(:request_params) {{ ref: new_sha_value }}
      let(:service_name) {{ service_name: "web" }}
      subject { Service.find_by(name: "web") }

      describe "POST #update" do
        it "returns success if service name is valid" do
          set_auth_header(request_params)
          post :update, params: service_name.merge(request_params)

          expect(response).to have_http_status(200)
          expect(subject.ref).to eq(new_sha_value)
        end

        it "returns bad request if service name is not valid" do
          set_auth_header(request_params)
          post :update, params: { service_name: "coconuts" }.merge(request_params)

          expect(response).to have_http_status(404)
          expect(JSON.parse(response.body)).to eq({ "error" => "Not Found" })
        end
      end

      describe "Authorization" do
        it "allows requests that have the correct MAC in the Authorization header" do
          set_auth_header(request_params)
          post :update, params: service_name.merge(request_params)

          expect(response).to have_http_status(200)
        end

        it "rejects requests that have incorrect MAC in the Authorization header" do
          digest = set_auth_header(request_params)
          set_auth_header(request_params, mac: '1234')
          post :update, params: service_name.merge(request_params)

          expect(response).to have_http_status(401)
          expect(JSON.parse(response.body)).to eq({ "error" => "Unauthorized Request: Authorization Header '1234' does not match Computed Digest '#{digest}'" })
        end

        it "rejects requests that do not have the Authorization header" do
          post :update, params: service_name.merge(request_params)

          expect(response).to have_http_status(401)
          expect(JSON.parse(response.body)).to eq({ "error" => "Unauthorized Request: Missing Authorization header" })
        end
      end

      def set_auth_header(body, mac: nil, secret_key: InvocaSecrets['pre_deploy_checker', 'api', 'auth_key'])
        @request.env['HTTP_AUTHORIZATION'] = mac || OpenSSL::HMAC.hexdigest('SHA256', secret_key, body.deep_stringify_keys.sort.to_s)
      end
    end
  end
end
