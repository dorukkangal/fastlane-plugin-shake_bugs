describe Fastlane do
  describe Fastlane::FastFile do
    describe 'dsym upload test' do
      it 'fails if there is no specified or generated dsym file' do
        expect do
          run_fastlane_action(
            action: Fastlane::Actions::ShakeBugsUploadDsymAction,
            options: {
              client_id: ENV['CLIENT_ID'],
              client_secret: ENV['CLIENT_SECRET']
            }
          )
        end.to raise_error(Message::MISSING_DSYM_FILE)
      end

      it 'fails if specified dsym file is not exist' do
        expect do
          run_fastlane_action(
            action: Fastlane::Actions::ShakeBugsUploadDsymAction,
            options: {
              client_id: ENV['CLIENT_ID'],
              client_secret: ENV['CLIENT_SECRET'],
              dsym_file: @missing
            }
          )
        end.to raise_error(Message.dsym_not_found(@missing))
      end

      it 'fails if application id is not specified and no ipa for extraction' do
        expect do
          run_fastlane_action(
            action: Fastlane::Actions::ShakeBugsUploadDsymAction,
            options: {
              client_id: ENV['CLIENT_ID'],
              client_secret: ENV['CLIENT_SECRET'],
              dsym_file: @dsym
            }
          )
        end.to raise_error(Message::MISSING_BUNDLE_ID)
      end

      it 'fails if version number is not specified and no ipa for extraction' do
        expect do
          run_fastlane_action(
            action: Fastlane::Actions::ShakeBugsUploadDsymAction,
            options: {
              client_id: ENV['CLIENT_ID'],
              client_secret: ENV['CLIENT_SECRET'],
              dsym_file: @dsym,
              bundle_id: 'com.shake.test'
            }
          )
        end.to raise_error(Message::MISSING_VERSION_NUMBER)
      end

      it 'fails if version code is not specified and no ipa for extraction' do
        expect do
          run_fastlane_action(
            action: Fastlane::Actions::ShakeBugsUploadDsymAction,
            options: {
              client_id: ENV['CLIENT_ID'],
              client_secret: ENV['CLIENT_SECRET'],
              dsym_file: @dsym,
              bundle_id: 'com.shake.test',
              version_number: '1.0.0'
            }
          )
        end.to raise_error(Message::MISSING_BUILD_NUMBER)
      end

      it 'fails if specified ipa is not exist' do
        expect do
          run_fastlane_action(
            action: Fastlane::Actions::ShakeBugsUploadDsymAction,
            options: {
              client_id: ENV['CLIENT_ID'],
              client_secret: ENV['CLIENT_SECRET'],
              dsym_file: @dsym,
              ipa: @missing
            }
          )
        end.to raise_error(Message.ipa_not_found(@missing))
      end
    end
  end
end
