module GoogleSheet
  class Spreadsheet
    attr_reader :values
    attr_reader :google_spreadsheet

    def initialize(connection, id)
      @id = id
      @connection = connection
      @google_spreadsheet = @connection.get_spreadsheet(@id)
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

      @values ||= @connection.get_spreadsheet_values(@id, range, params).values
    end
  end
end
