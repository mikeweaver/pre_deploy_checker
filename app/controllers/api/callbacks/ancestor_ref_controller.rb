# frozen_string_literal: true

module Api
  module Callbacks
    class AncestorRefController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :find_ancestor_ref

      def update
        Rails.logger.info("Received Github deploy callback. Updating #{params[:service_name]} with new ref #{params[:ref]}")
        @ancestor_ref.update!(ref: params[:ref])
        render json: { body: {} }, status: 200
      end

      private

      def find_ancestor_ref
        @ancestor_ref = AncestorRef.find_by!(service_name: params[:service_name])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Not Found" }, status: 404
      end
    end
  end
end
