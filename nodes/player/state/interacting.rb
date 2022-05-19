class Player
  class State
    class Interacting
      include Node

      def initialize(parent)
        @parent = parent
      end
    end
  end
end
