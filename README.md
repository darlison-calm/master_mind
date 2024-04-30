# master_mind

Hi guys. I need help in debugging the computer strategy to solve mastermind. I choose Swaszek strategy:

1.Create the list 1111,...,6666 of all candidate secret codes
2.Start with a random number
3.After you got the answer eliminate from the list of candidates all codes that would not have produced the same answer if they were the secret code.
4.Pick the first element in the list and use it as new guess.

My program works fine when the secret code is contain only repeated numbers like '4444' , '6666'
but when the code is like '2311' the code does not work i receive this error message:

#make_guess: undefined method `split' for nil:NilClass (NoMethodError)

      #@guess = all_codes[0].split('')\r

I think that i did something wrong when writing the 3 step of the algorithm
This is the code: 
class ComputerCodeBreaker
  attr_reader :guess 
  attr_accessor :all_codes

  include Evaluate
  #Create the list 1111,...,6666 of all candidate secret codes
  def initialize
    @guess = ''
    @all_codes = ('1111'..'6666').to_a
  end

  def make_guess(tries)
    #Start with a random number
    if tries == 12
      @guess = '1111'.split('')
    #Pick the first element in the list and use it as new guess
    else  
      @guess = all_codes[0].split('')
    end
  end
  
  #eliminate codes that would not have produced the same answer if they were the secret code.
  def eliminates_code(result)
    self.all_codes = all_codes.reject{|code| evaluate_guess(@guess, code.split('')) != result }
  end
end

