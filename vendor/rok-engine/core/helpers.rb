def draw
  begin_drawing
  yield
  end_drawing
end

def seed_rand(seed = nil)
  seed ||= Time.now.to_i.to_s.reverse[0,5].to_i
  seed.times { rand }
end
