module Scene
  include Node

  attr_accessor :manager

  def scene
    self
  end

  def setup
  end

  def teardown
    all_children.each(&:teardown)
  end
end
