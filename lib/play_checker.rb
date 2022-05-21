class PlayChecker
  FILE_NAMES = [
    'hate_puppies',
    'think_bunnies_are_ugly',
    'dont_like_me',
  ]

  def self.played?
    FILE_NAMES.any? { |file|
      if browser?
        local_storage_get_item("delete_if_you_#{file}") != ''
      else
        File.exist? "delete_if_you_#{file}"
      end
    }
  end

  def self.played!
    if browser?
      local_storage_set_item(
        file_name,
        $data.to_json
      )
    else
      save = File.open(file_name, 'w')
      save.write(JSON.generate($data, { pretty_print: true, indent_width: 2 }))
      save.close
    end
  end

  def self.file_name
    "delete_if_you_#{FILE_NAMES.sample}"
  end

  def self.load_data
    partial = FILE_NAMES.detect { |file|
      if browser?
        local_storage_get_item("delete_if_you_#{file}") != ''
      else
        File.exist? "delete_if_you_#{file}"
      end
    }

    if browser?
      data = JSON.parse(local_storage_get_item("delete_if_you_#{partial}"))
    else
      data = JSON.parse(File.read("delete_if_you_#{partial}"))
    end

    # If we don't do this, we lose the Hash.new(0) setup
    data.keys.each { |key|
      $data[key.to_sym] = data[key]
    }
  end
end
