require 'singleton'

class BattleLog
  include Singleton

  def initialize
    @messages = MessagesQueue.new
  end

  def log(message, type = :subtitle)
    @messages.enqueue({type => message})
  end

  def display_messages
    until @messages.empty?
      msg = @messages.dequeue
      if msg.keys.first == :subtitle
        puts msg.values.first
      else
        print msg.values.first
      end
    end
  end
end

class MessagesQueue
  def initialize
    @elements = []
  end

  def enqueue(message)
    @elements.push(message)
  end

  def dequeue
    @elements.shift
  end

  def size
    @elements.size
  end

  def empty?
    @elements.empty?
  end
end