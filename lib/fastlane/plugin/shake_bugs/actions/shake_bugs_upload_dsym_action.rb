require 'fastlane/action'
require_relative 'internal/shake_bugs_upload_file_action'
require_relative '../helper/ios_helper'
require_relative '../helper/upload_helper'
require_relative '../helper/object_helper'
require_relative '../helper/message_helper'

module Fastlane
  module Actions
    class ShakeBugsUploadDsymAction < ShakeBugsUploadFileAction
      def self.run(options)
        super

        dsym_file = options[:dsym_file]
        UI.user_error!(Message.dsym_not_found(dsym_file)) if Helper::ObjectHelper.present?(dsym_file) && !Helper::ObjectHelper.exist?(dsym_file)

        dsym_file = Actions.lane_context[SharedValues::DSYM_OUTPUT_PATH] unless Helper::ObjectHelper.present?(dsym_file)
        UI.user_error!(Message::MISSING_DSYM_FILE) unless Helper::ObjectHelper.exist?(dsym_file)

        ipa = options[:ipa]
        UI.user_error!(Message.ipa_not_found(ipa)) if Helper::ObjectHelper.present?(ipa) && !Helper::ObjectHelper.exist?(ipa)
        ipa = Actions.lane_context[SharedValues::IPA_OUTPUT_PATH] unless Helper::ObjectHelper.exist?(ipa)

        bundle_id = options[:bundle_id] || Helper::IosHelper.bundle_id(ipa)
        UI.user_error!(Message::MISSING_BUNDLE_ID) unless Helper::ObjectHelper.present?(bundle_id)

        version_number = options[:version_number] || Helper::IosHelper.version_number(ipa)
        UI.user_error!(Message::MISSING_VERSION_NUMBER) unless Helper::ObjectHelper.present?(version_number)

        build_number = options[:build_number] || Helper::IosHelper.build_number(ipa)
        UI.user_error!(Message::MISSING_BUILD_NUMBER) unless Helper::ObjectHelper.present?(build_number)

        Helper::UploadHelper.upload_mapping_file(
          access_token: @access_token,
          mapping_file: dsym_file,
          application_id: bundle_id,
          version_name: version_number,
          version_code: build_number,
          platform: 'iOS'
        )
      end

      def self.other_options
        [
          FastlaneCore::ConfigItem.new(key: :dsym_file,
                                       env_name: 'IOS_DSYM_PATH',
                                       description: 'The path to the dsym file to upload',
                                       optional: true,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :ipa,
                                       env_name: 'IOS_IPA_PATH',
                                       description: 'The path to the newly built ipa file',
                                       optional: true,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :bundle_id,
                                       env_name: 'IOS_BUNDLE_ID',
                                       description: 'The bundle id of your app',
                                       optional: true,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :version_number,
                                       env_name: 'IOS_VERSION_NUMBER',
                                       description: 'The current version number set on your project',
                                       optional: true,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :build_number,
                                       env_name: 'IOS_BUILD_NUMBER',
                                       description: 'The current build number set on your project',
                                       optional: true,
                                       type: String)
        ]
      end

      def self.is_supported?(platform)
        platform == :ios
      end

      def self.description
        'Upload dsym files for iOS to Shake'
      end

      def self.details
        'This action is used to upload symbolication files to Shake'
      end
    end
  end
end
