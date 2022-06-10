require 'yaml'

class Hangman
    attr_accessor :word, :word_array, :guesses_left, :guess_array, :player_name, :game_over, :incorrect_guesses

    def initialize()
        @word = random_word
        @word_array = @word.split('')
        @guesses_left = 10
        @guess_array = Array.new(@word.length)
        @player_name = ""
        @valid_guesses = ("a".."z").to_a
        @game_over = false
        @incorrect_guesses = []
    end

    def get_name
        print "Please enter your name: "
        @player_name = gets.chomp
        @player_name
    end

    def play
        get_name if @player_name == ""
        display
        until @game_over
            update_guess(guess)
            display
            is_game_over
        end
    end

    def is_game_over
        if @guesses_left == 0 || !@guess_array.any?(nil)
            @game_over = true
            puts "The word was: #{word}\n" 
        end
    end

    def update_guess(guess)

        if @word_array.include? guess
            @word_array.each_with_index do |letter, index| 
                @guess_array[index] = guess  if letter == guess end
        else
            @incorrect_guesses.push(guess)
            @guesses_left -= 1
        end
    end

    def guess
        not_valid = true
        puts "---------------------------------------------------"
        print "\nPlease enter a letter for a guess: "
        while not_valid
            letter_guessed = gets.downcase
            if !@valid_guesses.include? letter_guessed.chomp
                print "Invalid guess, please enter another letter: "
                not_valid = true
            else
                not_valid = false
            end
        end
        letter_guessed.chomp
    end

    def random_word
        file = File.open('random.txt','r')
        word = file.readlines
        file.close
        random_word = word.sample
        unless random_word.length > 4 || random_word.length < 13
            random_word = word.sample
        end
        random_word.chomp
    end

    def save_game
        YAML.dump ({
            :name => @name,
            :word => @word, 
            :word_array => @word_array, 
            :guesses_left => @guesses_left, 
            :guess_array => @guess_array, 
            :player_name => @player_name, 
            :game_over => @game_over, 
            :incorrect_guesses => @incorrect_guesses
        })
    end

    def display
        puts "\nGuesses remaining: #{@guesses_left}\n\n"
        if @incorrect_guesses.length > 0
            puts "Incorrect guesses: "
            puts @incorrect_guesses.join(", ") 
            puts 
        end
        puts "The word board"
        @guess_array.each do |letter|
            if letter.nil? 
                print "_ "
            else
                print "#{letter} "
            end
        end
        puts
        puts
    end
end

hang = Hangman.new()
hang.play