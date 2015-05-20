# Description:
#   Yoda
#
# Notes:
#   TODO

module.exports = (robot) ->

  robot.hear /yodanization (.*)/i, (res) ->
    sentence = res.match[1]
    robot.http("https://yoda.p.mashape.com/yoda?sentence=#{sentence}")
      .header("X-Mashape-Key", "FUeh4iLLcLmshwe7qxFXzx4f2Xsep1017EXjsnNTMNqT6saZYr")
      .get() (err, response, body) ->
        res.send(body)
