class Interaction
  class Therapist
    include Node

    def initialize
      @text = 'Spend some time with the therapist?'
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
      if $data[:scared_of_cave]
        text = [
          'You have a break through session.',
          'The therapist has helped you overcome',
          'your fear of caves!',
          'You feel you could spelunk again!'
        ]
        $data[:scared_of_cave] = false
      elsif $data[:therapy] == 0
        text = [
          'You have a great session.',
          'The feeling of loneliness you had is',
          'starting to fade.',
        ]
      elsif $data[:therapy] == 1
        text = [
          'Another wonderful session.',
          'You\'re really starting to understand',
          'that your partner wanted you to live',
          'your life still.',
        ]
      elsif $data[:therapy] == 2
        text = [
          'This was an amazing session.',
          'You feel a though you could take on',
          'the world!',
          'The grieving of your partner feels',
          'complete.',
        ]
      else
        text = [
          'You have another session.',
          'You discuss your minor issues and',
          'feel a little better.'
        ]
      end
      @text_box = TextBox.new(text) { have_therapy }
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
