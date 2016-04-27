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
  user_a = params['user_a']
  user_b = params['user_b']
  return select_by_user(user_a, user_b, messages).to_json unless params['time']
  new_messages = []
  messages.reverse_each do |msg|
    break if msg.time.to_i <= params['time'].to_i
    new_messages << msg
  end
  return select_by_user(user_a, user_b, new_messages).to_json
end

# make case sentitive comparasions of usernames and return all messages
def select_by_user(user_a, user_b, messages)
  messages.select do |msg|
    (msg.from == user_a && msg.to == user_b) ||
      (msg.to == user_a && msg.from == user_b)
  end
end
