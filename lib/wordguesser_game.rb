class WordGuesserGame

  
  attr_accessor :word, :guesses, :wrong_guesses

  

  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

  def new(word)
    @hangpersonGame = HangpersonGame.new(word)
  end

  def guess(char)
    if char =~ /[[:alpha:]]/
      char.downcase!
      if @word.include? char and !@guesses.include? char
        @guesses.concat char
        return true
      elsif !@wrong_guesses.include? char and !@word.include? char
        @wrong_guesses.concat char
        return true
      else
        return false
      end
    else
      char = :invalid
      raise ArgumentError
    end
  end

  def word_with_guesses
    result = ""
    @word.each_char do |letter|
      if @guesses.include? letter
        result.concat letter
      else
        result.concat '-'
      end
    end
    return result
  end

  def check_win_or_lose
    counter = 0
    return :lose if @wrong_guesses.length >= 7
    @word.each_char do |letter|
      counter += 1 if @guesses.include? letter 
    end
    if counter == @word.length then :win
    else :play end
  end

end
