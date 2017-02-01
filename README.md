# Google-Sheet

### The lowdown
Read and write to Google Sheets.

### Sample implementation
```ruby
require_relative 'lib/google_sheet'

# OAuth 2.0 client IDs
client_id_path = 'secret.json'

# Initialize the service
service = GoogleSheet::Service.new(client_id_path)

# Set the Id of the spreadsheet
# e.g. https://docs.google.com/spreadsheets/d/SPREADSHEET_ID/edit#gid=0
spreadsheet_id = 'SPREADSHEET_ID'

# Read the spreadsheet
spreadsheet = service.spreadsheet(spreadsheet_id)

# Set the range. (Default range is 'A:Z')
range = 'A1:D5'

# Print out by rows
spreadsheet.values(range: range).each do |value|
  p value
end

# Print out by columns
spreadsheet.values(range: range, major_dimension: 'COLUMNS').each do |value|
  p value
end

# Print a list of sheet titles
spreadsheet.sheets.each do |sheet|
  puts sheet.title
end

# Update a sheet's title
spreadsheet.sheets[0].title = 'Movies'
spreadsheet.sheets[0].save

# Append rows of values to the end of sheet
cities = [
  ['London', 'UK'],
  ['Tokyo', 'Japan'],
  ['Bismarck', 'USA'],
  ['Madrid', 'Spain']
]
spreadsheet.sheets[0].append(cities)
```