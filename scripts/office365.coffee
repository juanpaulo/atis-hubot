# Description:
#   Office 365
#
# Notes:
#   TODO
#
#   API reference: https://msdn.microsoft.com/en-us/office/office365/api/api-catalog

module.exports = (robot) ->

  username = process.env.OUTLOOK_365_USERNAME
  password = process.env.OUTLOOK_365_PASSWORD

  robot.hear /get calendar events for (.*)/i, (res) ->
    dateStr = res.match[1] #TODO match today, tomorrow, on Monday, etc.
    dateObj = new Date(dateStr)
    nextDateObj = new Date(dateStr)
    nextDateObj.setDate(dateObj.getDate() + 1)
    robot.http("https://outlook.office365.com/api/v1.0/me/calendarview?startDateTime=#{dateObj.toISOString()}&endDateTime=#{nextDateObj.toISOString()}") #TODO add sorting
      .auth(username, password)
      .get() (err, response, body) ->
        data = JSON.parse(body)
        res.reply "You have #{data.value.length} event/s on: #{dateObj.toISOString()}"
        res.send "#{formatTime(val.Start)}~#{formatTime(val.End)}: #{val.Subject} @#{val.Location.DisplayName}" for val in data.value #TODO remove @ when Location is undefined

  robot.hear /create calendar event (.*) from (.*) to (.*)/i, (res) -> #TODO refine parsers, include other params like body, attendees
    subject = res.match[1]
    startDateTime = new Date(res.match[2])
    endDateTime = new Date(res.match[3])
    data = JSON.stringify({
      "Subject": "#{subject}",
      "Start": "#{startDateTime.toISOString()}",
      "End": "#{endDateTime.toISOString()}"
    })
    robot.http("https://outlook.office365.com/api/v1.0/me/events")
      .auth(username, password)
      .header('Content-Type', 'application/json')
      .post(data) (err, resp, body) ->
        if err
          res.send "Encountered an error :( #{err}"
          return
        res.send "#{subject} created."

  robot.hear /send (.*) message (.*)/i, (res) ->
    #TODO change data by messageType
    subject = res.match[1]
    body = res.match[2]
    todayDate = new Date()
    data = JSON.stringify({
      "Message": {
        "Subject": "[Attendance] Paulo #{formatDate(todayDate)}", #TODO dynamic
        "Body": {
          "ContentType": "Text",
          "Content": "#{body}"
        },
        "ToRecipients": [
          {
            "EmailAddress": {
              "Address": "juanpaulo.gutierrez@gmail.com" #TODO parameter or env variable?
            }
          }
        ]
      }
    })
    robot.http("https://outlook.office365.com/api/v1.0/me/sendmail")
    .auth(username, password)
      .auth(username, password)
      .header('Content-Type', 'application/json')
      .post(data) (err, resp, body) ->
        if err
          res.send "Encountered an error :( #{err}"
          return
        res.send "#{body}"
        res.send "#{subject} sent."

  robot.hear /get unread messages/i, (res) ->
    #TODO switch by filters
    robot.http("https://outlook.office365.com/api/v1.0/me/messages?$filter=IsRead eq false")
      .auth(username, password)
      .get() (err, response, body) ->
        data = JSON.parse(body)
        res.reply "You have #{data.value.length} unread message/s:"
        res.send "#{val.From.EmailAddress.Name}: #{val.Subject}" for val in data.value

  robot.hear /analyze sentiments from Weekly Reports/i, (res) ->
    robot.http("https://outlook.office365.com/api/v1.0/me/folders/AAMkADM4OTEwMmEyLTc0MDQtNDYyYS04OTI0LTRkNTk4MTUwNDVjMwAuAAAAAADTQeIvd0RIQakmXUxMPIYvAQAWL6djGBzrQ4ENCJrvtPWsADsX3QA4AAA=/messages?$top=10")
      .auth(username, password)
      .get() (err, response, body) ->
        data = JSON.parse(body)
        analyzeSentiment(res, val.From.EmailAddress.Name, val.BodyPreview) for val in data.value

  formatTime = (dateTimeStr) ->
    dateObj = new Date(dateTimeStr)
    return dateObj.toLocaleTimeString()

  formatDate = (dateTimeStr) ->
    dateObj = new Date(dateTimeStr)
    return dateObj.toLocaleDateString()

  analyzeSentiment = (msg, fromName, bodyPreview) ->
    robot.http("https://loudelement-free-natural-language-processing-service.p.mashape.com/nlp-text/?text=#{bodyPreview}") #TODO escape?
      .header("X-Mashape-Key", "FUeh4iLLcLmshwe7qxFXzx4f2Xsep1017EXjsnNTMNqT6saZYr")
      .get() (child_err, child_response, child_body) ->
        child_data = JSON.parse(child_body)
        msg.send "#{fromName} is feeling #{child_data['sentiment-text']} (#{child_data['sentiment-score']})."
