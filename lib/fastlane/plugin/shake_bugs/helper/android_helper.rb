require_relative 'object_helper'
require_relative 'message_helper'

module Fastlane
  module Helper
    class AndroidHelper
      def self.application_id(apk)
        analyze_apk(apk, 'application-id')
      end

      def self.version_name(apk)
        analyze_apk(apk, 'version-name')
      end

      def self.version_code(apk)
        analyze_apk(apk, 'version-code')
      end

      def self.analyze_apk(apk, info_name)
        UI.user_error!(Message::ANDROID_HOME_NOT_SET) unless Helper::ObjectHelper.exist?(ENV['ANDROID_HOME'])

        if !ObjectHelper.exist?(apk) || !ObjectHelper.present?(info_name)
          return ''
        end

        result = `apkanalyzer manifest #{info_name} #{apk}`&.strip || ''
        UI.message("Apk analyzer -> #{info_name} of the #{apk} is '#{result}'")
        result
      end
    end
  end
end
