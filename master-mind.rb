#Now refactor your code to allow the human player to choose whether they want to be the creator of the secret code or 
#the guesser.

class Board
  
  def initialize
    @role = ''
    @black_pegs = 0
    @white_pegs = 0
    @tries = 12
    setup_game(choose_role)
    play_mode
  end

  def play_mode 
    if @role == 'decoder'
      play_human_codebreaker
    end
  end

  def setup_game(role)
    
    if role == '1'
      @code_breaker = HumanCodeBreaker.new
      @code_maker = CodeMaker.computer_code
      @role = 'decoder'
    end
  end
  
  def game_introduction
    puts "\nWelcome to Mastermind!\nINTRUCTIONS:\n\nCrack the 4-digit code, using numbers 1-6, with repeats allowed."
    puts"A white peg (W) indicates that a guessed number is correct but in the wrong position,\nwhile a black peg (B) indicates a guessed number is correct and in the correct position."
  end

  def play_human_codebreaker
    game_introduction
    while @tries > 0 
      puts "\nYou have #{@tries} tries"
      @code_breaker.human_guess
      check_pegs
      display_pegs
      if winner?
        break
      end
      @black_pegs = 0
      @white_pegs = 0
      lost?
    end
  end

  def choose_role
    puts "Press 1 to be the codebreaker, press 2 to be the codemaker"
    
    loop do
      role = gets.chomp
      if role.size == 1 && role =~ /[1-2]/
        return role
      end
    end
  end

  def lost?
    if @tries == 0
      puts "Codebreaker lose! The code was #{@code_maker.code.join}"
      return true
    end
  end

  def display_pegs
    white_pegs = 'W' * @white_pegs 
    black_pegs = 'B' * @black_pegs
    pegs = [white_pegs, black_pegs].join
    pegs = pegs.split("")
    pegs = pegs.rotate(rand(100)).join
    puts pegs
  end

  def winner?
    @tries -=1
    if @black_pegs == 4
      puts "You cracked the code!"   
      return true
    end
  end
  
  def check_pegs
    code = @code_maker.code
    guess = @code_breaker.guess
    
    @black_pegs = code.zip(guess).count { |c, g| c == g }
    code.each do |value|  
      
      guess_index = guess.index(value)
      
      if guess_index
        @white_pegs += 1
        guess.delete_at(guess_index)
      end
    end
    @white_pegs -= @black_pegs
  end
end

class CodeMaker
  attr_reader :code

  NUMBERS = %w(1 2 3 4 5 6)

  def initialize(code)
    @code = code
  end
  
  private
  
  def self.computer_code
    CodeMaker.new(Array.new(4) { NUMBERS.sample })
  end
end

class HumanCodeBreaker
  attr_reader :guess

  def initialize
    @guess = ''
  end
  
  def human_guess
    loop do
      print "What's your guess: "
      @guess = gets.chomp
      
      if @guess.size == 4 && @guess =~ /^\d+$/
        @guess = @guess.split('')
        break
      else
        puts 'invalid input'
      end
    end
  end 
end




x = Board.new