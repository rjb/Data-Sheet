require 'mysql2'
require 'openssl'
require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'
require 'date'

module DataSheet
  class Authentication
    def self.service(authorization_details)
      service = Google::Apis::SheetsV4::SheetsService.new
      service.authorization = authorize(authorization_details)
      service
    end

    private

    def self.authorize(authorization_details)
      FileUtils.mkdir_p(File.dirname(authorization_details[:credentials_path]))
      
      client_id = Google::Auth::ClientId.from_file(authorization_details[:client_secrets_path])
      token_store = Google::Auth::Stores::FileTokenStore.new(file: authorization_details[:credentials_path])
      authorizer = Google::Auth::UserAuthorizer.new(client_id, authorization_details[:scope], token_store)
      
      user_id = 'default'
      credentials = authorizer.get_credentials(user_id)
      
      if credentials.nil?
        puts "Open the following URL in the browser and enter the resulting code after authorization"
        puts authorizer.get_authorization_url(base_url: authorization_details[:oob_uri])

        credentials = authorizer.get_and_store_credentials_from_code(
          user_id: user_id,
          code: gets,
          base_url: authorization_details[:oob_uri]
        )
      end

      credentials
    end
  end
end

module DataSheet
  class GoogleService
    attr_reader :application_name

    def initialize(authorization_details)
      @service = Authentication::service(authorization_details)
    end

    def spreadsheet_values(spreadsheet_id, range)
      @service.get_spreadsheet_values(spreadsheet_id, range)
    end

    def self.oauth(client_credentials, opts = {})
      @application_name = opts[:application_name] || ''

      authorization_details = {
        oob_uri: 'urn:ietf:wg:oauth:2.0:oob',
        client_secrets_path: client_credentials,
        credentials_path: File.join(Dir.home, '.credentials', "sheets.googleapis.com-ruby-quickstart.yaml"),
        scope: Google::Apis::SheetsV4::AUTH_SPREADSHEETS
      }

      GoogleService.new(authorization_details)
    end
  end
end
