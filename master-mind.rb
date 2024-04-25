
class Board

  def initialize
    @black_pegs = 0
    @white_pegs = 0
    
    @code_maker = CodeMaker.new
    @code_breaker = CodeBraker.new
    @tries = 12
  
  end

  def play
    puts "\nWelcome to Mastermind!\nINTRUCTIONS:\n\nCrack the 4-digit code, using numbers 1-6, with repeats allowed."
    puts"A white peg (W) indicates that a guessed number is correct but in the wrong position,\nwhile a black peg (B) indicates a guessed number is correct and in the correct position."
   
    while @tries > 0 
      puts "\nYou have #{@tries} tries"
      @code_breaker.pick_guess
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

  def initialize
    @code = generate_code
  end

  private
  
  def generate_code
    Array.new(4) { NUMBERS.sample }
  end
end

class CodeBraker
  attr_reader :guess

  def initialize
    @guess = ''
  end
  
  def pick_guess
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
x.play