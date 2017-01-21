require 'fileutils'
require 'openssl'
require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'

module GoogleSheet
  class Auth
    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'

    attr_reader :scope
    attr_reader :credentials_path
    attr_reader :client_secrets_path
    attr_reader :google_user_authorizer

    def initialize(auth_details = {})
      FileUtils.mkdir_p(File.dirname(auth_details[:credentials_path]))

      @scope = auth_details[:scope]
      @credentials_path = auth_details[:credentials_path]
      @client_secrets_path = auth_details[:client_secrets_path]

      client_id = Google::Auth::ClientId.from_file(client_secrets_path)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: credentials_path)

      @google_user_authorizer = Google::Auth::UserAuthorizer.new(client_id, scope, token_store)
    end

    def oauth2_credentials
      user_id = 'default'
      google_user_authorizer.get_credentials(user_id) || generate_credentials(user_id)
    end

    private

    def generate_credentials(user_id)
      url = google_user_authorizer.get_authorization_url(base_url: OOB_URI)

      puts 'Open the following URL in your browser and enter the authorization code'
      puts url

      code = gets
      token = {
        user_id: user_id,
        code: code,
        base_url: OOB_URI
      }

      google_user_authorizer.get_and_store_credentials_from_code(token)
    end
  end
end

module GoogleSheet
  class Service
    attr_reader :auth

    def initialize(auth_details = {})
      @auth = Auth.new(auth_details)
      @google_sheets_service = Google::Apis::SheetsV4::SheetsService.new
    end

    def sheet(id, range)
      @google_sheets_service.get_spreadsheet_values(id, range)
      
    end

    def authorize
      @google_sheets_service.authorization = @auth.oauth2_credentials
    end
  end
end
