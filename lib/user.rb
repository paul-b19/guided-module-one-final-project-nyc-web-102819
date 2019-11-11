class User < ActiveRecord::Base
    has_many :lessons
    has_many :poems, through: :lessons

    def start
    end
    
end