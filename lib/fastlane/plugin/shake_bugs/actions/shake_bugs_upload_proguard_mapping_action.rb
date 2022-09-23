require 'fastlane/action'
require_relative 'internal/shake_bugs_upload_file_action'
require_relative '../helper/android_helper'
require_relative '../helper/upload_helper'
require_relative '../helper/object_helper'
require_relative '../helper/message_helper'

module Fastlane
  module Actions
    class ShakeBugsUploadProguardMappingAction < ShakeBugsUploadFileAction
      def self.run(options)
        super

        mapping_file = options[:mapping_file]
        UI.user_error!(Message.mapping_not_found(mapping_file)) if Helper::ObjectHelper.present?(mapping_file) && !Helper::ObjectHelper.exist?(mapping_file)

        mapping_file = Actions.lane_context[SharedValues::GRADLE_MAPPING_TXT_OUTPUT_PATH] unless Helper::ObjectHelper.present?(mapping_file)
        UI.user_error!(Message::MISSING_MAPPING_FILE) unless Helper::ObjectHelper.exist?(mapping_file)

        apk = options[:apk]
        UI.user_error!(Message.apk_not_found(apk)) if Helper::ObjectHelper.present?(apk) && !Helper::ObjectHelper.exist?(apk)
        apk = Actions.lane_context[SharedValues::GRADLE_APK_OUTPUT_PATH] unless Helper::ObjectHelper.exist?(apk)

        application_id = options[:application_id] || Helper::AndroidHelper.application_id(apk)
        UI.user_error!(Message::MISSING_APPLICATION_ID) unless Helper::ObjectHelper.present?(application_id)

        version_name = options[:version_name] || Helper::AndroidHelper.version_name(apk)
        UI.user_error!(Message::MISSING_VERSION_NAME) unless Helper::ObjectHelper.present?(version_name)

        version_code = options[:version_code] || Helper::AndroidHelper.version_code(apk)
        UI.user_error!(Message::MISSING_VERSION_CODE) unless Helper::ObjectHelper.present?(version_code)

        Helper::UploadHelper.upload_mapping_file(
          access_token: @access_token,
          mapping_file: mapping_file,
          application_id: application_id,
          version_name: version_name,
          version_code: version_code,
          platform: 'Android'
        )
      end

      def self.other_options
        [
          FastlaneCore::ConfigItem.new(key: :mapping_file,
                                       env_name: 'ANDROID_MAPPING_TXT_PATH',
                                       description: 'The path to the mapping.txt file to upload',
                                       optional: true,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :apk,
                                       env_name: 'ANDROID_APK_PATH',
                                       description: 'The path to the newly built apk file',
                                       optional: true,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :application_id,
                                       env_name: 'ANDROID_APPLICATION_ID',
                                       description: 'The application id of your app',
                                       optional: true,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :version_name,
                                       env_name: 'ANDROID_VERSION_NAME',
                                       description: 'The current version name set on your project',
                                       optional: true,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :version_code,
                                       env_name: 'ANDROID_VERSION_CODE',
                                       description: 'The current version code set on your project',
                                       optional: true,
                                       type: String)
        ]
      end

      def self.is_supported?(platform)
        platform == :android
      end

      def self.description
        'Upload mapping files for Android to Shake'
      end

      def self.details
        'This action is used to upload de-obfuscation files to Shake'
      end
    end
  end
end
