socket = io()

socket.on 'Food Content Entries', (msg) ->
  msg.sort((oneElement, nextElement) ->
    return oneElement[0]-nextElement[0])
  entryIndex = 0
  $('#entries').empty()
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

socket.on 'Food Calories Entries', (msg) ->
  msg.sort((oneElement, nextElement) ->
    return oneElement[0]-nextElement[0])
  entryIndex = 0
  $('#entries').empty()
  while entryIndex < msg.length
    content = ''
    sumOfCalories = 0
    for foodItem in msg[entryIndex][1]
      sumOfCalories += parseInt(foodItem[0])
    colorOfSum = '#0ACA1A'
    if sumOfCalories > 1500
      colorOfSum = '#F3D31b'
    if sumOfCalories > 1600
      colorOfSum = '#F21D23'
    content = msg[entryIndex][0] + ' : ' + sumOfCalories.toString()
    if entryIndex%2 is 1
      $('#entries').append($('<li id="entryZE" style=" color:'+colorOfSum+';">').text(content))
    else
      $('#entries').append($('<li id="entryON" style=" color:'+colorOfSum+';">').text(content))    
    entryIndex++

$('#caloriesPress').click (event) ->
  socket.emit('Food Calories Request')
  return false

$('#contentPress').click (event) ->
  socket.emit('Food Content Request')
  return false
