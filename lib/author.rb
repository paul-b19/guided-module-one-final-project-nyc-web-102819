require "tty-prompt"

class Author < ActiveRecord::Base
    has_many :poems

    @@prompt = TTY::Prompt.new

    def self.search_by_author
        CommandLineInterface.logo("./design/logo_small.png", false)
        @@author_search = User.validate("ask", "author")
        if Author.find_by("name like ?", "%#{@@author_search}%")
            display_author_names_and_select
        else
            author_name_not_found
        end
    end

    def self.display_author_names_and_select
        p = Author.where("name like ?", "%#{@@author_search}%").map {|author| author.name}.sort

        @@selected_author_name = @@prompt.select("Select Author:", p)
        @@selected_author = Author.find_by(name: "#{@@selected_author_name}")
        @@author_poems = Poem.where(author: @@selected_author).map {|poem| poem.title}.sort

        @@selected_title = @@prompt.select("Select Poem", @@author_poems)
        Poem.poem_title({title: @@selected_title})
    end

    def self.author_name_not_found
        puts "Sorry, author was not found. Please try another input."
        @@menu_selection_footer = @@prompt.select("Options:") do |menu|
            menu.choice '⏪ Try Again', -> {search_by_author}
            menu.choice "🔍 Poem Search", -> {
            CommandLineInterface.logo("./design/logo_small.png", false);
            Poem.search_for_poem}
        end
    end

end




