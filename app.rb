require 'sinatra'
require 'json'
require 'message'

@messages = []

# Create a new chat message
# body is a JSON Dict with from, to, message
post '/' do
	request.body.rewind
	body = request.body.read

  if not Message.correct_syntax(body)
	  return 400, "please send a valid message"
	end

	message = Message.new(body)
	@messages.push(message)
end

# Get messages between user_a and user_b.
# If time is specified, return only messages after that time.
get '/:user_a/:user_b/:time?' do

	user_a = params['user_a']
	user_b = params['user_b']

	#time has been specified
	if params['time']
		@messages.reverse_each do |message|
			messages_after_timestamp = 
		end
	else
		return select_user_messages(params['user_a'], params['user_b'], @messages)
	end
end

# make case sentitive comparasions of usernames and return all messages
def select_user_messages(u1, u2, messages)
	return messages.select{ |msg|
		(msg.from == u1 and msg.to == u2) or 
		(msg.to == u1 and msg.from == u2)
	}
end
