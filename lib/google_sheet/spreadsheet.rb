require_relative 'sheet'

module GoogleSheet
  class Spreadsheet
    attr_reader :id
    attr_reader :values
    attr_reader :sheets

    def initialize(service, id)
      @id = id
      @service = service
    end

    def sheets
      @sheets ||= @service.get(:sheets, self).map do |api_sheet|
        index = api_sheet.properties.index
        title = api_sheet.properties.title
        Sheet.new(@service, self, title, index)
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
