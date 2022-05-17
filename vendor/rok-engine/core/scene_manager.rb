class SceneManager
  attr_reader :events, :current_scene

  def initialize(scene)
    @events = Events.new
    switch_to(scene)
  end

  def switch_to(new_scene)
    @current_scene.teardown if @current_scene
    @current_scene = new_scene
    @current_scene.manager = self
    @current_scene.setup
  end

  def render
    @current_scene.draw
  end

  def update(delta)
    @current_scene.tick(delta)
  end
end
