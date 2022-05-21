class Interaction
  class Pot
    include Node

    def initialize
      @text = 'Praise the pot?'
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
      $data[:pot] += 1
      if $data[:pot] == 10
        text = [
          'You feel invigorated!'
        ]
        scene.health.decrement
        $data[:health] += 3
      else
        text = [
          'You get down on your knees and',
          'praise the pot.',
          "\nYou have praised the pot #{$data[:pot]} time#{$data[:pot] == 1 ? '' : 's'}.",
        ]
      end
      @text_box = TextBox.new(text) { praise_pot }
      scene.hud << @text_box
    end

    def praise_pot
      scene.hud.delete(@text_box)
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
