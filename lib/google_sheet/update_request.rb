module GoogleSheet
  class UpdateRequest
    class Sheet
      def initialize(service, spreadsheet, sheet)
        @service = service
        @spreadsheet = spreadsheet
        @sheet = sheet
      end

      def update!
        @service.connection.batch_update_spreadsheet(@spreadsheet.id, { requests: batch_update_requests }, {} )
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
