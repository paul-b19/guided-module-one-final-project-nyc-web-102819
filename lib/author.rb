require "tty-prompt"

class Author < ActiveRecord::Base
    has_many :poems

    @@prompt = TTY::Prompt.new

    def self.search_by_author
        CommandLineInterface.logo("./design/logo_small.png", false)
        @@author_search = @@prompt.ask("Please enter the author you are looking for:"){ 
            |input| input.validate /^^(?=.{1,40}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._ ]+(?<![_.])$/, "Sorry, your author entry must be at least 1 character and not contain special symbols." }
        if Author.find_by("name like ?", "%#{@@author_search}%")
            p = Author.where("name like ?", "%#{@@author_search}%").map do |author|
                author.name
            end.sort

            @@selected_author_name = @@prompt.select("Select Author:", p)
            @@selected_author = Author.find_by(name: "#{@@selected_author_name}")
            @@author_poems = Poem.where(author: @@selected_author).map do |poem|
                poem.title
            end.sort

            @@selected_title = @@prompt.select("Select Poem", @@author_poems)
            Poem.poem_title({title: @@selected_title})
        else
            puts "Sorry, author was not found. Please try another input."
            @@menu_selection_footer = @@prompt.select("Options:") do |menu|
                menu.choice '* Try Again', -> {search_by_author}
                menu.choice '* Back to Poem Search', -> {Poem.search_for_poem}
            end
        end
    end

end




