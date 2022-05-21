class SoundManager
  attr_reader :background_music, :sounds

  def initialize
    @background_tracks = {
      main: Music.load('./assets/airtone-renewal.ogg'),
      funeral: Music.load('./assets/airtone-faretheewell.ogg'),
    }

    @sounds = {
      bonk: Sound.load('./assets/bonk.wav'),
      cactus: Sound.load('./assets/cactus.wav'),
      chatter: Sound.load('./assets/chatter.wav'),
      select: Sound.load('./assets/select.wav'),
    }

    @sounds.values.each { _1.volume = 0.5 }

    @background_music = @background_tracks[:main]
  end

  def switch_background_music_to(value)
    @background_music = @background_tracks[value]
  end

  def tick(delta)
    @background_music.update
  end

  def play(sound)
    @sounds[sound].pitch = 0.75 + (rand * 0.5)
    @sounds[sound].volume = 0.5 + (rand * 0.15)
    # TODO: Pitch doesn't work without multi: false ????
    @sounds[sound].play(multi: false)
  end

  def draw
  end
end
