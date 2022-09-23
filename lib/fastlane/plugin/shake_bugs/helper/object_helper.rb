module Fastlane
  module Helper
    class ObjectHelper
      def self.present?(str)
        !str.nil? && !str.strip.empty?
      end

      def self.exist?(file_name)
        present?(file_name) && File.exist?(file_name)
      end

      def self.version_code(apk)
        analyze_apk(apk, 'version-code')
      end
    end
  end
end
