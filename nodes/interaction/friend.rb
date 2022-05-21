class Interaction
  class Friend
    include Node

    def initialize
      @text = 'Visit your friend\'s house?'
      @skip_decrement = false
      @skip_increment = false
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
      if $data[:friend] == 3 && $data[:therapy] < 3
        text = [
          'You don\'t feel comfortable seeing',
          'your friend this way.',
          'Not with the death of your partner',
          'so fresh in your mind.',
        ]
        @skip_decrement =  true
        @skip_increment =  true
      elsif $data[:friend] == 0
        text = [
          'You hang out with your friend.',
          'There\'s a bit of wine, nice food,',
          'and some fun table top games.',
        ]
      elsif $data[:friend] == 1
        text = [
          'You spend another wonderful night',
          'with your friend.',
          'It starts to remind you of how you met',
          'your partner all those years back.'
        ]
      elsif $data[:friend] == 2
        text = [
          'A fierce night of table top games leads',
          'to some very strong tension.',
          'You feel a bit awkward and decide to',
          'head off early tonight.'
        ]
      elsif $data[:friend] == 3
        text = [
          'Another fierce night of table top games',
          'leads to games not being the only thing',
          'on the table top.',
        ]
        $data[:got_laid] = true
      else
        @skip_decrement = true
        text = [
          'You and your new partner spend the',
          'night together in each other\'s embrace.'
        ]
      end
      @text_box = TextBox.new(text) { visit_friend }
      scene.hud << @text_box
    end

    def visit_friend
      scene.hud.delete(@text_box)
      $data[:friend] += 1 unless @skip_increment
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
