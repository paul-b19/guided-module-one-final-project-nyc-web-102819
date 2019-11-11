class Poem < ActiveRecord::Base
    belongs_to :author
    has_many :lessons
    has_many :users, through: :lessons
end