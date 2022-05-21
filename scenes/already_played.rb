class AlreadyPlayed
  include Scene

  def setup
    confirm = Confirm.new("You've already played!\n See your funeral again?") { |result|
      if result
        puts "YO"
      else
        exit
      end
    }
    add_child confirm
  end
end
