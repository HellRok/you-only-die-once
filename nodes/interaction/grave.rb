class Interaction
  class Grave
    include Node

    def initialize
      @text = 'Visit your partner\'s grave?'
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
      if $data[:grave] == 0
        text = [
          'You leave some nice flowers and shed',
          'a few tears.',
          'You miss them with all your heart.',
        ]
      elsif $data[:grave] == 1
        text = [
          'You clean off the grave as it\'s',
          'gotten dirty after all this time.',
          'You don\'t cry but you still miss',
          'them dearly.',
        ]
      else
        @skip_decrement = true
        text = [
          'You do some routine cleaning and',
          'leave some more flowers.',
        ]
      end
      @text_box = TextBox.new(text) { visit_grave }
      scene.hud << @text_box
    end

    def visit_grave
      scene.hud.delete(@text_box)
      $data[:grave] += 1
      scene.health.decrement unless @skip_decrement
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
