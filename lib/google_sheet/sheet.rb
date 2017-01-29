require_relative 'update_request'

module GoogleSheet
  class Sheet
    UPDATABLE_PROPERTIES = %w(title index).freeze

    attr_reader :id
    attr_accessor :title
    attr_accessor :index

    def initialize(connection, spreadsheet, api_results)
      @connection = connection
      @spreadsheet = spreadsheet
      @api_results = api_results
      set_properties
    end

    def values(opts = {})
      @values ||= load_values(opts)
    end

    def save
      UpdateRequest::Sheet.new(@connection, @spreadsheet, self).update!
    end

    private

    def load_values(opts = {})
      @connection.get_spreadsheet_values(@spreadsheet.id, "#{title}!A:Z", opts).values
    end

    def set_properties
      @id = @api_results.properties.sheet_id
      @title = @api_results.properties.title
      @index = @api_results.properties.index
    end
  end
end
