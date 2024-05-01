#Now refactor your code to allow the human player to choose whether they want to be the creator of the secret code or 
#the guesser.
module CodeValidator
  
  def validate_code(code)
    raise ArgumentError, 'Invalid input. Try again.' unless code.length == 4 && code.all? { |i| i.between?('1','6') }
    code
  end
end

module Evaluate
  
  def evaluate_guess(code , guess)
    guess = guess.dup
    black_pegs = code.zip(guess).count { |c, g| c == g }
    white_pegs = 0
    
    code.each do |value|     
      guess_index = guess.index(value)  
      
      if guess_index
        white_pegs += 1
        guess.delete_at(guess_index)
      end
    end
    white_pegs -= black_pegs
    return [black_pegs, white_pegs]
  end
end

class Board
  include Evaluate

  def initialize
    @role = ''
    @black_pegs = 0
    @white_pegs = 0
    @tries = 12
    game_introduction
    setup_game(choose_role)
    play_mode
  end

  def play_mode 
    @role == '1' && play_codebreaker
    @role == '2' && play_codemaker
  end

  def game_introduction
    puts "\nWelcome to Mastermind!\nINTRUCTIONS:\n\nCrack the 4-digit code or make a 4-digit code, using numbers 1-6, with repeats allowed."
    puts"A white peg (W) indicates that a guessed number is correct but in the wrong position,\n while a black peg (B) indicates a guessed number is correct and in the correct position."
  end

  def play_codebreaker
    while @tries > 0  
      
      puts "\nYou have #{@tries} tries"
      @code_breaker.human_guess
      @code_maker.code
      result = evaluate_guess(@code_maker.code, @code_breaker.guess)
      @black_pegs = result[0]
      @white_pegs = result[1]
      display_pegs
      break if winner?
      reset_pegs
      lost?
    end
  end

  def play_codemaker
    while @tries > 0 
      
      puts "The computer has #{@tries} tries"
      @code_breaker.make_guess(@tries)
      puts "Codebreaker guess is: #{@code_breaker.guess}"
      result = evaluate_guess(@code_maker.code, @code_breaker.guess)
      @code_breaker.eliminates_code(result)
      @black_pegs = result[0]
      @white_pegs = result[1]
      display_pegs
      break if winner?
      reset_pegs
      lost?
    end
  end

  private
  
  def display_pegs
    white_pegs = 'W' * @white_pegs 
    black_pegs = 'B' * @black_pegs
    pegs = [white_pegs, black_pegs].join
    pegs = pegs.split("")
    pegs = pegs.rotate(rand(100)).join
    puts pegs
  end

  def choose_role
    puts 'Press 1 to be the codebreaker, press 2 to be the codemaker'
    loop do
      role = gets.chomp
      return role if role.size == 1 && role =~ /[1-2]/
      puts 'Invalid option. Press 1 to be the codebreaker, press 2 to be the codemaker'
    end
  end

  def setup_game(role)
    case role
    when '1'
      @code_breaker = HumanCodeBreaker.new
      @code_maker = CodeMaker.new(:computer)
      @role = role
    when '2'
      @code_maker = CodeMaker.new(:human)
      @code_breaker = ComputerCodeBreaker.new
      @role = role
    else
      raise ArgumentError
    end 
  end

  def lost?
    if @tries == 0
      puts "Codebreaker lose! The code was #{@code_maker.code.join}"
      return true
    end
  end

  def winner?
    @tries -=1
    if @black_pegs == 4
      puts 'The codebreaker wins!'
      return true
    end
  end

  def reset_pegs
    @white_pegs = 0
    @black_pegs = 0
  end
end

class CodeMaker
  
  attr_reader :code

  include CodeValidator

  NUMBERS = %w(1 2 3 4 5 6)

  def initialize(code_method)
    if code_method == :computer
      @code = computer_code
    elsif code_method == :human
      @code = human_code
    else
      raise ArgumentError, 'Invalid code generation method'
    end
  end
  
  private
  
  def computer_code
    Array.new(4) { NUMBERS.sample }
  end

  def human_code 
    puts 'Create a code:'
    begin
      code = gets.chomp.split('')
      validate_code(code)
    
    rescue ArgumentError => e   
      puts e.message
        retry
    end
  end
end

class HumanCodeBreaker
  attr_reader :guess

  include CodeValidator

  def initialize
    @guess = ''
  end
  
  def human_guess
    print "What's your guess: "
    begin
      @guess = gets.chomp.split('')
      validate_code(@guess)
    
    rescue ArgumentError => e
      puts e.message
      retry
    end  
  end 
end

class ComputerCodeBreaker
  attr_reader :guess 
  attr_accessor :all_codes

  include Evaluate

  def initialize
    @guess = ''
    @all_codes = ('1111'..'6666').to_a
  end

  def make_guess(tries)
    if tries == 12
      @guess = all_codes.sample.split('')
    else  
      @guess = all_codes[0].split('')
    end
  end

  def eliminates_code(result)
    self.all_codes = all_codes.reject{|code| evaluate_guess(code.split(''), @guess) != result }
  end
end

x = Board.new
