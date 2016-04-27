require 'json'

# Message class to represent a im message
class Message
  attr_accessor :from, :to, :message, :time

  # initialize message
  def initialize(from, to, message)
    @from = from
    @to = to
    @message = message
    @time = Time.now
  end

  # convert message into json object
  def to_json(*a)
    {
      'from' => @from,
      'to' => @to,
      'message' => @message,
      'at' => @time.to_i
    }.to_json(*a)
  end

  # create a message from a json object
  def self.json_create(o)
    msg = JSON.parse(o)
    new(msg['from'], msg['to'], msg['message'])
  end

  # check syntax for incoming message objects
  def self.correct_syntax(o)
    msg = JSON.parse(o)
    return false if !msg['from'] || !msg['to'] || !msg['message']
    return false if msg['from'] === "" || !msg['to'] === ""
    true
  end
end
