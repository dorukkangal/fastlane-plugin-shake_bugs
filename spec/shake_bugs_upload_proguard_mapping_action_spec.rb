describe Fastlane do
  describe Fastlane::FastFile do
    describe 'proguard mapping upload test' do
      it 'fails if there is no specified or generated mapping file' do
        expect do
          run_fastlane_action(
            action: Fastlane::Actions::ShakeBugsUploadProguardMappingAction,
            options: {
              client_id: ENV['CLIENT_ID'],
              client_secret: ENV['CLIENT_SECRET']
            }
          )
        end.to raise_error(Message::MISSING_MAPPING_FILE)
      end

      it 'fails if specified mapping file is not exist' do
        expect do
          run_fastlane_action(
            action: Fastlane::Actions::ShakeBugsUploadProguardMappingAction,
            options: {
              client_id: ENV['CLIENT_ID'],
              client_secret: ENV['CLIENT_SECRET'],
              mapping_file: @missing
            }
          )
        end.to raise_error(Message.mapping_not_found(@missing))
      end

      it 'fails if application id is not specified and no apk for extraction' do
        expect do
          run_fastlane_action(
            action: Fastlane::Actions::ShakeBugsUploadProguardMappingAction,
            options: {
              client_id: ENV['CLIENT_ID'],
              client_secret: ENV['CLIENT_SECRET'],
              mapping_file: @mapping
            }
          )
        end.to raise_error(Message::MISSING_APPLICATION_ID)
      end

      it 'fails if version name is not specified and no apk for extraction' do
        expect do
          run_fastlane_action(
            action: Fastlane::Actions::ShakeBugsUploadProguardMappingAction,
            options: {
              client_id: ENV['CLIENT_ID'],
              client_secret: ENV['CLIENT_SECRET'],
              mapping_file: @mapping,
              application_id: 'com.shake.test'
            }
          )
        end.to raise_error(Message::MISSING_VERSION_NAME)
      end

      it 'fails if version code is not specified and no apk for extraction' do
        expect do
          run_fastlane_action(
            action: Fastlane::Actions::ShakeBugsUploadProguardMappingAction,
            options: {
              client_id: ENV['CLIENT_ID'],
              client_secret: ENV['CLIENT_SECRET'],
              mapping_file: @mapping,
              application_id: 'com.shake.test',
              version_name: '1.0.0'
            }
          )
        end.to raise_error(Message::MISSING_VERSION_CODE)
      end

      it 'fails if specified apk is not exist' do
        expect do
          run_fastlane_action(
            action: Fastlane::Actions::ShakeBugsUploadProguardMappingAction,
            options: {
              client_id: ENV['CLIENT_ID'],
              client_secret: ENV['CLIENT_SECRET'],
              mapping_file: @mapping,
              apk: @missing
            }
          )
        end.to raise_error(Message.apk_not_found(@missing))
      end
    end
  end
end
