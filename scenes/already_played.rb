class AlreadyPlayed
  include Scene

  def setup
    confirm = Confirm.new("You've already played!\n See your funeral again?") { |result|
      if result
        add_child(FadeOut.new(0.5) {
          $scene_manager.switch_to(Funeral.new)
        })
      else
        exit
      end
    }
    add_child confirm
  end
end
