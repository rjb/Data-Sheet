require_relative 'sheet'

module GoogleSheet
  class Spreadsheet
    attr_reader :id
    attr_reader :values

    def initialize(connection, id)
      @id = id
      @connection = connection
    end

    def sheets
      results = []
      google_spreadsheet.sheets.each do |google_sheet|
        results << Sheet.new(google_sheet)
      end
      results
    end

    def values(options = {})
      range = options[:range] || 'A:Z'

      params = {
        fields: options[:fields] || nil,
        quota_user: options[:quota_user] || nil,
        major_dimension: options[:major_dimension] || nil,
        value_render_option: options[:value_render_option] || nil,
        date_time_render_option: options[:date_time_render_option] || nil,
      }

      @connection.get_spreadsheet_values(@id, range, params).values
    end

    def google_spreadsheet
      @connection.get_spreadsheet(@id)
    end
  end
end
