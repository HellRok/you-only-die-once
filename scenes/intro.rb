class Intro
  include Scene

  def setup
    advance_text
  end

  def render
    clear colour: BLACK
  end

  def advance_text
    add_child TextBox.new([
      'Once the text has finished you can clear',
      'the text box with:',
      'SPACE on keyboard',
      'TAP on phone',
      'A/X on controller',
    ]) { movement_text }
  end

  def movement_text
    @children = []
    add_child TextBox.new([
      'You can move your character with:',
      'WASD/arrow keys on keyboard',
      'Swipe on phone',
      'Dpad on controller',
    ]) { only_once_text }
  end

  def only_once_text
    @children = []
    add_child TextBox.new([
      'You can only play this game once!',
      'Make sure every action you take',
      'is one you can commit to.',
    ]) { story_text }
  end

  def story_text
    @children = []
    add_child TextBox.new([
      'Your life partner has died.',
      'The funeral was yesterday.',
      "\nHow are you going to spend the rest",
      'of your life?',
    ]) {
      $scene_manager.switch_to(Main.new)
    }
  end
end
