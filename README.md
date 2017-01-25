# Google-Sheet

Read and write to Google Sheets.

```ruby
require_relative 'lib/google_sheet'

client_id_path = 'secret.json'

service = GoogleSheet::Service.new(client_id_path)

range = 'Sheet1!A1:D4'
sheet_id = 'SHEET-ID'

sheet = service.sheet_values(sheet_id, range)
sheet.values.each do |value|
  p value
end
```
