socket = io()

socket.on 'fitnessEntry', (msg) ->
  msg.sort((oneElement, nextElement) ->
    return oneElement[0]-nextElement[0])
  entryIndex = 0
  while entryIndex < msg.length
    content = ''
    for foodItem in msg[entryIndex][1]
      content+= ', ' + foodItem[1].toLowerCase()
    content = msg[entryIndex][0] + content
    if entryIndex%2 is 1
      $('#entries').append($('<li id="entryZE">').text(content))
    else
      $('#entries').append($('<li id="entryON">').text(content))    
    entryIndex++