require 'pry'

user1 = User.create(first_name: "Trewaine", last_name: "Bopplestizone", username: "noobslayer69", password: "slurpthat")
# user2 = User.create("Thompson", "David", "serious1", "password")
# user3 = User.create("Sarah", "Owens", "sarah_wins", "carpetvaccuum")
# user4 = User.create("Morby", "Pacifier", "pacifiers_rule", "nomorethumbs")
# user5 = User.create("Alexa", "Bezos", "plebkiller5000", "lololololololiclolo")

author1 = Author.create(name: "Edgar Allan Poe")
# author2 = Author.create("William Shakespeare")
# author3 = Author.create("Poet #3")
# author4 = Author.create("Dr. Seuss")
# author5 = Author.create("Trewaine the Damager")

poem1 = Poem.create(title: "The Raven", length: 5, content: "The raven /n Never more /n Ever more /n Some more /n Haha", author_id: 1)
#   create_table "poems", force: :cascade do |t|
#     t.string "title"
#     t.integer "length"
#     t.string "content"
#     t.integer "author_id"
#     t.datetime "created_at", precision: 6, null: false
#     t.datetime "updated_at", precision: 6, null: false
#   end

lesson1 = Lesson.create(user_id: 1, poem_id: 1, favorite: true)

#   create_table "lessons", force: :cascade do |t|
#     t.integer "user_id"
#     t.integer "poem_id"
#     t.boolean "favorite"
#     t.datetime "created_at", precision: 6, null: false
#     t.datetime "updated_at", precision: 6, null: false
#   end