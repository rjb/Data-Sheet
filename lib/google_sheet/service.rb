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

    def spreadsheet(id)
      Spreadsheet.new(self, id)
    end

    def get(type, obj, opts = {})
      case type
      when :sheets
        connection.get_spreadsheet(obj.id).sheets
      when :sheet_values
        title = obj.title + '!A:Z'
        spreadsheet_id = obj.spreadsheet_id
        connection.get_spreadsheet_values(spreadsheet_id, title, opts).values
      end
    end
  end
end
