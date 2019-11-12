require_relative '../config/environment'

def start
    new_cli = CommandLineInterface.new
    new_cli.run
end

start

