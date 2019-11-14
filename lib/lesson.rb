class Lesson < ActiveRecord::Base

    @@prompt = TTY::Prompt.new

    belongs_to :user
    belongs_to :poem
    
    def self.lesson_creation(arg)
        @variable = Lesson.find_or_create_by(arg)
    end

    def self.lesson_selection
        l = Lesson.where(user_id: User.user_id).map do |lesson|
            Poem.find_by(id: lesson.poem_id).title
        end
        if l.count == 0
            @@prompt.keypress ("There is nothing in Your Collection yet, press any key to go back to Main Menu")
            CommandLineInterface.logo("./design/logo_small.png", false)
            CommandLineInterface.general_menu 
        else  
            @@selected_lesson = @@prompt.select("Select Poem:", l)
            Poem.poem_title({title: @@selected_lesson})
        end
    end
end