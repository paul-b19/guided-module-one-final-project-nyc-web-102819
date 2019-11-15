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
        @@prompt.select("Choose one of the options below:") do |menu|
            menu.choice '🔍 Poem Search', -> {Poem.search_for_poem}
            menu.choice '❤️  My Collection', -> {
                CommandLineInterface.logo("./design/logo_small.png", false);
                Lesson.lesson_selection}
            menu.choice '🗑  Delete Account', -> {
                CommandLineInterface.logo("./design/logo_small.png", false);
                User.delete_account_flow}
            menu.choice '✌️  Log Out', -> {User.logout}
        end
    end
end
