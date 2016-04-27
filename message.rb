#Message class to represent a im message
require 'json'

class Message
	attr_accessor :from, :to, :message, :time
	
	#initialize message
	def initialize(from, to, message)
		@from = from
		@to = to
		@message = message
		@time = Time.now
	end
end
