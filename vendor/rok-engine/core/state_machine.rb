module StateMachine
  def self.included(klass)
    klass.class_eval do
      def self.state_machine(states: {}, methods: [])
        self.class_variable_set(:@@state_map, states)
        self.class_variable_set(:@@state_methods, methods)

        self.class_variable_get(:@@state_map).each { |state_key, state_klass|
          define_method "#{state_key}?" do
            state.class == state_klass
          end
        }
      end
    end
  end

  attr_accessor :state

  def state_map
    self.class.class_variable_get(:@@state_map)
  end

  def state_methods
    self.class.class_variable_get(:@@state_methods)
  end

  def transition_to(next_state, *args)
    unless state_map.keys.include?(next_state)
      raise ArgumentError.new("Unknown state #{next_state}, valid states are: #{state_map.keys}")
    end
    @state = state_map[next_state].new(*args)
  end

  def method_missing(method, *args, &block)
    if state_methods.include?(method)
      state.send(method, *args, &block)
    else
      raise NoMethodError.new("Undefined method #{method} for #{self} and not white listed to pass to the state")
    end
  end
end
