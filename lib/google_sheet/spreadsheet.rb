require_relative 'sheet'

module GoogleSheet
  class Spreadsheet
    attr_reader :id
    attr_reader :values
    attr_reader :sheets

    def initialize(connection, id)
      @id = id
      @connection = connection
    end

    def sheets
      @sheets ||= @connection.get_spreadsheet(id).sheets.map do |api_sheet|
        Sheet.new(@connection, self, api_sheet)
      end
    end

    def sheet_by_title(title)
      sheets.select { |sheet| sheet.title == title }.first
    end

    def sheet_by_index(index)
      sheets.select { |sheet| sheet.index == index }.first
    end
  end
end
