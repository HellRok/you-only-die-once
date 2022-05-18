# Add the path ./vendor so we can easily require third party libraries.
$: << './vendor'

require 'rok-engine/core'
require 'rok-engine/extras'

require 'lib/helpers'
require 'lib/input'
require 'lib/tilemap'

require 'nodes/health'
require 'nodes/player'

require 'scenes/taylor_splash'
require 'scenes/main'

seed_rand

# Open up a window
init_window(640, 480, "You Only Die Once")

# Setup audio so we can play sounds
init_audio_device

# Get the current monitor frame rate and set our target framerate to match.
set_target_fps(get_monitor_refresh_rate(get_current_monitor))

image = Image.load('./assets/tilemap.png').tap { |image|
  image.resize!(width: image.width * 2, height: image.height * 2)
}
$resources = ResourceManager.new
$tilemap = Tilemap.new(
  image: image,
  size: 32
)

$input = Input.new

$tiles = image.to_texture

$map = $tilemap.generate_from('./assets/map.csv').to_texture

## TODO
# Character
#   - Movement
#   - Interaction
#
# Map
#   - Scrolling
#
# Sound
#   - Sounds
#   - Background music
#
# Input System
#
# Health system
#
# Ending
#
# Intro

$scene_manager = SceneManager.new(TaylorSplash.new)
$scene_manager = SceneManager.new(Main.new)

$data = {
  health: 10
}

# Define your main method
def main
  # Get the amount of time passed since the last frame was rendered
  delta = get_frame_time

  # Your update logic goes here
  $scene_manager.update(delta)

  drawing do
    # Your drawing logic goes here
    $scene_manager.render
  end
end

if browser?
  set_main_loop 'main'
else
  # Detect window close button or ESC key
  main until window_should_close?
end

close_audio_device
close_window
