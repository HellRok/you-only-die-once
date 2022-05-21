require 'nodes/player/state/idle'
require 'nodes/player/state/interacting'
require 'nodes/player/state/moving'

class Player
  include Node
  include StateMachine

  state_machine(
    states: {
      idle: Player::State::Idle,
      interacting: Player::State::Interacting,
      moving: Player::State::Moving,
    }
  )

  attr_accessor :destination, :player_tile
  def initialize
    @player_tile = coin_flip ? 121 : 122
    @destination = Rectangle.new(
      32 * 12, 32 * 16,
      32, 32
    )
    @tile_position = Vector2.new(0, 0)
    start_idling
    add_child Delay.new(length: 0.3) { toggle_sprite }
  end

  def tile_position
    @tile_position.x = (@destination.x / 32).to_i
    @tile_position.y = (@destination.y / 32).to_i
    @tile_position
  end

  def idle?
    @state.is_a? Player::State::Idle
  end

  def render
    $tiles.draw(
      destination: @destination,
      source: $tilemap.tile_for(@player_tile)
    )
  end

  def start_idling
    transition_to :idle, self
  end

  def start_interacting
    transition_to :interacting, self
  end

  def move(direction)
    transition_to :moving, self, direction
  end

  def update(delta)
    state.tick(delta)
  end

  private
  def toggle_sprite
    if @player_tile > 130
      @player_tile -= 17
    else
      @player_tile += 17
    end
    add_child Delay.new(length: 0.3) { toggle_sprite }
  end
end
