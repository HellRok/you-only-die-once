class Interaction
  class Travel
    include Node

    def initialize
      @text = 'Travel the world?'
      @skip_decrement = false
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
      if $data[:travel] == 0
        text = [
          'You visit far off lands and meet',
          'many interesting people, you see',
          'amazing sights, and gain a wealth',
          'of experience!',
          'You now have no money though.',
        ]
      else
        @skip_decrement = true
        text = [
          'You cannot afford to travel again...',
        ]
      end
      @text_box = TextBox.new(text) { go_travel }
      scene.hud << @text_box
    end

    def go_travel
      scene.hud.delete(@text_box)
      $data[:travel] += 1
      3.times { scene.health.decrement } unless @skip_decrement
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
