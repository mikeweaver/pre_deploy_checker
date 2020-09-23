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
          post :update, service_name: "web", ref: new_sha_value
          expect(response).to have_http_status(200)
          expect(subject.ref).to eq(new_sha_value)
        end

        it "returns bad request if service name is not valid" do
          post :update, service_name: "coconuts", ref: new_sha_value
          expect(response).to have_http_status(404)
          expect(JSON.parse(response.body)).to eq({ "error" => "Not Found" })
        end
      end
    end
  end
end
