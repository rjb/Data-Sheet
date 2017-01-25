require 'google/apis/sheets_v4'

module GoogleSheet
  class Connection
    attr_reader :service

    def initialize(credentials)
      @service = Google::Apis::SheetsV4::SheetsService.new
      @service.authorization = credentials
    end
  end
end
