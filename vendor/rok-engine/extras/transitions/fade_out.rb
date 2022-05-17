class FadeOut < Fade
  def opacity
    255 * (@timer / @duration)
  end
end
