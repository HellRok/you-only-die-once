class Interaction
  class Cactus
    include Node

    def initialize
    end

    def add_child_callback
      $sounds.play(:cactus)
      add_child Delay.new(length: 0.3) { display_text_box }
    end

    def display_text_box
      @text_box = TextBox.new([text]) { bump_into_cactus }
      scene.hud << @text_box
    end

    def bump_into_cactus
      scene.hud.delete(@text_box)
      $data[:cactus] += 1
      clean_up
    end

    def clean_up
      scene.add_child Delay.new(length: 0.25) {
        @parent.player.start_idling
        $input.clear_all_down
      }
    end

    def text
      if $data[:cactus] < 5
        [
          'Ow!',
          'That\'s sharp!',
          'Oof!',
          'Ouch!',
        ].sample
      else
        [
          'Why do I keep doing this to myself?',
          'Do I do this because I hate myself?',
          'Therapy would hurt less than this!',
        ].sample
      end
    end
  end
end
