require 'sinatra'
require 'json'
require_relative 'message'

messages = []
invalid_msg_error = { 'error' => 'please send a valid message' }

# before every request, set content type to json
before do
  content_type 'application/json'
end

# Create a new chat message
# body is a JSON Dict with from, to, message
post '/' do
  request.body.rewind
  body = request.body.read

  # TODO(renandincer): can think of ways not to parse json twice (exceptions)
  return 400, invalid_msg_error.to_json unless Message.correct_syntax(body)

  message = Message.json_create(body)
  messages.push(message)
  200
end

# Get messages between user_a and user_b.
# If time is specified, return only messages after that time.
get '/:user_a/:user_b/?:time?' do
  if params['time']
    # TODO(renandincer): add select time then return
  else
    return select_by_user(params['user_a'], params['user_b'], messages).to_json
  end
end

# make case sentitive comparasions of usernames and return all messages
def select_by_user(user_a, user_b, messages)
  messages.select do |msg|
    (msg.from == user_a && msg.to == user_b) ||
      (msg.to == user_a && msg.from == user_b)
  end
end
