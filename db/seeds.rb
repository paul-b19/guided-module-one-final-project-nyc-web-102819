require 'pry'
require 'rest-client'

user1 = User.create(first_name: "Trewaine", last_name: "Bopplestizone", username: "t", password: "p")

url = "http://poetrydb.org/title/*"
response = RestClient.get(url)
parsed_json = JSON.parse(response)
parsed_json.each do |poem_hash|
    author = poem_hash["author"]
    title = poem_hash["title"]
    content = poem_hash["lines"].join("\n")
    authorvar = Author.find_or_create_by(name: author)
    Poem.create(title: title, content: content, author_id: authorvar.id)
end