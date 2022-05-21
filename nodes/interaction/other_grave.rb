class Interaction
  class OtherGrave
    include Node

    def initialize
      @text = 'Visit the mysterious grave?'
      @skip_decrement = false
      @skip_increment = false
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
      if $data[:mysterious_grave] == 1 && !$data[:visited_church_archive]
        text = [
          'You need to visit the church to find',
          'out more.',
        ]
        @skip_decrement = true
        @skip_increment = true
      elsif $data[:mysterious_grave] == 0
        text = [
          'You clear away some grime from the',
          'base of the grave and can read the',
          'name "Jade".',
          'You feel you can find out more',
          'from the church archives.',
        ]
      elsif $data[:mysterious_grave] == 1
        text = [
          'Having learnt from the archives what',
          'happened you give a proper ceremony',
          'to Jade.',
          'You feel as though a spirit has left',
          'and is finally at rest.',
        ]
      else
        text = [
          'There is no longer an ominous',
          'feeling emanating from this grave.',
        ]
        @skip_decrement
      end
      @text_box = TextBox.new(text) { visit_mysterious_grave }
      scene.hud << @text_box
    end

    def visit_mysterious_grave
      scene.hud.delete(@text_box)
      $data[:mysterious_grave] += 1 unless @skip_increment
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
