class Poem < ActiveRecord::Base

    @@prompt = TTY::Prompt.new
    
    belongs_to :author
    has_many :lessons
    has_many :users, through: :lessons


    def self.search_for_poem
        CommandLineInterface.logo("./design/logo_small.png", false)
        @@prompt.select("Search by:") do |menu|
            menu.choice "* Title", -> {search_by_title}
            menu.choice "* Author", -> {Author.search_by_author}
            menu.choice "* Back to Main Menu", -> {
                CommandLineInterface.logo("./design/logo_small.png", false);
                CommandLineInterface.general_menu}
        end
    end

    def self.search_by_title
        CommandLineInterface.logo("./design/logo_small.png", false)
        @@title_search = @@prompt.ask("Please enter the title you are looking for:"){ 
            |input| input.validate /^^(?=.{1,40}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._ ]+(?<![_.])$/, 
            "Sorry, your title entry must be at least 1 character and not contain special symbols." }
        if Poem.find_by("title like ?", "%#{@@title_search}%")
            p = Poem.where("title like ?", "%#{@@title_search}%").map {|poem| poem.title}.sort
            @@selected_title = @@prompt.select("Select Poem:", p) 
            poem_title({title: @@selected_title}) 
        else
            puts "Sorry, poem was not found. Please try another input."
            @@menu_selection_footer = @@prompt.select("Options:") do |menu|
                menu.choice '* Try Again', -> {search_by_title}
                menu.choice "* Back to Main Menu", -> {
                    CommandLineInterface.logo("./design/logo_small.png", false);
                    CommandLineInterface.general_menu}
            end
        end
    end

    def self.poem_title(arg)
        CommandLineInterface.logo("./design/logo_small.png", false)
        i = Poem.find_by(arg)
        puts " "
        puts i.title.colorize(:color => :black, :background => :white)
        puts "By #{i.author.name}".colorize(:color => :black, :background => :white)
        puts " "
        puts i.content
        puts " "
        @@menu_selection_footer = @@prompt.select("Options:") do |menu|
            menu.choice '* Play Music', -> {Poem.music_selection(arg)}
            menu.choice '* Stop Music', -> {Poem.stop_song(arg)}
            if Lesson.exists?(user_id: User.user_id, poem_id: i.id)
                menu.choice '* Remove from your collection', -> {
                    Lesson.find_by(user_id: User.user_id, poem_id: i.id).destroy;
                    poem_title(arg)}
            else
                menu.choice '* Add to collection', -> {
                    Lesson.lesson_creation(user_id: User.user_id, poem_id: i.id);
                    poem_title(arg)}
            end
            menu.choice "* Back to Main Menu", -> {
                CommandLineInterface.logo("./design/logo_small.png", false);
                CommandLineInterface.general_menu}
        end 
    end

    def self.music_selection(arg)
        @@prompt.select("Please select music:") do |menu|
            Dir['./music/*'].each do |fname|
                menu.choice "* #{fname}".tap{|s| 
                s.slice!("./music/")}.tap{|s| 
                s.slice!(".mp3")}, -> {play_song("#{fname}")}
            end
        end
        poem_title(arg)
    end

    def self.play_song(file_path)
        fork{ exec 'killall', "afplay" }
        sleep(0.5)
        fork{ exec 'afplay', file_path }
    end

    def self.stop_song(arg)
        fork{ exec 'killall', "afplay" }
        poem_title(arg)
    end

end