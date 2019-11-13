require 'pry'
require 'rest-client'

user1 = User.create(first_name: "Trewaine", last_name: "Bopplestizone", username: "t", password: "p")
# # user2 = User.create("Thompson", "David", "serious1", "password")
# # user3 = User.create("Sarah", "Owens", "sarah_wins", "carpetvaccuum")
# # user4 = User.create("Morby", "Pacifier", "pacifiers_rule", "nomorethumbs")
# # user5 = User.create("Alexa", "Bezos", "plebkiller5000", "lololololololiclolo")

# author1 = Author.create(name: "Edgar Allan Poe")
# author2 = Author.create(name: "William Shakespeare")
# author3 = Author.create(name: "Dr. Seuss")
# # author5 = Author.create("Trewaine the Damager")

# poem1 = Poem.create(title: "The Raven", length: 5, content: "The raven /n Never more /n Ever more /n Some more /n Haha", author_id: 1)
# poem2 = Poem.create(title: "XXX", length: 5, content: "Part 2 Scoopty", author_id: 2)
# poem3 = Poem.create(title: "Newest Poem TM", length: 5, content: "Where am I? Why am I here?!", author_id: 3)
# #   create_table "poems", force: :cascade do |t|
# #     t.string "title"
# #     t.integer "length"
# #     t.string "content"
# #     t.integer "author_id"
# #     t.datetime "created_at", precision: 6, null: false
# #     t.datetime "updated_at", precision: 6, null: false
# #   end

# lesson1 = Lesson.create(user_id: 1, poem_id: 1, favorite: true)

#   create_table "lessons", force: :cascade do |t|
#     t.integer "user_id"
#     t.integer "poem_id"
#     t.boolean "favorite"
#     t.datetime "created_at", precision: 6, null: false
#     t.datetime "updated_at", precision: 6, null: false
#   end

url = "http://poetrydb.org/title/*"
response = RestClient.get(url)
parsed_json = JSON.parse(response)
parsed_json.each do |poem_hash|
    author = poem_hash["author"]
    title = poem_hash["title"]
    content = poem_hash["lines"]
    authorvar = Author.find_or_create_by(name: author)
    Poem.create(title: title, content: content, author_id: authorvar.id)
end