module Node
  attr_writer :children
  attr_accessor :paused, :parent

  def children
    @children ||= []
  end

  def all_children
    children.flat_map(&:all_children)
  end

  def add_child(object)
    object.parent = self
    children << object
    object.add_child_callback
  end

  def add_child_callback
  end

  def scene
    @parent.scene
  end

  def remove_child(object)
    object.teardown
    children.delete(object)
  end

  def remove_self
    teardown
    parent.remove_child(self)
  end

  def paused?
    @paused = false if @paused.nil?
    @paused
  end

  def pause
    @paused = true
    children.each(&:pause)
  end

  def unpause
    @paused = false
    children.each(&:unpause)
  end

  def draw
    render
    children.each(&:draw)
  end

  def render
    # Override this method
  end

  def tick(delta)
    unless paused?
      update(delta)
      children.each { |child| child.tick(delta) }
    end
  end

  def update(delta)
    # Override this method
  end

  def teardown
    # Override this method
  end

  def add_listener(event, once: false, &block)
    scene.manager.events.add_listener(
      event: event,
      id: self.object_id,
      once: once,
    ) { block.call }
  end

  def remove_listener(event)
    scene.manager.events.remove_listener(
      event: event,
      id: self.object_id,
    )
  end

  def trigger(event)
    scene.manager.events.trigger(event)
  end
end
