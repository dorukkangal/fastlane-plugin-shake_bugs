$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

require 'simplecov'

# SimpleCov.minimum_coverage 95
SimpleCov.start

# This module is only used to check the environment is currently a testing env
module SpecHelper
end

require 'fastlane' # to import the Action super class
require 'fastlane/plugin/shake_bugs' # import the actual plugin

Fastlane.load_actions # load other actions (in case your plugin calls other actions or shared values)

RSpec.configure do |config|
  config.before(:example) do
    @missing = 'missing_file'
    @mapping = 'assets/android/mapping.txt'
    @dsym = 'assets/ios/sample.app.dSYM.zip'

    config.include(Message)
  end
end

def run_fastlane_action(action:, options:)
  action.run(
    FastlaneCore::Configuration.create(
      action.available_options, options
    )
  )
end
