class Lesson < ActiveRecord::Base

    @@prompt = TTY::Prompt.new

    belongs_to :user
    belongs_to :poem
    
    def self.lesson_creation(arg)
        Lesson.find_or_create_by(arg)
    end

    def self.lesson_selection
        l = Lesson.where(user_id: User.user_id).map do |lesson|
            Poem.find_by(id: lesson.poem_id).title
        end.sort
        if l.count == 0
            @@prompt.keypress("Sorry! There is nothing in your Poem Collection yet. Press any key to go back to the Main Menu.")
            CommandLineInterface.logo("./design/logo_small.png", false)
            CommandLineInterface.general_menu 
        else  
            @@selected_lesson = @@prompt.select("My Poem Collection:", l)
            Poem.poem_title({title: @@selected_lesson})
        end
    end
end