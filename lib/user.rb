require 'tty-prompt'
class User < ActiveRecord::Base

    has_many :lessons
    has_many :poems, through: :lessons

    @prompt = TTY::Prompt.new

    ##### Logic for creating a new account #####
    
    def self.create_account_instance
        @first_name = validate("ask", "first name")
        @last_name = validate("ask", "last name")
        username_and_password_flow
        account_creation
    end

    def self.username
        @username = validate("ask", "username")
    end

    def self.password
        @password = validate("mask", "password")
    end

    def self.username_and_password_flow
        username
        if find_existing_username
            puts "Username already exists. Try again."
            username_and_password_flow
        else
            password
        end
    end

    def self.find_existing_username
        self.find_by(username: "#{@username}")
    end

    def self.account_creation
        @created_user = User.create(first_name: "#{@first_name}", last_name: "#{@last_name}", username: "#{@username}", password: "#{@password}")
        @@active_user = @created_user
        puts "Congrats, #{@first_name}! Your account has been created."
    end

    ##### Logic for logging into your account #####

    def self.login_prompt
        @prompt.select("Would you like to?") do |menu|
            menu.choice '* Login', -> {login_verification}
            menu.choice '* Sign Up', -> {create_account_instance}
            menu.choice '* Exit', -> {puts "\e[H\e[2J"; exit}
        end
    end
    
    def self.login_verification
        username
        puts "If you would like to return to the opening menu, simply enter an incorrect password"
        if find_existing_username
            password
        else
            puts "Username does not exist. Try again."
            login_verification
        end
        login_logic
    end

    def self.login_logic
        @@active_user = find_existing_username
        user_pass_verify_again if !(@@active_user && @@active_user.password == @password)
    end

    def self.user_pass_verify_again
        puts "Your username and/or password is incorrect. Returning to the opening menu."
        sleep(1.5)
        login_prompt
    end

    ##### Logic for deleting your account #####

    def self.delete_account_flow
        @decision = @prompt.select("Are you sure?", ["Yes", "No"])
        @decision == "Yes" ? destroy_account : CommandLineInterface.general_menu
    end

    def self.destroy_account
        @@active_user.destroy
        @prompt.keypress("Oh, no! We're sad to see you leave, but we'll see you again in 3 seconds...", timeout: 3)
        fork{ exec 'killall', "afplay" }
        start_program
    end

    ##### General abstraction method for data validation #####

    def self.validate(method, type)
        if method == "ask" 
            @prompt.ask("Enter your #{type}:") { |input| input.validate /^^(?=.{1,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$/, "Sorry, your entry must be at least 2 characters and not contain symbols." }
        else
            @prompt.mask("Enter your #{type}:") { |input| input.validate /^^(?=.{1,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$/, "Sorry, your entry must be at least 2 characters and not contain symbols." }
        end
    end

    ##### General helper method used in other Classes #####

    #Used in the Collections feature in the Lesson Class#
    def self.user_id
        @@active_user.id
    end

    #Used in the General Menu feature in the CLI Class#
    def self.logout
        @prompt.keypress("😈 Logging out now... See you soon! 😈", timeout: 3)
        fork{ exec 'killall', "afplay" }
        start_program
    end
end