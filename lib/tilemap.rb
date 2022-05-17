class Tilemap
  def initialize(image:, size:)
    @image = image
    @size = 32
  end

  def tile_count
    (@image.width / @size) * (@image.height / @size)
  end

  def tiles_per_row
    @image.width / @size
  end

  def tile_for(id)
    x = id % tiles_per_row
    y = (id / tiles_per_row.to_f).floor
    Rectangle.new(x * @size, y * @size, @size, @size)
  end

  def generate_from(csv)
    start_time = Time.now
    ids = File.read(csv).each_line.map { |line| line.split(',').map(&:to_i) }

    @width = ids.first.size
    @height = ids.size

    map = Image.generate(width: @width * 18, height: @height * 18, colour: BLUE)

    ids.each.with_index { |row, y|
      row.each.with_index { |id, x|
        unless id.negative?
          map.draw!(
            image: @image,
            source: tile_for(id),
            destination: Rectangle.new(x * @size, y * @size, @size, @size)
          )
        end
      }
    }

    puts "INFO: Generated map from #{csv} in #{Time.now - start_time} seconds"

    map
  end
end
