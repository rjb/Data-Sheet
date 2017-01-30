require_relative 'update_request'

module GoogleSheet
  class Sheet
    UPDATABLE_PROPERTIES = %w(title index).freeze

    attr_reader :id
    attr_reader :spreadsheet_id
    attr_accessor :title
    attr_accessor :index

    def initialize(service, spreadsheet, id, title, index)
      @service = service
      @spreadsheet = spreadsheet
      @spreadsheet_id = spreadsheet.id
      @id = id
      @title = title
      @index = index
    end

    def values(opts = {})
      @values ||= load_values(opts)
    end

    def save
      @service.update(self)
    end

    private

    def load_values(opts = {})
      @service.get(:sheet_values, self, opts)
    end
  end
end
