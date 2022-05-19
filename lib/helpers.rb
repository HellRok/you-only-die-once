# Just misc functions, don't judge me for having a toolbox file!

def coin_flip
  rand <= 0.5
end

def text_width(text)
  $font.measure(text, size: $font_size).x
end
