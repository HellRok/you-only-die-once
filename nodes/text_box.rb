class TextBox
  include Node

  def initialize(text_lines, &block)
    @block = block if block_given?
    @text = ''
    @all_done = false

    count = 0
    text_lines.each { |line|
      add_child Delay.new(length: 0.5 * count) { @text += "#{line}\n" }
      count += 1
    }

    add_child Delay.new(length: 0.5 * count) { @all_done = true }

    @rectangle = Rectangle.new(40, 112, 560, 256)

    @foreground = Colour.new(255, 255, 255, 240)
    @border_outer = Colour.new(69, 69, 69, 240)
    @border_inner = Colour.new(0, 0, 0, 240)

    @text_position = Vector2.new(
      @rectangle.x + 16,
      @rectangle.y + 16
    )
  end

  def update(delta)
    @block.call if $input.up_pressed? && @all_done
  end

  def render
    @rectangle.draw(colour: @foreground)
    @rectangle.draw(outline: true, colour: @border_outer, thickness: 4)
    @rectangle.draw(outline: true, colour: @border_inner, thickness: 2)
    $font.draw(@text, position: @text_position)
  end
end
