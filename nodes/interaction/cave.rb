class Interaction
  class Cave
    include Node

    def initialize
      @text = 'Go spelunking?'
    end

    def add_child_callback
      if $data[:scared_of_cave]
        display_text_box
      else
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
    end

    def display_text_box
      if $data[:scared_of_cave]
        text = [
          'You are too scared to enter the cave.',
        ]
      elsif $data[:cave] == 0
        text = [
          'You decide to go spelukning in the cave.',
          'The mentor teaches you the basics.',
          'It\'s a lot of fun.',
        ]
        $data[:cave] += 1
        scene.health.decrement
      elsif $data[:cave] == 1
        text = [
          'You go deep into the cave, have a couple',
          'of scares about getting stuck but',
          'manage through.',
          'You\'ve never been this excited before.'
        ]
        $data[:cave] += 1
        scene.health.decrement
      elsif $data[:cave] == 2
        $data[:scared_of_cave] = true
        text = [
          'You go deeper than anyone else!',
          'OH NO!',
          'You get stuck deep in the cave and have',
          'to SOS for help.',
          'You will never spelunk again.',
        ]
        $data[:cave] += 1
        scene.health.decrement
      elsif $data[:cave] == 3
        text = [
          'With the help of therapy you are back!',
          'You take it easy and have a wonderful',
          'time in the cave.',
          'You go deep safely and find a new',
          'species of cave fish!',
        ]
        $data[:cave] += 1
        scene.health.decrement
      else
        text = [
          'You go spelunking and have a great time.',
        ]
        $data[:cave] += 1
      end
      @text_box = TextBox.new(text) { go_spelunking }
      scene.hud << @text_box
    end

    def go_spelunking
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
