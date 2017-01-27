module GoogleSheet
  class SheetProperty
    attr_reader :index
    attr_reader :title

    def initialize(args)
      @index = args[:index]
      @title = args[:title]
    end
  end
end
