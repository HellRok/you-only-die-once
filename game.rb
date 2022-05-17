# Add the path ./vendor so we can easily require third party libraries.
$: << './vendor'

require 'lib/tilemap'
require 'rok-engine/core'

# Open up a window
init_window(640, 480, "You Only Die Once")

# Setup audio so we can play sounds
init_audio_device

# Get the current monitor frame rate and set our target framerate to match.
set_target_fps(get_monitor_refresh_rate(get_current_monitor))

$resources = ResourceManager.new
$tilemap = Tilemap.new(
  image: Image.load('./assets/tilemap.png').resize!(width: 272 * 2, height: 128 * 2),
  size: 32
)

$map = $tilemap.generate_from('./assets/map.csv').to_texture

# Define your main method
def main
  # Get the amount of time passed since the last frame was rendered
  delta = get_frame_time

  # Your update logic goes here

  drawing do
    # Your drawing logic goes here

    clear
    $map.draw
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
