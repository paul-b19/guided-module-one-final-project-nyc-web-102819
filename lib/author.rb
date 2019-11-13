require "tty-prompt"

class Author < ActiveRecord::Base
    has_many :poems

    @@prompt = TTY::Prompt.new

    def self.search_by_author
        CommandLineInterface.logo("./design/logo_small.png", false)

        @@author_search = @@prompt.ask("Please enter the author you are looking for:"){ 
            |input| input.validate /^^(?=.{1,40}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._ ]+(?<![_.])$/, "Sorry, your author entry must be at least 1 character and not contain special symbols." }
        p = Author.where("name like ?", "%#{@@author_search}%").map do |author|
            author.name
        end
        CommandLineInterface.logo("./design/logo_small.png", false)

        @@selected_author_name = @@prompt.select("Select Author:", p)
        @@selected_author = Author.find_by(name: "#{@@selected_author_name}")
        @@author_poems = Poem.where(author: @@selected_author).map do |poem|
            poem.title
        end
        CommandLineInterface.logo("./design/logo_small.png", false)

        @@selected_title = @@prompt.select("Select Poem", @@author_poems)
        Poem.poem_title({title: @@selected_title})
    end

end




