class TextBox
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
      @rectangle.y + ((@rectangle.height - $font_size) / 2)
    )
  end

  def update(delta)
    @block.call if $input.up_pressed?
  end

  def render
    @rectangle.draw(colour: @foreground)
    @rectangle.draw(outline: true, colour: @border_outer, thickness: 4)
    @rectangle.draw(outline: true, colour: @border_inner, thickness: 2)
    $font.draw(@text, position: @text_position)
  end
end
