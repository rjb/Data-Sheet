require 'fileutils'
require 'openssl'
require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'pry'

module GoogleSheet
  class Credentials
    OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'

    def initialize(auth_details = {})
      FileUtils.mkdir_p(File.dirname(auth_details[:credentials_path]))

      scope = auth_details[:scope]
      credentials_path = auth_details[:credentials_path]
      client_secrets_path = auth_details[:client_secrets_path]

      client_id = Google::Auth::ClientId.from_file(client_secrets_path)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: credentials_path)

      @user_authorizer = Google::Auth::UserAuthorizer.new(client_id, scope, token_store)
    end

     def oauth2_credentials
      user_id = 'default'
      @user_authorizer.get_credentials(user_id) || generate_credentials(user_id)
    end

    private

    def generate_credentials(user_id)
      url = @user_authorizer.get_authorization_url(base_url: OOB_URI)

      puts 'Open the following URL in your browser and enter the authorization code'
      puts url

      code = gets
      details = {
        user_id: user_id,
        code: code,
        base_url: OOB_URI
      }

      google_user_authorizer.get_and_store_credentials_from_code(details)
    end
  end
end

module GoogleSheet
  class Connection
    attr_reader :sheet

    def initialize(credentials)
      @sheet = Google::Apis::SheetsV4::SheetsService.new
      @sheet.authorization = credentials.oauth2_credentials
    end
  end
end

module GoogleSheet
  class Spreadsheet
    attr_reader :google_sheet

    def initialize(service, google_sheet)
      @service = service
      @google_sheet = google_sheet
    end

    def cells(range)
      connection.get_spreadsheet_values(id, range).values
    end

    def id
      @google_sheet.spreadsheet_id
    end

    private

    def connection
      @service.connection
    end
  end
end

module GoogleSheet
  class Service
    def initialize(auth_details = {})
      credentials = Credentials.new(auth_details)
      @connection = Connection.new(credentials)
    end

    def spreadsheet(id)
      @spreadsheet ||= Spreadsheet.new(self, connection.get_spreadsheet(id))
    end

    def connection
      @connection.sheet
    end
  end
end
