require 'open-uri'
require 'json'
require 'pry-byebug'

class GamesController < ApplicationController
  def new
    letters = ("A".."Z").to_a
    @grid = []
    9.times { @grid << letters.sample }
    @grid
  end

  def score
    #if the word is in the grid and it's a valid word then return success
    #elsif the word is not in the grid/word is not a valid word then return fail
    @word = params[:answer]
    @letter_grid = params[:letter_grid]
    @final_message = ""

    def word_in_grid?(word, grid)
      grid_chars = Hash.new(0)
      grid.split(" ").each{ |char| grid_chars[char] += 1}
      word_chars = Hash.new(0)
      word.split("").each{ |char| word_chars[char] += 1}
      word_chars.each do |letter, count| 
        return "Sorry but #{word.upcase} can't be built out of #{grid}" if count > grid_chars[letter]
      end
      return ""
    end

    def valid_word?(word)
      url = "https://wagon-dictionary.herokuapp.com/#{word}"
      result = JSON.parse(open(url).read)
      return "Sorry but #{word} is not an english word" unless result["found"]
      return ""
    end

    @final_message = valid_word?(@word.upcase)
    @final_message = word_in_grid?(@word.upcase, @letter_grid) if @final_message.empty?
    @final_message = "Great Job!" if @final_message.empty?

   

  end

  
  

end
