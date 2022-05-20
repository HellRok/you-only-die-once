# TODO: This is actually a super useful class, just got to clean up the naming
# convention and make it a bit more meta-programmed for easy integration.
class Input
  include Node

  attr_reader :down

  def initialize
    @keys = {
      left: {
        keys: [KEY_A, KEY_LEFT],
        gestures: [GESTURE_SWIPE_LEFT],
        buttons: [
          GAMEPAD_BUTTON_LEFT_FACE_LEFT,
        ]
      },

      right: {
        keys: [KEY_D, KEY_RIGHT],
        gestures: [GESTURE_SWIPE_RIGHT],
        buttons: [
          GAMEPAD_BUTTON_LEFT_FACE_RIGHT,
        ]
      },

      up: {
        keys: [KEY_W, KEY_UP],
        gestures: [GESTURE_SWIPE_UP],
        buttons: [
          GAMEPAD_BUTTON_LEFT_FACE_UP,
        ]
      },

      down: {
        keys: [KEY_S, KEY_DOWN],
        gestures: [GESTURE_SWIPE_DOWN],
        buttons: [
          GAMEPAD_BUTTON_LEFT_FACE_DOWN,
        ]
      },

      action: {
        keys: [KEY_SPACE],
        gestures: [GESTURE_TAP],
        buttons: [
          GAMEPAD_BUTTON_RIGHT_FACE_DOWN,
        ]
      },
    }

    clear_all_down
  end

  def update(_)
    check_keys
  end

  def left_down?
    was_down? :left
  end

  def right_down?
    was_down? :right
  end

  def up_down?
    was_down? :up
  end

  def down_down?
    was_down? :down
  end

  def left_pressed?
    was_pressed? :left
  end

  def right_pressed?
    was_pressed? :right
  end

  def up_pressed?
    was_pressed? :up
  end

  def down_pressed?
    was_pressed? :pressed
  end

  def action_pressed?
    was_pressed? :action
  end

  def clear_all_down
    @down = Hash.new(false)
  end

  def clear_down(direction)
    @down[direction] = false
  end

  private
  def was_down?(input)
    if @down[input]
      @down[input] = false
      return true
    end

    return false
  end

  def was_pressed?(input)
    check_keyboard_pressed(@keys[input][:keys]) ||
      check_gestures(@keys[input][:gestures]) ||
      check_gamepad_pressed(@keys[input][:buttons])
  end

  def check_keys
    @keys.each { |input, inputs|
      @down[input] = true if check_keyboard(inputs[:keys]) ||
        check_gestures(inputs[:gestures]) ||
        check_gamepad(inputs[:buttons])
    }
  end

  def check_keyboard(keys)
    keys.any? { key_down? _1 }
  end

  def check_gestures(gestures)
    gestures.include? get_gesture_detected
  end

  def check_gamepad(buttons)
    buttons.any? { gamepad_button_down? 0, _1 }
  end

  def check_keyboard_pressed(keys)
    keys.any? { key_pressed? _1 }
  end

  def check_gamepad_pressed(buttons)
    buttons.any? { gamepad_button_pressed? 0, _1 }
  end
end
