class Interaction
  class Home
    include Node

    def initialize
      @text = 'Spend time at home?'
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
      if $data[:home] == 0
        text = [
          'You enjoy a nice quite night',
          'at home.',
          'You watch a fun movie and eat some',
          'popcorn with it.',
        ]
      elsif $data[:home] == 1
        text = [
          'You play some fun indeo games and',
          'go to chat about them online.',
          'You stumble across a site called',
          '"The 4chan".',
        ]
      elsif $data[:home] == 2
        if $data[:therapy] < 2
          $data[:four_chan] =  true
          text = [
            'You scroll endlessly through 4chan',
            'and post more and more.',
            'You feel your mental health slipping',
            'away from you.',
          ]
        else
          text = [
            'Thanks to therapy you are able to',
            'ignore the instant gratification',
            'of 4chan and just play some more',
            'fun indie games.',
          ]
        end
      else
        @skip_decrement = true
        if $data[:four_chan]
          text = [
            'You spend all night posting memes',
            'and visiting the dark corners of 4chan',
            'slowly becoming more corrupted.',
          ]
        else
          text = [
            'You play some more fun indei games',
            'and have a wonderful time.',
          ]
        end
      end
      @text_box = TextBox.new(text) { go_home }
      scene.hud << @text_box
    end

    def go_home
      scene.hud.delete(@text_box)
      $data[:home] += 1
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
