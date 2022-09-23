# shake_bugs plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-shake_bugs)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-shake_bugs`, add it to your project by running:

```bash
fastlane add_plugin shake_bugs
```

## About shake_bugs

Upload deobfuscation files for Android and symbolication files for iOS to Shake

### Uploading Proguard Mapping File
```ruby
  shake_bugs_upload_proguard_mapping(
    client_id: '...',
    client_secret: '...',
    application_id: '...', # Do not use if using apk
    version_name: '...', # Do not use if using apk
    version_code: '...', # Do not use if using apk
    mapping_file: 'path to mapping.txt to upload',
    apk: 'path to built apk file to upload'
  )
```

### Uploading Dsym File
```ruby
  shake_bugs_upload_dsym(
    client_id: '...',
    client_secret: '...',
    bundle_id: '...', # Do not use if using ipa
    version_number: '...', # Do not use if using ipa
    build_number: '...', # Do not use if using ipa
    dsym_file: 'path to YourApp.app.dSYM.zip to upload',
    ipa: 'path to built ipa file to upload'
  )
```

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
