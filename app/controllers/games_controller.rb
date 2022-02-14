require "json"
require "open-uri"

class GamesController < ApplicationController

  def new
    @letters = ('A'..'Z').to_a.shuffle[0..9]
  end

  def score
    @english_word = dictionary?(params[:word])
    @good_letters = letters_inclusion(params[:word], params[:letters])
    @answer = results(@english_word, @good_letters)
  end

  def results(english_word, good_letters)
    if english_word && good_letters
      answer = "Congratulations ! #{params[:word]} is a valid English word !"
    elsif english_word && good_letters == false
      answer = "Sorry but #{params[:word]} can't be built out of these letters"
    else
      answer = "Sorry but #{params[:word]} doesn't seem to be an English word..."
    end
    answer
  end

  def letters_inclusion(my_word, letters)
    my_word = params[:word]
    my_word.chars.all? { |letter| my_word.count(letter) <= letters.count(letter) }
  end

  def dictionary?(my_word)
    url = "https://wagon-dictionary.herokuapp.com/#{my_word}"
    user_serialized = URI.open(url).read
    user = JSON.parse(user_serialized)
    user['found']
  end

end
