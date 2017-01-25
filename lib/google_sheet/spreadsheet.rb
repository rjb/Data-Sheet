module GoogleSheet
  class Spreadsheet
    def initialize(connection, id, range)
      @data = connection.get_spreadsheet_values(id, range)
    end

    # E.g. [["MV Minnow", "Bulk Carrier"], ["MV Fullerton", "Tugboat"]]
    def values
      @data.values
    end
  end
end
