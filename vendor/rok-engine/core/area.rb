AREA_DEBUG ||= false

class Area
  include Node

  attr_accessor :rectangle
  attr_reader :listeners

  def initialize(x, y, width, height)
    @debug_colour = Colour.new(0, 255, 0, 64) if AREA_DEBUG

    @position = Vector2.new(x, y)
    @rectangle = Rectangle.new(@position.x, @position.y, width, height)

    @listeners = []
  end

  def add_child_callback
    update(0)
  end

  def add_listener(listener, event:, debounce: 0)
    @listeners << {
      listener: listener,
      event: event,
      debounce: debounce,
      last_collided_at: debounce,
    }
  end

  def draw
    if AREA_DEBUG
      draw_rectangle_rec(@rectangle, @debug_colour)
      draw_text("#{@rectangle.x.round(2)}, #{@rectangle.y.round(2)}", @rectangle.x, @rectangle.y, 8, RAYWHITE)
      draw_text("#{@rectangle.width}x#{@rectangle.height}", @rectangle.x, @rectangle.y + 10, 8, RAYWHITE)
    end
  end

  def update(delta)
    if parent.respond_to?(:position)
      @rectangle.x = @position.x + parent.position.x
      @rectangle.y = @position.y + parent.position.y
    else
      @rectangle.x = @position.x
      @rectangle.y = @position.y
    end

    @listeners.each { |listener|
      listener[:last_collided_at] += delta

      if collided_with?(listener[:listener]) &&
          listener[:debounce] <= listener[:last_collided_at]
        listener[:last_collided_at] = 0
        trigger(listener[:event])
      end
    }
  end

  def collided_with?(listener)
    @rectangle.x < listener.rectangle.x + listener.rectangle.width &&
      @rectangle.x + @rectangle.width > listener.rectangle.x &&
      @rectangle.y < listener.rectangle.y + listener.rectangle.height &&
      @rectangle.y + @rectangle.height > listener.rectangle.y
  end
end
