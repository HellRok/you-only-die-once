DEBUG = true

# Add the path ./vendor so we can easily require third party libraries.
$: << './vendor'

require 'rok-engine/core'
require 'rok-engine/extras'

require 'lib/helpers'
require 'lib/input'
require 'lib/play_checker'
require 'lib/sound_manager'
require 'lib/tilemap'

require 'nodes/confirm'
require 'nodes/health'
require 'nodes/interaction/bar'
require 'nodes/interaction/cactus'
require 'nodes/interaction/cave'
require 'nodes/interaction/church'
require 'nodes/interaction/friend'
require 'nodes/interaction/grave'
require 'nodes/interaction/home'
require 'nodes/interaction/other_grave'
require 'nodes/interaction/pot'
require 'nodes/interaction/sign'
require 'nodes/interaction/therapist'
require 'nodes/interaction/travel'
require 'nodes/interaction/treasure'
require 'nodes/player'
require 'nodes/text_box'

require 'scenes/already_played'
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

$font_size = 32
$font = Font.load('./assets/kenney_pixel.ttf', size: $font_size)

$input = Input.new

$tiles = image.to_texture

$sounds = SoundManager.new

$map_data = File.read('./assets/map.csv').each_line.map { |line| line.split(',').map(&:to_i) }
$map = $tilemap.generate_from($map_data).to_texture

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
#     - Bonk
#     - Change selection
#     - Select
#     - Cactus
#     - Talking
#   - Background music
#
# Input System
#
# Health system
#
# Ending
#
# Intro
#
# Single play system

$data = Hash.new(0)
$data[:health] = 10
$data[:drunk_potion] = false
$data[:cheated] = false
$data[:four_chan] = false
$data[:got_laid] = false
$data[:scared_of_cave] = false
$data[:visited_church_archive] = false

if PlayChecker.played?
  $scene_manager = SceneManager.new(AlreadyPlayed.new)
else
  $scene_manager = SceneManager.new(TaylorSplash.new)
  $scene_manager = SceneManager.new(Main.new)
end

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
