# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->

  parseWeather = ( szWeather ) ->
    if szWeather.match /cloud/i 
      return "Seems nice, but might rain who knows, bring an umbrella."
    if szWeather.match /rain/i 
      return "Too bad, definitely bring an umbrella. Boots will come in handy"
    if szWeather.match /sun/i 
      return "Great weather today, get some tan."
    if szWeather.match /typhoon/i 
      return "It is not really a good time to go out for work or play."

  robot.hear /we/i, (res) ->
    robot.http("http://api.openweathermap.org/data/2.5/weather?q=Tokyo,jp")
      .header('Accept', 'application/json')
      .get() (err, response, body) ->
         data = JSON.parse(body)
         res.send(data)
         szWeather = data.weather[0].description
         res.send "Today's weather is #{szWeather}"

         szRes = parseWeather( szWeather )
         res.send szRes
       
  robot.hear /yellow/i, (res) ->
    res.send "green!"

#        
#         else
#            console.log "E-mail is invalid”
#
#emailPattern = /// ^ #begin of line
#   ([\w.-]+)         #one or more letters, numbers, _ . or -
#   @                 #followed by an @ sign
#   ([\w.-]+)         #then one or more letters, numbers, _ . or -
#   \.                #followed by a period
#   ([a-zA-Z.]{2,6})  #followed by 2 to 6 letters or periods
#   $ ///i            #end of line and ignore case
# 
#if "john.smith@gmail.com".match emailPattern
#   console.log "E-mail is valid"
#else
#   console.log "E-mail is invalid”
