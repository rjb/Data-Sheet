require_relative 'token_store'
require_relative 'connection'
require_relative 'spreadsheet'

module GoogleSheet
  class Service
    def initialize(client_id_path)
      file_token_store = TokenStore.new(client_id_path)
      @connection = Connection.new(file_token_store.credentials)
    end

    def connection
      @connection.service
    end

    def sheet_values(id, range)
      @sheet ||= Spreadsheet.new(connection, id, range)
    end
  end
end
