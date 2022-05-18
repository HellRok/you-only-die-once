class Player
  class State
    class Moving
      include Node

      def initialize(parent, direction)
        @parent = parent
        @direction = direction
        @original_position = Vector2.new(
          parent.destination.x,
          parent.destination.y
        )
      end

      def update(delta)
        case @direction
        when :left
          @parent.destination.x -= speed(delta)
          if @parent.destination.x <= @original_position.x - 32
            @parent.destination.x = @original_position.x - 32
            @parent.start_idling
          end

        when :right
          @parent.destination.x += speed(delta)
          if @parent.destination.x >= @original_position.x + 32
            @parent.destination.x = @original_position.x + 32
            @parent.start_idling
          end

        when :up
          @parent.destination.y -= speed(delta)
          if @parent.destination.y <= @original_position.y - 32
            @parent.destination.y = @original_position.y - 32
            @parent.start_idling
          end

        when :down
          @parent.destination.y += speed(delta)
          if @parent.destination.y >= @original_position.y + 32
            @parent.destination.y = @original_position.y + 32
            @parent.start_idling
          end
        end
      end

      private
      def speed(delta)
        64 * delta
      end
    end
  end
end
