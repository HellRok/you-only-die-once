class Fade
  include Node

  attr_reader :duration, :timer

  def initialize(duration, &block)
    raise 'must specify callback' unless block_given?

    @duration = duration
    @callback = block
    @timer = 0
    @colour = Colour.new(0, 0, 0, opacity)
    @rectangle = Rectangle.new(0, 0, get_screen_width, get_screen_height)
  end

  def render
    draw_rectangle_rec(@rectangle, @colour)
  end

  def update(delta)
    @timer += delta
    @colour.alpha = opacity

    if @timer >= @duration
      @callback.call
      remove_self
    end
  end

  def opacity
    255 - (255 * (@timer / @duration))
  end
end
