class Input
  include Node

  attr_reader :pressed

  def initialize
    @keys = {
      left: {
        keys: [KEY_A, KEY_LEFT],
        gestures: [GESTURE_SWIPE_LEFT],
        buttons: [
          GAMEPAD_BUTTON_LEFT_FACE_LEFT,
          GAMEPAD_BUTTON_RIGHT_FACE_LEFT,
        ]
      },

      right: {
        keys: [KEY_D, KEY_RIGHT],
        gestures: [GESTURE_SWIPE_RIGHT],
        buttons: [
          GAMEPAD_BUTTON_LEFT_FACE_RIGHT,
          GAMEPAD_BUTTON_RIGHT_FACE_RIGHT,
        ]
      },

      up: {
        keys: [KEY_W, KEY_UP],
        gestures: [GESTURE_SWIPE_UP],
        buttons: [
          GAMEPAD_BUTTON_LEFT_FACE_UP,
          GAMEPAD_BUTTON_RIGHT_FACE_UP,
        ]
      },

      down: {
        keys: [KEY_S, KEY_DOWN],
        gestures: [GESTURE_SWIPE_DOWN],
        buttons: [
          GAMEPAD_BUTTON_LEFT_FACE_DOWN,
          GAMEPAD_BUTTON_RIGHT_FACE_DOWN,
        ]
      },
    }

    @pressed = Hash.new(false)
  end

  def update(_)
    check_keys
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
    was_pressed? :down
  end

  def clear_pressed(direction)
    @pressed[direction] = false
  end

  private
  def was_pressed?(input)
    if @pressed[input]
      @pressed[input] = false
      return true
    end

    return false
  end

  def check_keys
    @keys.each { |input, inputs|
      @pressed[input] = true if check_keyboard(inputs[:keys]) ||
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
    buttons.any? { gamepad_button_pressed? 0, _1 }
  end
end
