# frozen_string_literal: true

module Api
  module Callbacks
    class ServiceController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :find_service

      def update
        Rails.logger.info("Received DeployBot deploy callback. Updating #{params[:service_name]} with new ref #{params[:ref]}")
        @service.update!(ref: params[:ref])
        render json: { body: {} }, status: 200
      end

      private

      def find_service
        @service = Service.find_by!(name: params[:service_name])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Not Found" }, status: 404
      end
    end
  end
end
