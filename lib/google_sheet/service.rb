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
      attr_reader :response

      def initialize(response)
        @response = response
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

    def sheets(spreadsheet, opts = {})
      connection.get_spreadsheet(spreadsheet.id, opts).sheets
    end

    def sheet_values(sheet, opts = {})
      range = sheet.title + '!A:Z'
      spreadsheet_id = sheet.spreadsheet.id
      connection.get_spreadsheet_values(spreadsheet_id, range, opts).values
    end

    def update(sheet)
      response = connection.batch_update_spreadsheet(sheet.spreadsheet.id, update_requests(sheet), {})
      UpdateSheetResponse.new(response)
    end

    def append(spreadsheet_id, values, range, opts = {})
      value_range = Google::Apis::SheetsV4::ValueRange.new(values: values)
      response = connection.append_spreadsheet_value(spreadsheet_id, range, value_range, opts)
      AppendSheetResponse.new(response)
    end

    private

    def update_requests(sheet)
      { requests: property_requests(sheet) }
    end

    def property_requests(sheet)
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
