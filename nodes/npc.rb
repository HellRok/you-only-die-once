class Npc
  include Node

  def initialize(tile_id: nil, x: 0, y: 0)
    @player_tile = tile_id || random_tile
    @destination = Rectangle.new(
      32 * x, 32 * y,
      32, 32
    )

    toggle_sprite
  end

  def render
    $tiles.draw(
      destination: @destination,
      source: $tilemap.tile_for(@player_tile)
    )
  end

  private
  def toggle_sprite
    if @player_tile > 130
      @player_tile -= 17
    else
      @player_tile += 17
    end
    add_child Delay.new(length: (rand * 0.3) + 0.3) { toggle_sprite }
  end

  def random_tile
    if (rand * 256) > 255
      $data[:ghost_at_funeral] = true
      return 125
    end
    [119, 121, 122, 123, 124].sample
  end
end
