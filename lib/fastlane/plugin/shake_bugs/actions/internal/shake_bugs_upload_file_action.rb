require 'fastlane/action'
require_relative '../../helper/upload_helper'
require_relative '../../helper/object_helper'
require_relative '../../helper/message_helper'

module Fastlane
  module Actions
    class ShakeBugsUploadFileAction < Action
      def self.run(options)
        @access_token = Helper::UploadHelper.get_access_token(
          client_id: options[:client_id],
          client_secret: options[:client_secret]
        )
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :client_id,
                                       env_name: 'SHAKE_CLIENT_ID',
                                       description: 'The actual client id you have in your workspace settings',
                                       optional: false,
                                       type: String,
                                       verify_block: proc do |value|
                                         UI.user_error!(Message::MISSING_CLIENT_ID) unless Helper::ObjectHelper.present?(value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :client_secret,
                                       env_name: 'SHAKE_CLIENT_SECRET',
                                       description: 'The actual client secret you have in your workspace settings',
                                       optional: false,
                                       type: String,
                                       verify_block: proc do |value|
                                         UI.user_error!(Message::MISSING_CLIENT_SECRET) unless Helper::ObjectHelper.present?(value)
                                       end)
        ] + other_options
      end

      def self.other_options
        []
      end

      def self.authors
        ['Doruk Kangal']
      end
    end
  end
end
