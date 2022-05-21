class Interaction
  class Treasure
    include Node

    def initialize
      @text = 'You find a mysterious potion, drink it?'
    end

    def add_child_callback
      if $data[:drunk_potion]
        display_text_box
        return
      end

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
      if $data[:drunk_potion]
        text = [
          'There\'s nothing left in the chest.'
        ]
      else
        text = [
          'You guzzle down the potion and feel',
          'fantastic!'
        ]
        scene.health.decrement
        $data[:health] += 3
      end
      @text_box = TextBox.new(text) { do_treasure }
      scene.hud << @text_box
    end

    def do_treasure
      scene.hud.delete(@text_box)
      $data[:drunk_potion] = true
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
