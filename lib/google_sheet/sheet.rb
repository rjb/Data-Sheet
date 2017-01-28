module GoogleSheet
  class Sheet
    attr_writer :title
    attr_writer :index

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

    def index
      @index ||= @api_results.properties.index
    end

    def save
      @connection.batch_update_spreadsheet(@spreadsheet.id, { requests: batch_update_requests }, {} )
    end

    private

    def batch_update_requests
      [update_title_request, update_index_request]
    end

    def update_title_request
      {
        "update_sheet_properties": {
          "properties": { "sheet_id": id, "title": title },
          "fields": 'title'
        }
      }
    end

    def update_index_request
      {
        "update_sheet_properties": {
          "properties": { "sheet_id": id, "index": index },
          "fields": 'index'
        }
      }
    end
  end
end
