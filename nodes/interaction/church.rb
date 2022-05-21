class Interaction
  class Church
    include Node

    def initialize
      @text = 'Attend church?'
      @skip_decrement = false
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
      if $data[:church] == 0
        text = [
          'You are greeted warmly by a friendly',
          'community.',
          'They make you feel like you belong.',
        ]
      elsif $data[:church] == 1
        text = [
          'Once again everyone is really nice',
          'and friendly.',
          'You are beginning to feel at home',
          'here, like a second family.'
        ]
      elsif $data[:church] == 2
        text = [
          'The mood is a lot darker today.',
          'There\'s a scandal within the church,',
          'something about a priest and a child.',
        ]
      elsif $data[:church] == 3
        text = [
          'You decide that it must be a lie!',
          'There\'s no way you could lose another',
          'family so easily.',
          'There\'s whispers the church is going',
          'to transfer the priest to protect them.'
        ]
      elsif $data[:church] == 4
        text = [
          'There\'s a new priest, but some of',
          'the old attendees have hung around.',
          'Opinion of the church is still low.',
        ]
      else
        @skip_decrement = true
        text = [
          'The sermon is fine, you feel like',
          'you are surrounded by family still.'
        ]
      end
      @text_box = TextBox.new(text) { visit_church }
      scene.hud << @text_box
    end

    def visit_church
      scene.hud.delete(@text_box)
      scene.health.decrement unless @skip_decrement
      end
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
