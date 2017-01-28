require_relative 'sheet_property'

module GoogleSheet
  class Sheet
    def initialize(connection, spreadsheet, api_results)
      @connection = connection
      @spreadsheet = spreadsheet
      @api_results = api_results
    end

    def id
      @id ||= @api_results.properties.sheet_id
    end

    def title
      @title ||= @api_results.properties.title
    end

    def title=(value)
      @title = value
    end

    def index
      @index ||= @api_results.properties.index
    end

    def index=(value)
      @index = value
    end

    def save
      @connection.batch_update_spreadsheet(@spreadsheet.id, { requests: to_batch_update_request }, {} )
    end

    private

    def to_batch_update_request
      [
        {
          "update_sheet_properties": {
            "properties": { "sheet_id": id, "title": title },
            "fields": 'title'
          }
        },
        {
          "update_sheet_properties": {
            "properties": { "sheet_id": id, "index": index },
            "fields": 'index'
          }
        }
      ]
    end
  end
end
