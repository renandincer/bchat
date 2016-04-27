require 'sinatra'
require 'json'
require 'message'

@messages = []
invalid_msg_error = { 'error' => 'please send a valid message' }

# Create a new chat message
# body is a JSON Dict with from, to, message
post '/' do
  request.body.rewind
  body = request.body.read

  return 400, invalid_msg_error.to_json unless Message.correct_syntax(body)

  message = Message.new(body)
  @messages.push(message)
end
