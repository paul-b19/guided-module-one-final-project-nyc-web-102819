require "tty-prompt"

class Author < ActiveRecord::Base
    has_many :poems

    @@prompt = TTY::Prompt.new

    def self.search_by_author
        @@author_search = @@prompt.ask("Please enter the author you are looking for:"){ 
            |input| input.validate /^^(?=.{1,40}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._ ]+(?<![_.])$/, "Sorry, your author entry must be at least 1 character and not contain special symbols." }
        p = Author.where("name like ?", "%#{@@author_search}%").map do |author|
            author.name
        end
        @@selected_author_name = @@prompt.select("Select Author:", p)
        @@selected_author = Author.find_by(name: "#{@@selected_author_name}")
        @@author_poems = Poem.where(author: @@selected_author).map do |poem|
            poem.title
        end
        author_poems
    end

    def self.author_poems
        @@selected_title = @@prompt.select("Select Poem", @@author_poems)
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




