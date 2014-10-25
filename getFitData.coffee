fs = require 'fs'
redis = require 'node-redis'
client = redis.createClient()

putDataInRedisDataBase = (seperatedCSV) ->
  for row in seperatedCSV
    theDate = row[0]
    rowIndex = 0
    while rowIndex < (row.length - 3)
      if row[rowIndex + 3].length
        client.sadd(theDate, row[rowIndex + 3])
      rowIndex++

  dateToCheck = '20141006'
  client.smembers dateToCheck, (err, reply) ->
      console.log 'SMEMBERS OF ' + dateToCheck + ' : ' + reply.toString()
      # SMEMBERS OF 20141006 : 35; Seaweed,311; Pepperoni Pizza,310; Vegetable Juice,200; Latte,605; Breakfast Burrito
  client.quit()

organizeData = (err, data) ->
  rows = []
  characterIndex = 0
  thisRow = []
  thisCell = ''

  for datum in data
    switch datum
      when ','
        thisRow.push thisCell
        thisCell = []
      when '\n'
        thisRow.push thisCell
        thisCell = []
        rows.push thisRow
        thisRow = []
      else
        thisCell += datum

  putDataInRedisDataBase(rows)

# Fit Log IV.csv is a spreadsheet of my diet for the last two months.
# It includes every calorie I have eaten during that period.
# The first column is the date, as the concatenation of the numerical year, month, and day
# Every column beyond the third is in the form <calories in food item>;<food item>
fitlog = fs.readFile('Fit Log IV.csv', 'utf8', organizeData)