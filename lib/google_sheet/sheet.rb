module GoogleSheet
  class Sheet
    UPDATABLE_PROPERTIES = %w(title index).freeze

    attr_reader :id
    attr_reader :spreadsheet
    attr_accessor :title
    attr_accessor :index

    def initialize(service, spreadsheet, id, title, index)
      @service = service
      @spreadsheet = spreadsheet
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
