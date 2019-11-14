require "tty-prompt"
require "catpix"

class CommandLineInterface
@@prompt = TTY::Prompt.new

    def run
        CommandLineInterface.greeting
        User.login_prompt
        CommandLineInterface.experience
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

    def self.experience
        @experience = @@prompt.select("Which experience? (music is highly recommended)", ["Music", "No Music"])
        @experience == "Music" ? CommandLineInterface.music_selection : CommandLineInterface.general_menu
    end

    def self.general_menu
        @@menu_selection = @@prompt.select("Please select one of the options below:") do |menu|
            menu.choice '* Music Playlist', -> {CommandLineInterface.music_selection}
            menu.choice '* Music Off', -> {CommandLineInterface.stop_song}
            menu.choice '* Search for Poem', -> {Poem.search_for_poem}
            menu.choice '* Open your Collection', -> {
                CommandLineInterface.logo("./design/logo_small.png", false);
                Lesson.lesson_selection}
            menu.choice '* Delete your Account', -> {
                CommandLineInterface.logo("./design/logo_small.png", false);
                User.delete_account_flow}
            menu.choice '* Log out', -> {User.logout}
        end
    end

    def self.music_selection
        CommandLineInterface.logo("./design/logo_small.png", false)
        @@song_choice = @@prompt.select("Please select one of the options below:") do |menu|
            menu.choice '* Song of the Gods', -> {song("/Users/hectorpolanco/Development/mod_one_project/mod-one-dpc-final-project-nyc-web-102819/music/Halo.mp3")}
            menu.choice '* Brandenburg Concerto', -> {song("/Users/hectorpolanco/Development/mod_one_project/mod-one-dpc-final-project-nyc-web-102819/music/BrandenburgConcerto.mp3")}
            menu.choice '* Consolation 3', -> {song("/Users/hectorpolanco/Development/mod_one_project/mod-one-dpc-final-project-nyc-web-102819/music/Consolation3.mp3")}
            menu.choice '* Four Seasons Spring', -> {song("/Users/hectorpolanco/Development/mod_one_project/mod-one-dpc-final-project-nyc-web-102819/music/FourSeasonsSpring.mp3")}
            menu.choice '* Fur Elise', -> {song("/Users/hectorpolanco/Development/mod_one_project/mod-one-dpc-final-project-nyc-web-102819/music/FurElise.mp3")}
            menu.choice '* Moonlight Sonata', -> {song("/Users/hectorpolanco/Development/mod_one_project/mod-one-dpc-final-project-nyc-web-102819/music/MoonlightSonata.mp3")}
            menu.choice '* Requiem Lacrimosa', -> {song("/Users/hectorpolanco/Development/mod_one_project/mod-one-dpc-final-project-nyc-web-102819/music/RequiemLacrimosa.mp3")}
            menu.choice "* Salut D'Amour", -> {song("/Users/hectorpolanco/Development/mod_one_project/mod-one-dpc-final-project-nyc-web-102819/music/SalutD'Amour.mp3")}
            menu.choice '* Scherezade Op. 35. III', -> {song("/Users/hectorpolanco/Development/mod_one_project/mod-one-dpc-final-project-nyc-web-102819/music/ScherezadeOp35.mp3")}
            menu.choice '* Suite Bergamasque', -> {song("/Users/hectorpolanco/Development/mod_one_project/mod-one-dpc-final-project-nyc-web-102819/music/SuiteBergamasque.mp3")}
            menu.choice '* Swan Lake Finale', -> {song("/Users/hectorpolanco/Development/mod_one_project/mod-one-dpc-final-project-nyc-web-102819/music/SwanLake.mp3")}
            menu.choice '* Tragic Overture', -> {song("/Users/hectorpolanco/Development/mod_one_project/mod-one-dpc-final-project-nyc-web-102819/music/TragicOverture.mp3")}
        end
        CommandLineInterface.logo("./design/logo_small.png", false)
        CommandLineInterface.general_menu
    end

    def self.song(file_path)
        pid = fork{ exec 'killall', "afplay" }
        sleep(0.5)
        pid = fork{ exec 'afplay', file_path }
    end

    def self.stop_song
    pid = fork{ exec 'killall', "afplay" }
    CommandLineInterface.logo("./design/logo_small.png", false);
    general_menu
    end

end