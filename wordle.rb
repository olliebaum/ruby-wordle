class Wordle
    require './words.rb'
    SET_OWN_START_WORD = false

    def initialize
        puts 'Welcome to Terminal Wordle'
        @new_game = true
        @playing = true

        while @playing do
            take_a_turn
        end
    end

    def ask_for_start_word
        print 'Enter a starting word: '
        @start_word = gets.chomp.downcase
        @new_game = false
    end

    def start_new_game
        @victory = false; @failure = false
        @possible_letters = 'abcdefghijklmnopqrstuvwxyz'.chars
        @guesses = 6
        return ask_for_start_word if SET_OWN_START_WORD
        @start_word = Words::LIST.sample
        @new_game = false
        puts "A random word has been chosen. You have 6 guesses."
    end

    def take_a_turn
        start_new_game if @new_game
        ask_for_guess
        puts @guess_word.chars.join(' ')
        puts colour_clue_response
        puts "#{@guesses} guesses remaining."
        puts @possible_letters.join(' ')

        check_for_victory
    end

    def ask_for_guess
        valid = false
        until valid do
            puts
            print 'Enter a guess: '
            @guess_word = gets.chomp.downcase
            unless @guess_word.length == 5
                puts "Your guess must be a 5 letter word."
                next
            end
            unless Words::LIST.include?(@guess_word)
                puts "That isn't a valid word."
                next
            end
            valid = true
        end
        @guesses -= 1
    end

    def colour_clue_response
        response = {}
        unguessed_letters = @start_word.chars
        @guess_word.chars.each_with_index do |char, index|
            if char == @start_word[index]
                response[index] = '🟩'
                unguessed_letters.delete_at(unguessed_letters.index(char))
            end
        end
        @guess_word.chars.each_with_index do |char, index|
            next if response[index]

            if unguessed_letters.include?(char)
                response[index] = '🟨'
                unguessed_letters.delete_at(unguessed_letters.index(char))
            else
                response[index] = '⬜'
                @possible_letters.delete(char) unless @start_word.include?(char)
            end
        end
        response.sort.to_h.values.join
    end

    def check_for_victory
        @victory = @guess_word == @start_word
        @failure = @guesses == 0
        if @victory
            puts 'You guessed the word, well done!'
        elsif @failure
            puts "You ran out of guesses. The word was: #{@start_word.upcase}"
        end
        ask_to_play_again if @victory || @failure
    end

    def ask_to_play_again
        puts
        print 'Would you like to play again? (Y/n): '
        response = gets.chomp
        if response.empty? || response.downcase == 'yes' || response.downcase == 'y'
            @new_game = true
        else
            @playing = false
        end
    end
end

Wordle.new