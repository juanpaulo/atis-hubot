# Description:
#   Travel related     
#
# Notes:
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md
#   
#   
#   
# \nhttp://m.cdn.blog.hu/mi/mindentkibir/image/funny-umbrella.jpg
#  Something like this?\nhttps://s-media-cache-ak0.pinimg.com/736x/0b/8a/6a/0b8a6a4500e8d0f5665a14ac9eff2ff8.jpg
#  Yeah?\nhttp://files.stv.tv/imagebase/124/623x349/124748-summer-sunshine-quality-image-of-student-lisa-rennie-in-westburn-park-aberdeen-in-hot-sunny-weather.jpg
# \nhttp://thepathadventures.com/wp-content/uploads/2015/01/Typhoon.jpg
#


module.exports = (robot) ->

  parseWeather = ( szWeather ) ->
    if szWeather.match /cloud/i 
      return "Seems nice, but might rain who knows, bring an umbrella. Funny umbrella maybe?"
    if szWeather.match /rain/i 
      return "Too bad, definitely bring an umbrella. Boots will come in handy."
    if szWeather.match /sun/i 
      return "Great weather today, get some tan."
    if szWeather.match /typhoon|hurricane/i 
      return "It is not really a good time to go out for work or play."

  parseLocation = ( szLocation ) ->
    return "Tokyo"
#    objMatch =  szLocation.match //i

# Commands/interactions

  robot.hear /weather(.*)/i, (res) ->
    szLocation = parseLocation(res.match[1])
    robot.http("https://george-vustrey-weather.p.mashape.com/api.php?location=Tokyo")
      .header("X-Mashape-Key", "FUeh4iLLcLmshwe7qxFXzx4f2Xsep1017EXjsnNTMNqT6saZYr")
      .header('Accept', 'application/json')
      .get() (err, response, body) ->
         data = JSON.parse(body)
         res.send "\n#{szLocation}'s weather for the week.\n----"
         for aggDay in data
           res.send "#{aggDay.day_of_week} : #{aggDay.condition}"


  robot.respond /open the (.*) doors/i, (res) ->
    doorType = res.match[1]
    if doorType is "pod bay"
      res.reply "I'm afraid I can't let you do that."
    else
      res.reply "Opening #{doorType} doors"
