require 'googleauth'
require 'google/apis/sheets_v4'
require 'googleauth/stores/file_token_store'
require_relative 'authorizer'

module GoogleSheet
  class TokenStore
    DEFAULT_SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS
    DEFAULT_CREDENTIALS_PATH = File.join(Dir.home, '.credentials', 'sheets.googleapis.com-myapp.yaml')

    def initialize(client_id_path, options = {})
      @scope = options[:scope] || DEFAULT_SCOPE
      @client_id = Google::Auth::ClientId.from_file(client_id_path)
      @credentials_path = options[:credentials_path] || DEFAULT_CREDENTIALS_PATH

      FileUtils.mkdir_p(File.dirname(@credentials_path))
      @token_store = Google::Auth::Stores::FileTokenStore.new(file: @credentials_path)
    end

    def credentials
      @authorizer ||= Authorizer.new(@client_id, @scope, @token_store)
      @authorizer.credentials
    end
  end
end
