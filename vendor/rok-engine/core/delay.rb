class Delay
  include Node

  attr_reader :event, :length, :timer

  def initialize(event: nil, length:, &block)
    @event = event
    @block = block
    @length = length
    @timer = 0
  end

  def update(delta)
    @timer += delta
    if @timer >= @length
      trigger(@event) if @event
      @block.call if @block
      remove_self
    end
  end

  def clear
    remove_self
  end
end
