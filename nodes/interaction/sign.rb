class Interaction
  class Sign
    include Node

    def initialize
    end

    def add_child_callback
      display_text_box
    end

    def display_text_box
      @text_box = TextBox.new([
        'Hey!',
        'You shouldn\'t be here!',
        'You must have cheated!',
      ]) { read_sign }
      scene.hud << @text_box
    end

    def read_sign
      scene.hud.delete(@text_box)
      $data[:cheated] = true
      scene.health.decrement
      clean_up
    end

    def clean_up
      scene.add_child Delay.new(length: 0.25) {
        @parent.player.start_idling
        $input.clear_all_down
      }
    end
  end
end
