require 'sinatra/base'
require 'sinatra/flash'
require_relative './lib/wordguesser_game.rb'

class WordGuesserApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash

  before do
    @game = session[:game] || WordGuesserGame.new('')
  end

  after do
    session[:game] = @game
  end


  get '/' do
    redirect '/new'
  end

  get '/new' do
    erb :new
  end

  post '/create' do
   
    word = params[:word] || WordGuesserGame.get_random_word
   
    @game = WordGuesserGame.new(word)
    redirect '/show'
  end

 
  post '/guess' do
    if params[:guess].to_s[0] =~ /[[:alpha:]]/
      letter = params[:guess].to_s[0]
      if @game.guesses.include? letter or @game.wrong_guesses.include? letter
        flash[:message] = "You have already used that letter."
      else
        @game.guess letter
      end
    else
      flash[:message] = "Invalid guess."
    end
    redirect '/show'
  end

 
  get '/show' do
    if @game.check_win_or_lose == :win then redirect '/win'
    elsif @game.check_win_or_lose == :lose then redirect '/lose'
    else erb :show end 
  end

  get '/win' do
    if @game.check_win_or_lose == :win then erb :win 
    else redirect '/show' end
  end

  get '/lose' do
    if @game.check_win_or_lose == :lose then erb :lose 
    else redirect '/show' end
  end

end
