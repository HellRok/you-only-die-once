class Interaction
  class Treasure
    include Node

    def initialize
      @text = 'Treasure'
    end

    def add_child_callback
      confirm = Confirm.new(@text) { |result|
        if result
          display_text_box
        else
          clean_up
        end
        scene.hud.delete(confirm)
      }
      scene.hud << confirm
    end

    def display_text_box
      @text_box = TextBox.new(
        [
          'Hello there',
          'this is some text',
          'like this',
          'like this',
          'like this',
        ]
      ) { have_therapy }
      scene.hud << @text_box
    end

    def have_therapy
      scene.hud.delete(@text_box)
      $data[:therapy] += 1
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
