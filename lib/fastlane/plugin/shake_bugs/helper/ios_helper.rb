require 'fastlane/actions/get_ipa_info_plist_value'
require_relative 'object_helper'

module Fastlane
  module Helper
    class IosHelper
      def self.bundle_id(ipa)
        analyze_ipa(ipa, 'CFBundleIdentifier')
      end

      def self.version_number(ipa)
        analyze_ipa(ipa, 'CFBundleShortVersionString')
      end

      def self.build_number(ipa)
        analyze_ipa(ipa, 'CFBundleVersion')
      end

      def self.analyze_ipa(ipa, info_name)
        if !ObjectHelper.exist?(ipa) || !ObjectHelper.present?(info_name)
          return ''
        end

        result = Actions::GetIpaInfoPlistValueAction.run(ipa: ipa, key: info_name)&.strip || ''
        UI.message("Ipa analyzer -> #{info_name} of the #{ipa} is '#{result}'")
        result
      end
    end
  end
end
