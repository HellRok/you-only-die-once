class Player
  class State
    class Idle
      include Node

      def initialize(parent)
        @parent = parent

        @timer = 0
      end

      def update(delta)
      end
    end
  end
end
