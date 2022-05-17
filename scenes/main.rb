class Main
  include Scene

  def setup
    @health = Health.new
    add_child(@health)
  end
end
