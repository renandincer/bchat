require 'sinatra'
require 'json'
require 'message'

@messages = []

# Create a new chat message
# body is a JSON Dict with from, to, message
post '/' do
  request.body.rewind
  body = request.body.read

  return 400, "please send a valid message" unless Message.correct_syntax(body)

  message = Message.new(body)
  @messages.push(message)
end
