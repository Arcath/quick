module Quick
	module Config
		def self.load(hive)
      begin
        yaml = YAML::load(File.open("#{Quick::BasePath}/data/#{hive}.yml"))
      rescue
        yaml = {}
      end
      return yaml
		end
    
    def self.dump(hive, hash)
      system("mkdir -p data")
      File.open("#{Quick::BasePath}/data/#{hive}.yml", 'w+') {|f| f.write(hash.to_yaml) }
    end
	end
end