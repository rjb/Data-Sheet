require_relative 'sheet_property'

module GoogleSheet
  class Sheet
    def initialize(google_sheet)
      @google_sheet = google_sheet
    end

    def title
      properties.title
    end

    def index
      properties.index
    end

    def properties
      @properties ||= SheetProperty.new(
        index: gs_properties.index,
        title: gs_properties.title
      )
    end

    def gs_properties
      @google_sheet.properties
    end
  end
end
