class Interaction
  class Therapist
    include Node

    def initialize
      @text = 'Spend some time with a therapist?'
    end

    def add_child_callback
      confirm = Confirm.new(@text) { |result|
        puts "You selected #{result ? 'Yes' : 'No'}"

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
      @text_box = TextBox.new(<<-STR) { have_therapy }
                             Hello there
                               this is some text
                                 like this
                             STR
      scene.hud << @text_box
    end

    def have_therapy
      scene.hud.delete(@text_box)
      $data[:therapy] += 1
      puts $data
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