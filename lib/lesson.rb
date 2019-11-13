class Lesson < ActiveRecord::Base

    @@prompt = TTY::Prompt.new

    belongs_to :user
    belongs_to :poem

    def self.lesson_creation(arg)
        Lesson.create(arg)
    end

    def self.lesson_selection
        l = Lesson.where(user_id: User.user_id).map do |lesson|
            Poem.find_by(id: lesson.poem_id).title
        end   
        @@selected_lesson = @@prompt.select("Select Poem:", l) 
        Poem.poem_title({title: @@selected_lesson}) 
    end
end