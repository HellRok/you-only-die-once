class Confirm
  include Node

  def initialize(text, &block)
    @block = block if block_given?
    @text = text

    @rectangle = Rectangle.new(40, 120, 560, 240)

    @foreground = Colour.new(255, 255, 255, 240)
    @border_outer = Colour.new(69, 69, 69, 240)
    @border_inner = Colour.new(0, 0, 0, 240)

    @text_position = Vector2.new(
      @rectangle.x + ((@rectangle.width - text_width(@text)) / 2),
      @rectangle.y + ((@rectangle.height - $font_size) / 2) - 32
    )

    # TODO: Make this actually evenly spaced, I'm pretty sure they aren't right now
    @yes_position = Vector2.new(
      @rectangle.x + 240 - 48,
      @rectangle.y + ((@rectangle.height - $font_size) / 2) + 64
    )
    @no_position = Vector2.new(
      @rectangle.x + 320,
      @rectangle.y + ((@rectangle.height - $font_size) / 2) + 64
    )

    @made_selection = false
    @selected = :no
    @last_selected = :no
    @selected_position = Vector2.new(
      @rectangle.x + 320 - 24,
      @rectangle.y + ((@rectangle.height - $font_size) / 2) + 64
    )
  end

  def update(delta)
    return if @made_selection

    if $input.up_pressed?
      $sounds.play(:select)
      @made_selection = true
      add_child Delay.new(length: 0.2) { @block.call(@selected == :yes) }
    elsif $input.left_pressed?
      @selected = :yes
      @selected_position.x = 216
    elsif $input.right_pressed?
      @selected = :no
      @selected_position.x = 336
    end

    if @last_selected != @selected
      $sounds.play(:select)
      @last_selected = @selected
    end
  end

  def render
    @rectangle.draw(colour: @foreground)
    @rectangle.draw(outline: true, colour: @border_outer, thickness: 4)
    @rectangle.draw(outline: true, colour: @border_inner, thickness: 2)
    $font.draw(@text, position: @text_position)

    $font.draw('YES', position: @yes_position)
    $font.draw('NO', position: @no_position)
    $font.draw('<           >', position: @selected_position)
  end
end
