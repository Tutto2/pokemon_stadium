require 'singleton'

class BattleLog
  include Singleton

  def initialize
    @messages = MessagesQueue.new
  end

  def log(message, type = :subtitle)
    @messages.enqueue([type, message])
  end

  def display_messages
    until @messages.empty?
      type, msg = @messages.dequeue
      case type 
      when :subtitle then puts msg
      when :fillable then print msg
      else
        puts "#{type}:#{type.class}"
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