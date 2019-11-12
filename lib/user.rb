require "tty-prompt"
class User < ActiveRecord::Base

    @@prompt = TTY::Prompt.new

    has_many :lessons
    has_many :poems, through: :lessons

    # def self.validate(instance) 
    #     instance.validate /^(?=.{2,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$/
    # end

    def self.name_inputs
        @first_name = @@prompt.ask("Enter your first name:") { |input| input.validate /^(?=.{1,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$/, "Sorry, your entry must be at least 2 characters and not contain symbols." }
        @last_name = @@prompt.ask("Enter your last name:") { |input| input.validate /^(?=.{1,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$/, "Sorry, your entry must be at least 2 characters and not contain symbols." }
    end

    def self.login_inputs
        @username = @@prompt.ask("Enter username:") { |input| input.validate /^(?=.{1,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$/, "Sorry, your entry must be at least 2 characters and not contain symbols." }
        @password = @@prompt.mask("Enter password:") { |input| input.validate /^^(?=.{1,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$/, "Sorry, your entry must be at least 2 characters and not contain symbols." }
    end

    def self.creation_inputs
        @username = @@prompt.ask("Enter username:") { |input| input.validate /^(?=.{1,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$/, "Sorry, your entry must be at least 2 characters and not contain symbols." }
        if User.find_by(username: "#{@username}")
            puts "Username already exists. Try again." 
            creation_inputs
        else
            @password = @@prompt.mask("Enter password:") { |input| input.validate /^^(?=.{1,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$/, "Sorry, your entry must be at least 2 characters and not contain symbols." }
        end
    end
    
    def self.account_creation
        @@user = User.create(first_name: "#{@first_name}", last_name: "#{@last_name}", username: "#{@username}", password: "#{@password}")
        puts "Congrats, #{@first_name}! Your account has been created."
    end

    def self.login_logic
        @@user = User.find_by(username: "#{@username}")
        if @@user && @@user.password == @password
            puts "Hi, #{@@user.first_name}!"
        else
            puts "Your username and/or password is incorrect. Please try again."
            login_verification
        end
    end

    def self.delete_account
        @@decision = @@prompt.select("Are you sure?", ["Yes", "No"])
        if @@decision == "Yes"
            @@user.destroy
            @@prompt.keypress("Oh, no. We're sad to see you leave, but here's a killer infinite loop for ya! Press any key to continue, resumes automatically in 5 seconds ...", timeout: 5)
            start
        else 
            CommandLineInterface.general_menu
        end
    end

    def self.create_account_instance
        name_inputs
        creation_inputs
        account_creation
    end

    def self.login_verification
        login_inputs
        login_logic
    end
end