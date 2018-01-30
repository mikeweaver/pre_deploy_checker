module Api
  module Callbacks
    class JiraController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :parse_request

      def hook
        Rails.logger.info(
          "Received JIRA issue update callback. Adding to delayed job queue. Current queue depth: #{Delayed::Job.count}"
        )
        JiraHookHandler.new.queue!(@payload)
        render(nothing: true, status: :ok)
      end

      private

      def parse_request
        @payload = JSON.parse(request.body.read)
      rescue JSON::ParserError
        render(text: 'Invalid JSON', status: :bad_request)
      end
    end
  end
end
