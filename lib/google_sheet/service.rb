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

    def sheet(id)
      @sheet ||= Spreadsheet.new(connection, id)
    end
  end
end
