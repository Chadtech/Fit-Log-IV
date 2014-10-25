express = require 'express'
path = require 'path'
app = express()
http = require('http').Server(app)
io = require('socket.io')(http)
redis = require 'node-redis'
fs = require 'fs'
async = require 'async'

redisClient = redis.createClient()

arrayAddition = (arrayLeft, arrayRight) ->
  sum = []
  if arrayLeft isnt undefined
    if arrayRight isnt undefined
      for element in arrayLeft
        sum.push element
      for element in arrayRight
        sum.push element
      return sum

seperateAtSemiColon = (toBeSeperated) ->
  firstSegment = ''
  secondSegment = ''
  pivot = true
  for character in toBeSeperated
    if character is ';'
      pivot = false
    else
      if pivot 
        firstSegment += character
      else
        secondSegment += character
  return [firstSegment, secondSegment]

entriesToStrings = (entry, next) ->
  next(null, seperateAtSemiColon(entry.toString()))

deliverKeyAndEntries = (key, next) ->
  redisClient.smembers key.toString(), (err, smembersOf) ->
    if smembersOf isnt undefined
      async.map(smembersOf, entriesToStrings, (err, entries) ->
        next(null, arrayAddition([key.toString()],[entries]) ) )
    else
      next(null, 'EMPTY')

app.use(express.static(path.join(__dirname, 'importantFiles')))

app.get '/', (request, response) ->
  response.sendFile(__dirname + '/fitlogfour.html')

io.on 'connection', (socket) ->
  console.log 'Fit Log IV Client Connected'
  redisClient.keys '*', (err, keys) ->
    async.map keys, deliverKeyAndEntries, (err, result) ->
      async.filter result, 
        (item, next) ->
          if item is 'EMPTY'
            return next(false)
          else
            return next(true)
        (resultOfFilter) ->
          io.emit('fitnessEntry', resultOfFilter)

portNumber = 3001

http.listen portNumber, () ->
  console.log 'Listening on *: ' + portNumber.toString()