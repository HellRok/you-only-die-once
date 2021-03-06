WALKABLE_TILES = [
  0,
  17, 19,
  34,
  51,
  68, 69, 70, 71, 72, 73, 74,
  85, 86, 87, 88, 89,
  102, 103, 104,
]

INTERACTION_TILES = {
  '20x-1' => Interaction::Travel,
  '21x-1' => Interaction::Travel,
  '22x-1' => Interaction::Travel,
  '23x-1' => Interaction::Travel,

  '5x1' => Interaction::Sign,

  '3x16' => Interaction::Grave,
  '11x10' => Interaction::Therapist,
  '15x12' => Interaction::Bar,
  '12x15' => Interaction::Home,
  '10x20' => Interaction::Friend,
  '15x20' => Interaction::Church,

  '27x1' => Interaction::Cave,
  '35x1' => Interaction::Pot,
  '47x1' => Interaction::OtherGrave,
  '44x26' => Interaction::Treasure,

  '24x15' => Interaction::Cactus,
  '30x16' => Interaction::Cactus,
  '26x19' => Interaction::Cactus,
  '32x19' => Interaction::Cactus,
  '40x19' => Interaction::Cactus,
  '31x23' => Interaction::Cactus,
  '41x23' => Interaction::Cactus,
  '24x25' => Interaction::Cactus,
  '13x26' => Interaction::Cactus,
  '42x26' => Interaction::Cactus,
  '32x28' => Interaction::Cactus,
}

class Main
  include Scene

  attr_accessor :player, :hud, :health
  def setup
    @health = Health.new

    @player = Player.new
    add_child @player

    @map_position = Rectangle.new(0, 0, $map.width, $map.height)

    @camera = Camera2D.new(
      Vector2.new(320, 240),
      Vector2.new(320, 240),
      0,
      1
    )

    @hud = []
    @bonking = false

    update_camera(0)

    $sounds.background_music.play
    $sounds.background_music.volume = 0.3
  end

  def draw
    clear
    @camera.drawing {
      $map.draw(destination: @map_position)
      super
    }
    @health.draw
    @hud.each(&:draw)
    if DEBUG
      draw_fps(20, 20)
      $font.draw(
        JSON.generate($data, { pretty_print: true, indent_width: 2 }),
        colour: RED,
        size: 16
      )
    end
  end

  def update(delta)
    start_funeral if $data[:health] <= 0

    $sounds.tick(delta)
    $input.update(delta)
    @health.tick(delta)
    @hud.each { _1.tick(delta) }

    if @player.idle?
      if $input.left_down?
        if INTERACTION_TILES[tile_position(:left)]
          @player.start_interacting
          add_child INTERACTION_TILES[tile_position(:left)].new
        elsif WALKABLE_TILES.include? tile(:left)
          @player.move(:left)
          add_child Delay.new(length: 0.3) { $input.clear_down(:left) }
        else
          bonk
        end

      elsif $input.right_down?
        if INTERACTION_TILES[tile_position(:right)]
          @player.start_interacting
          add_child INTERACTION_TILES[tile_position(:right)].new
        elsif WALKABLE_TILES.include? tile(:right)
          @player.move(:right)
          add_child Delay.new(length: 0.3) { $input.clear_down(:right) }
        else
          bonk
        end

      elsif $input.up_down?
        if INTERACTION_TILES[tile_position(:up)]
          @player.start_interacting
          add_child INTERACTION_TILES[tile_position(:up)].new
        elsif WALKABLE_TILES.include? tile(:up)
          @player.move(:up)
          add_child Delay.new(length: 0.3) { $input.clear_down(:up) }
        else
          bonk
        end

      elsif $input.down_down?
        if INTERACTION_TILES[tile_position(:down)]
          @player.start_interacting
          add_child INTERACTION_TILES[tile_position(:down)].new
        elsif WALKABLE_TILES.include? tile(:down)
          @player.move(:down)
          add_child Delay.new(length: 0.3) { $input.clear_down(:down) }
        else
          bonk
        end
      end
    end

    update_camera(delta)
  end

  private
  def update_camera(delta)
    if @player.destination.x >= 320 - 16 &&
        @player.destination.x <= ($map.width - 320 - 16)
      @camera.target.x = @player.destination.x + 16
    end

    if @player.destination.y >= 240 - 16 &&
        @player.destination.y <= ($map.height - 240 - 32)
      @camera.target.y = @player.destination.y + 16
    end
  end

  def tile(direction)
    x = @player.tile_position.x
    y = @player.tile_position.y

    case direction
    when :left
      x -= 1
    when :right
      x += 1
    when :up
      y -= 1
    when :down
      y += 1
    end

    $map_data[y][x]
  end

  def tile_position(direction)
    x = @player.tile_position.x.to_i
    y = @player.tile_position.y.to_i

    case direction
    when :left
      x -= 1
    when :right
      x += 1
    when :up
      y -= 1
    when :down
      y += 1
    end

    "#{x}x#{y}"
  end

  def bonk
    unless @bonking
      $sounds.play(:bonk)
      add_child Delay.new(length: 0.5) { @bonking = false }
      @bonking = true
    end
  end

  def start_funeral
    @player.start_interacting
    fade = FadeOut.new(2) {
      $sounds.background_music.stop
      $scene_manager.switch_to(Funeral.new)
    }

    fade.rectangle.x = @camera.target.x - 320
    fade.rectangle.y = @camera.target.y - 240

    add_child fade
  end
end
