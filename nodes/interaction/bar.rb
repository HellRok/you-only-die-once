class Interaction
  class Bar
    include Node

    def initialize
      @text = 'Have a few drinks at the bar?'
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
      if $data[:bar] == 0
        text = [
          'You have a few drinks at the bar and',
          'some delicious food.',
          'It\'s a nice night and you feel a little',
          'better.'
        ]
      elsif $data[:bar] == 1
        text = [
          'You\'re back for some more drinks and',
          'another delicious meal.',
          'It\'s a decent night and you feel a little',
          'better than you did yesterday.'
        ]
      elsif $data[:bar] == 2
        text = [
          'You\'re here again for a few more beers',
          'and another delicious meal.',
          'You start to feel like this is becoming',
          'a habit.'
        ]
      elsif $data[:bar] == 3
        text = [
          'People are starting to recognise you',
          'here.',
          'The drinks flow freely and the food',
          'is tasty.',
          'This is definitely a habit now.',
        ]
      elsif $data[:bar] == 4
        text = [
          'Youv\'ve become a regular, everyone',
          'knows your name.',
          'You\'re finding you wake up a little',
          'groggy in the mornings though.'
        ]
      else
        @skip_decrement = true
        text = [
          'The bar keep greets you with',
          '"On the drinks again?"'
        ]
      end
      @text_box = TextBox.new(text) { have_drinks }
      scene.hud << @text_box
    end

    def have_drinks
      scene.hud.delete(@text_box)
      $data[:bar] += 1
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
