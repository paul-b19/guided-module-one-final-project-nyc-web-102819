class Poem < ActiveRecord::Base

    @@prompt = TTY::Prompt.new
    
    belongs_to :author
    has_many :lessons
    has_many :users, through: :lessons


    def self.search_for_poem
        CommandLineInterface.logo("./design/logo_small.png", false)

        @@poem_selection = @@prompt.select("Search by:") do |menu|
            menu.choice "* Title", -> {search_by_title}
            menu.choice "* Author", -> {Author.search_by_author}
            menu.choice "* Back", -> {CommandLineInterface.general_menu}
        end
    end

    def self.search_by_title
        CommandLineInterface.logo("./design/logo_small.png", false)

        @@title_search = @@prompt.ask("Please enter the title you are looking for:"){ 
            |input| input.validate /^^(?=.{1,40}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._ ]+(?<![_.])$/, "Sorry, your title entry must be at least 1 character and not contain special symbols." }
        if Poem.find_by("title like ?", "%#{@@title_search}%")
            p = Poem.where("title like ?", "%#{@@title_search}%").map do |poem|
                poem.title
            end
            @@selected_title = @@prompt.select("Select Poem:", p) 
            poem_title({title: @@selected_title}) 
        else
            puts "Sorry, poem was not found. Please try another input."
            @@menu_selection_footer = @@prompt.select("Options:") do |menu|
                menu.choice '* Try Again', -> {search_by_title}
                menu.choice '* Back to Main Menu', -> {
                    CommandLineInterface.logo("./design/logo_small.png", false);
                    CommandLineInterface.general_menu}
            end
        end
    end

    def self.poem_title(arg)
        CommandLineInterface.logo("./design/logo_small.png", false)

        i = Poem.find_by(arg)
        puts " "
        puts i.title
        puts "By #{i.author.name}"
        puts i.content
        puts " "
        @@menu_selection_footer = @@prompt.select("Options:") do |menu|
            menu.choice '* Back to Main Menu', -> {
                CommandLineInterface.logo("./design/logo_small.png", false);  
                CommandLineInterface.general_menu}
            if Lesson.exists?(user_id: User.user_id, poem_id: i.id)
                menu.choice '* Delete from Your Collection and Back to Main Menu', -> {
                    Lesson.find_by(user_id: User.user_id, poem_id: i.id).destroy
                    CommandLineInterface.logo("./design/logo_small.png", false);
                    CommandLineInterface.general_menu}
            else
                menu.choice '* Add to Your Collection and Back to Main Menu', -> {
                    Lesson.lesson_creation(user_id: User.user_id, poem_id: i.id);
                    CommandLineInterface.logo("./design/logo_small.png", false);
                    CommandLineInterface.general_menu}
            end
        end  
    end

end