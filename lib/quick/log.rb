module Quick
	class Log
    def initialize(args)
      @name = args[0]
      @arguments = args[1..args.length]
      @config = Quick::Config.load('logs')
      @ssh_config = Quick::Config.load('ssh')
      process_command
    end
    
    private
    
    def process_command
      if @config[@name.to_sym]
        Quick::SSH.new([@config[@name.to_sym][:ssh_name],"-c", "tail #{@config[@name.to_sym][:directory]}/production.log -n 50"])
      elsif @name == "-l"
        @config.each do |key, value|
          puts key.to_s
          puts "\tSSH: #{@config[key][:ssh_name]}"
          puts "\tDirectory: #{@config[key][:directory]}" if @config[key][:directory]
        end
      else
        if @arguments.first == "-a"
          add_app
        else
          puts "Application not found"
        end
      end
    end
    
    def fetch_argument(arg)
      @arguments[@arguments.index(arg) + 1]
    end
    
    def add_app
      @config[@name.to_sym] = {}
      @config[@name.to_sym][:ssh_name] = fetch_argument("-s") if @arguments.index("-s")
      @config[@name.to_sym][:directory] = fetch_argument("-d") if @arguments.index("-s")
      Quick::Config.dump('logs', @config)
    end
	end
end