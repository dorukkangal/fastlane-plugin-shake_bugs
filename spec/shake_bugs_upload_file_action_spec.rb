describe Fastlane do
  describe Fastlane::FastFile do
    describe 'authentication test' do
      it 'fails if client_id is unspecified or empty' do
        expect do
          Fastlane::FastFile.new.parse('
          lane :test do
            shake_bugs_upload_proguard_mapping
          end').runner.execute(:test)
        end.to raise_error(Message::MISSING_CLIENT_ID)
      end

      it 'fails if client_secret is unspecified or empty' do
        expect do
          Fastlane::FastFile.new.parse('
          lane :test do
            shake_bugs_upload_proguard_mapping(
              client_id: "CLIENT_ID"
            )
          end').runner.execute(:test)
        end.to raise_error(Message::MISSING_CLIENT_SECRET)
      end

      it 'fails if credentials are not valid' do
        expect do
          Fastlane::FastFile.new.parse('
          lane :test do
            shake_bugs_upload_proguard_mapping(
              client_id: "CLIENT_ID",
              client_secret: "CLIENT_SECRET"
            )
          end').runner.execute(:test)
        end.to raise_error(Message::AUTHENTICATION_FAILED)
      end
    end
  end
end
