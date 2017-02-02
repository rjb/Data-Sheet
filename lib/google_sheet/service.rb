require_relative 'token_store'
require_relative 'connection'
require_relative 'spreadsheet'

module GoogleSheet
  class Service
    class UpdateSheetResponse
      attr_reader :response

      def initialize(response)
        @response = response
      end
    end

    class AppendSheetResponse
      attr_reader :updates

      def initialize(updates)
        @updates = updates
      end
    end

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
        spreadsheet_id = obj.spreadsheet.id
        connection.get_spreadsheet_values(spreadsheet_id, title, opts).values
      end
    end

    def update(sheet)
      spreadsheet_id = sheet.spreadsheet.id
      requests = { requests: batch_update_requests(sheet) }
      response = connection.batch_update_spreadsheet(spreadsheet_id, requests, {})
      UpdateSheetResponse.new(response)
    end

    def append(spreadsheet_id, values, range, opts = {})
      value_range = Google::Apis::SheetsV4::ValueRange.new(values: values)
      response = connection.append_spreadsheet_value(spreadsheet_id, range, value_range, opts)
      AppendSheetResponse.new(response.updates)
    end

    private

    def batch_update_requests(sheet)
      GoogleSheet::Sheet::UPDATABLE_PROPERTIES.map do |updateable_property|
        property_request(sheet, updateable_property)
      end
    end

    def property_request(sheet, field)
      {
        "update_sheet_properties": {
          "properties": { "sheet_id": sheet.id, "#{field}": sheet.send(field) },
          "fields": field
        }
      }
    end
  end
end
