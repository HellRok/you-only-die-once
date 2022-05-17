class Health
  include Node

  EMPTY_HEART = 127
  HALF_HEART = 128
  FULL_HEART = 129

  def initialize
    @cursor = Rectangle.new(0, 0, 32, 32)
  end

  def render
    5.times { |index|
      $tiles.draw(
        destination: position_at(index),
        source: $tilemap.tile_for(health_at(index))
      )
    }
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
      @cursor.x = 0
    else
      @cursor.x += 32
    end

    @cursor
  end
end
