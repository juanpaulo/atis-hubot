# Description:
#   Travel related     
#
# Notes:
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md
#   
#   
#   
#

module.exports = (robot) ->

  parseWeather = ( szWeather ) ->
    if szWeather.match /cloud/i 
      return "Seems nice, but might rain who knows, bring an umbrella. Funny umbrella maybe?\nhttp://m.cdn.blog.hu/mi/mindentkibir/image/funny-umbrella.jpg"
    if szWeather.match /rain/i 
      return "Too bad, definitely bring an umbrella. Boots will come in handy. Something like this?\nhttps://s-media-cache-ak0.pinimg.com/736x/0b/8a/6a/0b8a6a4500e8d0f5665a14ac9eff2ff8.jpg"
    if szWeather.match /sun/i 
      return "Great weather today, get some tan. Yeah?\nhttp://files.stv.tv/imagebase/124/623x349/124748-summer-sunshine-quality-image-of-student-lisa-rennie-in-westburn-park-aberdeen-in-hot-sunny-weather.jpg"
    if szWeather.match /typhoon/i 
      return "It is not really a good time to go out for work or play.\nhttp://thepathadventures.com/wp-content/uploads/2015/01/Typhoon.jpg"


# Commands/interactions

  robot.hear /weather/i, (res) ->
    robot.http("http://api.openweathermap.org/data/2.5/weather?q=Tokyo,jp")
      .header('Accept', 'application/json')
      .get() (err, response, body) ->
         data = JSON.parse(body)
         res.send(data)
         szWeather = data.weather[0].description
         res.send "Today's weather is #{szWeather}"

         szRes = parseWeather( szWeather )
         res.send szRes
       
