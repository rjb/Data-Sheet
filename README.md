# Google-Sheet

Read and write to Google Sheets.

```ruby
require_relative 'google_sheet'

auth_details = {
  scope: Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY,
  client_secrets_path: 'client_secret.json',
  credentials_path: File.join(Dir.home, '.credentials', 'sheets.googleapis.com-ruby-google-sheet.yaml')
}

service = GoogleSheet::Service.new(auth_details)
service.authorize

sheet_id = 'SHEET-ID-HERE'
cell_range = 'Sheet1!A1:D4'

sheet = service.sheet(sheet_id, cell_range)
sheet.values.each { |row| p row }
```
