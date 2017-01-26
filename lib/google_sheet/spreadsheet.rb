module GoogleSheet
  class Spreadsheet
    attr_reader :values

    def initialize(connection, id)
      @id = id
      @connection = connection
    end

    def values(range = 'A:Z')
      @values ||= @connection.get_spreadsheet_values(@id, range).values
    end
  end
end
