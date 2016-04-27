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

# Get messages between user_a and user_b.
# If time is specified, return only messages after that time.
get '/:user_a/:user_b/:time?' do
  if params['time']
    # TODO(renandincer): add select time then return
  else
    return select_by_user(params['user_a'], params['user_b'], @messages).to_json
  end
end

# make case sentitive comparasions of usernames and return all messages
def select_by_user(user_a, user_b, messages)
  messages.select do |msg|
    (msg.from == user_a && msg.to == user_b) ||
      (msg.to == user_a && msg.from == user_b)
  end
end
