class CommandLineInterface
    def greeting
        puts "Welcome to Dead Poets! The place to learn, laugh, and love ❤️"
    end

    def login_prompt
        puts "Type Yes if you already have an account. If not, type No to sign up."
        response = gets.chomp.downcase
        if response == "yes"
            puts "Enter username:"
            username = gets.chomp
            validation(username, 1)
            puts "Enter password:"
            password = gets.chomp
            validation(password, 5)
        else
            puts "Enter your first name:"
            first_name = gets.chomp
            validation(first_name, 5)
            puts "Enter your last name:"
            last_name = gets.chomp
            validation(last_name, 5)
            puts "Enter username:"
            username = gets.chomp
            validation(username, 1)
            puts "Enter password:"
            password = gets.chomp
            validation(password, 5)

            User.create(first_name: "#{first_name}", last_name: "#{last_name}", username: "#{username}", password: "#{password}")
        end
        binding.pry
    end

    def validation(input, min_length)
        input.length >= min_length 
        if input.length < min_length
            puts "Sorry, your entry was too short. Try again."
            input = gets.chomp
            validation(input, min_length)
        end  
    end


end