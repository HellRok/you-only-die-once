class Funeral
  include Scene

  def setup
    $sounds.switch_background_music_to :funeral
    $sounds.background_music.volume = 0.3
    $sounds.background_music.play

    @funeral_data = File.read('./assets/funeral.csv').each_line.map { |line| line.split(',').map(&:to_i) }
    @funeral = $tilemap.generate_from(@funeral_data).to_texture

    @accomplishments = []

    add_child Npc.new(tile_id: 120, x: 4, y: 7)

    [
      [10, 4],
      [10, 5],
      [10, 6],

      [10, 8],
      [10, 9],
      [10, 10],

      [12, 4],
      [12, 5],
      [12, 6],

      [12, 8],
      [12, 9],
      [12, 10],

      [14, 4],
      [14, 5],
      [14, 6],

      [14, 8],
      [14, 9],
      [14, 10],

      [16, 4],
      [16, 5],
      [16, 6],

      [16, 8],
      [16, 9],
      [16, 10],

      [18, 4],
      [18, 5],
      [18, 6],

      [18, 8],
      [18, 9],
      [18, 10],
    ].each { |(x, y)| add_child Npc.new(x: x, y: y) }

    if PlayChecker.played?
      PlayChecker.load_data
    else
      PlayChecker.played!
    end

    generate_accomplishments

    add_child FadeIn.new(3) {
      add_child Delay.new(length: 3) {
        start_funeral
      }
    }
  end

  def update(delta)
    $sounds.tick(delta)
  end

  def render
    @funeral.draw
  end

  def start_funeral
    text = TextBox.new([
      'They lived a good life, made good',
      'friends, made some mistakes as we all',
      'do, and here is a list of their',
      'accomplishments:',
    ]) {
      remove_child text
      display_achievements
    }
    add_child text
  end

  def display_achievements
    text = TextBox.new(@accomplishments[0...5]) {
      remove_child text
      credits
    }
    add_child text
  end

  def credits
    text = TextBox.new([
      'Created by Hell_Rok',
      'You can find me on Twitter at',
      'https://twitter.com/Hell_Rok',
      'I hope you enjoyed my game!',
      'This was the only time you could play it.',
    ]) {
      remove_child text
      add_child Delay.new(length: 1) { credits }
    }
    add_child text
  end

  def generate_accomplishments
    if $data[:cheated]
      @accomplishments << 'They cheated'
      return
    end

    # Impressive
    @accomplishments << 'Had a ghost at their funeral!' if $data[:ghost_at_funeral]
    @accomplishments << 'Spent WAY too long at the bar' if $data[:bar] >= 5
    @accomplishments << 'Discovered a new type of fish' if $data[:cave] >= 4
    @accomplishments << 'Too faithful to the church' if $data[:church] >= 5
    @accomplishments << 'Turned into an incel' if $data[:home] >= 3 && $data[:four_chan]
    @accomplishments << 'Freed Jade\'s spirit' if $data[:mysterious_grave] >= 2
    @accomplishments << 'Took care of their mental health' if $data[:therapy] >= 3
    @accomplishments << 'Travelled the world' if $data[:travel] >= 1

    @accomplishments << 'Really loved cactuses' if $data[:cactus] >= 10
    @accomplishments << 'Got laid' if $data[:got_laid]

    # Minor
    @accomplishments << 'Enjoyed the bar' if $data[:bar] >= 3
    @accomplishments << 'Left the church due to scandal' if $data[:church] >= 3
    @accomplishments << 'Praised the pot' if $data[:pot] >= 10
    @accomplishments << 'Got stuck in a cave' if $data[:cave] >= 3
    @accomplishments << 'Cared for their partner\'s grave' if $data[:grave] >= 2
    @accomplishments << 'Was a homebody' if $data[:home] >= 3 && !$data[:four_chan]
  end
end
