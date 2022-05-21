class Health
  include Node

  EMPTY_HEART = 127
  HALF_HEART = 128
  FULL_HEART = 129

  def initialize
    @cursor = Rectangle.new(0, 0, 32, 32)
    @colour = Colour.new(255, 255, 255, 255)
    @flashing = :no
    @counter = 0.0
  end

  def update(delta)
    case @flashing
    when :down
      @counter += 128 * delta
      if @counter >= 1
        @colour.blue -= 1
        @colour.green -= 1
        @counter = 0
      end
      @flashing = :up if @colour.blue <= 128

    when :up
      @counter += 128 * delta
      if @counter >= 1
        @colour.blue += 1
        @colour.green += 1
        @counter = 0
      end
      @flashing = :no if @colour.blue >= 255
    end
  end

  def render
    ([($data[:health] / 2.0).ceil, 5].max).times { |index|
      $tiles.draw(
        destination: position_at(index),
        source: $tilemap.tile_for(health_at(index)),
        colour: @colour
      )
    }
  end

  def decrement
    $data[:health] -= 1
    @flashing = :down
  end

  private
  def health_at(index)
    min = index * 2
    if $data[:health] == (min + 1)
      HALF_HEART
    elsif $data[:health] == (min + 2)
      FULL_HEART
    elsif $data[:health] < (min + 2)
      EMPTY_HEART
    else
      FULL_HEART
    end
  end

  def position_at(index)
    if index == 0
      @cursor.x = 240
    else
      @cursor.x += 32
    end

    @cursor
  end
end
