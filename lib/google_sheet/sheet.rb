require_relative 'update_request'

module GoogleSheet
  class Sheet
    UPDATABLE_PROPERTIES = %w(title index).freeze

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
      UpdateRequest::Sheet.new(@connection, @spreadsheet, self).update!
    end
  end
end
