require "tty-prompt"
require "catpix"

class CommandLineInterface
@@prompt = TTY::Prompt.new

    def run
        CommandLineInterface.greeting
        User.login_prompt
        CommandLineInterface.general_menu
    end

    def self.logo(file_path, y_position)
        puts "\e[H\e[2J"

        Catpix::print_image file_path,
        :limit_x => 1.0,
        :limit_y => 0,
        :center_x => true,
        :center_y => y_position,
        :bg => "black",
        :bg_fill => true,
        :resolution => "high"
    end


    def self.greeting
        CommandLineInterface.logo("./design/logo.png", true)
        puts " "
        puts "❤️  Welcome to Dead Poets! The place to learn, laugh, and love ❤️"
    end

    def self.general_menu
        @@menu_selection = @@prompt.select("Please select one of the options below:") do |menu|
            menu.choice '* Search for Poem', -> {Poem.search_for_poem}
            menu.choice '* Open your Collection', -> {Lesson.lesson_selection}
            menu.choice '* Delete your Account', -> {User.delete_account_flow}
            menu.choice '* Log out', -> {User.logout}
        end
    end

end