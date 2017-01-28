module GoogleSheet
  class UpdateRequest
    class Sheet
      def initialize(connection, spreadsheet, sheet)
        @connection = connection
        @spreadsheet = spreadsheet
        @sheet = sheet
      end

      def update!
        @connection.batch_update_spreadsheet(@spreadsheet.id, { requests: batch_update_requests }, {} )
      end

      private

      def batch_update_requests
        GoogleSheet::Sheet::UPDATABLE_PROPERTIES.map do |updateable_property|
          property_request(updateable_property, @sheet.send(updateable_property))
        end
      end

      def property_request(field, value)
        {
          "update_sheet_properties": {
            "properties": { "sheet_id": @sheet.id, "#{field}": value },
            "fields": field
          }
        }
      end
    end
  end
end
