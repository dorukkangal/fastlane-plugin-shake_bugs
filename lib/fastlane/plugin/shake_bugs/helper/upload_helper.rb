require 'faraday'
require 'faraday/multipart'
require 'signet'
require 'signet/oauth_2/client'
require_relative 'message_helper'

module Fastlane
  module Helper
    class UploadHelper
      @api = 'https://api.shakebugs.com'

      def self.get_access_token(client_id:, client_secret:)
        client = Signet::OAuth2::Client.new(
          token_credential_uri: "#{@api}/auth/oauth2/token",
          client_id: client_id,
          client_secret: client_secret
        )
        client.grant_type = 'client_credentials'
        client.fetch_access_token!
        UI.success(Message::AUTHENTICATION_SUCCEEDED)
        client.access_token
      rescue Signet::AuthorizationError => _e
        UI.user_error!(Message::AUTHENTICATION_FAILED)
      rescue StandardError => e
        UI.user_error!("Unknown error: #{e}")
      end

      def self.upload_mapping_file(access_token:, mapping_file:, application_id:, version_name:, version_code:, platform:)
        UI.message("Mapping file uploading...")
        UI.message("mapping_file:'#{mapping_file}'")
        UI.message("application_id:'#{application_id}'")
        UI.message("version_name:'#{version_name}'")
        UI.message("version_code:'#{version_code}'")

        @client = Faraday.new do |builder|
          builder.use(Faraday::Response::RaiseError)
          builder.request(:multipart)
          builder.request(:url_encoded)
        end

        begin
          @client.post("#{@api}/api/1.0/crash_reporting/app_debug_file/#{application_id}") do |request|
            request.headers['Authorization'] = "Bearer #{access_token}"
            request.body = {
              file: Faraday::Multipart::FilePart.new(mapping_file, 'text/plain'),
              app_version_name: version_name,
              app_version_code: version_code,
              os: platform,
              platform: platform
            }
          end
          UI.success(Message::UPLOAD_SUCCEEDED)
        rescue StandardError => e
          UI.user_error!(Message.upload_failed(e))
        end
      end
    end
  end
end
