class Events
  attr_reader :events

  def initialize
    @events = {}
  end

  def add_listener(event:, id:, once: false, &block)
    raise 'must specify id' unless id
    raise 'must specify callback' unless block_given?

    # I tried to initialize @events = Hash.new(Hash.new([])) but for some
    # reason that breaks down below and doesn't populate the hash keys
    # correctly
    @events[event] = {} unless @events[event]

    @events[event][id] = [block, once]
  end

  def remove_listener(event:, id:)
    @events[event].delete(id)
  end

  def trigger(event)
    return unless @events.has_key?(event)

    @events[event].each { |id, (block, once)|
      remove_listener(event: event, id: id) if once
      block.call
    }
  end
end
