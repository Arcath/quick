module Quick
	class SSH
    def initialize(args)
      @name = args[0]
      @arguments = args[1..args.length]
      @config = Quick::Config.load('ssh')
      process_command
    end
    
    private
    
    def process_command
      if @config[@name.to_sym]
        if @arguments == [] || @arguments.first == "-c"
          ssh_command = "ssh #{@config[@name.to_sym][:hostname]}"
          ssh_command = add_options(ssh_command)
          system(ssh_command)
        elsif @arguments.first == "-i"
          puts "Installing SSH Key"
          puts "When prompted give the remote users password"
          host_user = (@config[@name.to_sym][:username] || ENV['USER'])
          system("mkdir -p #{Quick::BasePath}/data/ssh")
          system("mkdir -p #{Quick::BasePath}/data/ssh/#{@name}")
          system("scp -p #{host_user}@#{@config[@name.to_sym][:hostname]}:~/.ssh/authorized_keys2 #{Quick::BasePath}/data/ssh/#{@name}/ssh_keys")
          system("cat ~/.ssh/id_rsa.pub >> #{Quick::BasePath}/data/#{@name}/ssh_keys")
          system("scp -p #{Quick::BasePath}/data/#{@name}/ssh/ssh_keys #{host_user}@#{@config[@name.to_sym][:hostname]}:~/.ssh/authorized_keys2")
          puts "Key installed! try `quick ssh #{@name}`"
        end
      elsif @name == "-l"
        @config.each do |key, value|
          puts key.to_s
          puts "\tHost: #{@config[key][:hostname]}"
          puts "\tUsername: #{@config[key][:username]}" if @config[key][:username]
          puts "\tPort: #{@config[key][:port]}" if @config[key][:port]
        end
      else
        if @arguments.first == "-a"
          add_host
        else
          puts "Host not found"
        end
      end
    end
    
    def fetch_argument(arg)
      @arguments[@arguments.index(arg) + 1]
    end
    
    def add_options(cmd)
      cmd += " -l #{@config[@name.to_sym][:username]}" if @config[@name.to_sym][:username]
      cmd += " -p #{@config[@name.to_sym][:port]}" if @config[@name.to_sym][:port]
      cmd += " #{fetch_argument("-c")}" if @arguments.index("-c")
      return cmd
    end
    
    def add_host
      @config[@name.to_sym] = {}
      @config[@name.to_sym][:username] = fetch_argument("-u") if @arguments.index("-u")
      @config[@name.to_sym][:hostname] = fetch_argument("-h") if @arguments.index("-h")
      @config[@name.to_sym][:port] = fetch_argument("-p") if @arguments.index("-p")
      Quick::Config.dump('ssh', @config)
    end
	end
end