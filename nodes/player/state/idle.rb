class Player
  class State
    class Idle
      include Node

      def initialize(parent)
        @parent = parent
      end
    end
  end
end
