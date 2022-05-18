class Main
  include Scene

  def setup
    @health = Health.new

    @player = Player.new
    add_child @player

    @map_position = Rectangle.new(-16, -16, $map.width, $map.height)

    @camera = Camera2D.new(
      Vector2.new(320, 240),
      Vector2.new(320, 240),
      0,
      1
    )
  end

  def draw
    clear
    @camera.drawing {
      $map.draw(destination: @map_position)
      super
    }
    @health.draw
    draw_fps(20, 20)
  end

  def update(delta)
    $input.update(delta)
    @health.update(delta)

    if @player.idle?
      if $input.left_pressed?
        @player.move(:left)
        add_child Delay.new(length: 0.3) { $input.clear_pressed(:left) }
      elsif $input.right_pressed?
        @player.move(:right)
        add_child Delay.new(length: 0.3) { $input.clear_pressed(:right) }
      elsif $input.up_pressed?
        @player.move(:up)
        add_child Delay.new(length: 0.3) { $input.clear_pressed(:up) }
      elsif $input.down_pressed?
        @player.move(:down)
        add_child Delay.new(length: 0.3) { $input.clear_pressed(:down) }
      end
    end

    update_camera(delta)
  end

  def update_camera(delta)
    if @player.destination.x >= 320 - 32 &&
        @player.destination.x <= ($map.width - 320 - 32)
      @camera.target.x = @player.destination.x + 16
    end

    if @player.destination.y >= 240 - 32 &&
        @player.destination.y <= ($map.height - 240 - 32)
      @camera.target.y = @player.destination.y + 16
    end
  end
end
