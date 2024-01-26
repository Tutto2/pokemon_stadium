require 'singleton'

class BattleLog
  include Singleton

  def initialize
    @messages = MessagesQueue.new
  end

  def log(message)
    @messages.enqueue(message)
  end

  def display_messages
    until @messages.empty?
      puts @messages.dequeue
      puts
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