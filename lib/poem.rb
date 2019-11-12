

class Poem < ActiveRecord::Base

    @@prompt = TTY::Prompt.new
    
    belongs_to :author
    has_many :lessons
    has_many :users, through: :lessons


    def self.search_for_poem
        @@poem_selection = @@prompt.select("Search by:") do |menu|
            menu.choice "* Title", -> {search_by_title}
            menu.choice "* Author", -> {Author.search_by_author}
            menu.choice "* Back", -> {CommandLineInterface.general_menu}
        end
    end

    def self.search_by_title
        @@title_search = @@prompt.ask("Please enter the title you are looking for:"){ 
            |input| input.validate /^^(?=.{1,40}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._ ]+(?<![_.])$/, "Sorry, your title entry must be at least 1 character and not contain special symbols." }
        p = Poem.where("title like ?", "%#{@@title_search}%").map do |poem|
            poem.title
        end
        @@selected_title = @@prompt.select("Select Poem:", p) 
        poem_title
        # poem_title({title: @@selected_title})  
    end

    def self.poem_title
        i = Poem.find_by(title: @@selected_title)
        puts " "
        puts i.title
        puts "By #{i.author.name}"
        puts i.content
        puts " "
        a = @@prompt.keypress("Press b to go back to the Main Menu")
        if a.downcase == "b"
            CommandLineInterface.general_menu
        end  
    end

end