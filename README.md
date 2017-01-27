# Google-Sheet

Read and write to Google Sheets.

```ruby
require_relative 'lib/google_sheet'

client_id_path = 'secret.json'

service = GoogleSheet::Service.new(client_id_path)

range = 'Sheet1!A1:D4'
sheet_id = 'SHEET-ID'

spreadsheet = service.spreadsheet(sheet_id)
spreadsheet.values.each do |value|
  p value
end
```
