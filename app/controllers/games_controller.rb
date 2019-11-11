require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
    @score = 0
  end

  def score
    # binding.pry
    session[:score] = 0 if session[:score].nil?
    @collected_letters = JSON.parse(params[:collected_input])
    @answer = params[:word]
    url = open("https://wagon-dictionary.herokuapp.com/#{@answer}").read
    @result = JSON.parse(url)
    @true_if_matching_letters = include_in_grid?(@answer, @collected_letters)
    session[:score] += @result["length"] if @result["length"].present?
    @score = session[:score]
  end

  def create_hash_from_array(array)
    hash_array = Hash.new(0)
    array.each { |el| hash_array[el] += 1 }
    hash_array
  end

  def create_hash_from_string(string)
    hash_string = Hash.new(0)
    string.gsub(/\W/, '').upcase.chars.each { |el| hash_string[el] += 1 }
    hash_string
  end

  def include_in_grid?(attempt, grid)
    # TODO: implement the improved method
    boolean = true
    hash_attempt = create_hash_from_string(attempt)
    hash_grid = create_hash_from_array(grid)
    hash_attempt.each do |key, value|
      if hash_grid.keys.include?(key) && value <= hash_grid[key]
      else boolean = false
      end
    end
    boolean
  end

  # def if_not_in_grid(hash)
  #   hash[:score] = 0
  #   hash[:message] = "not in the grid"
  #   hash
  # end

  # def if_invalid_word(hash)
  #   hash[:score] = 0
  #   hash[:message] = "invalid word / not an english word"
  #   hash
  # end

  # def well_done(string, hash)
  #   hash[:score] = string.length / hash[:time].to_i
  #   hash[:message] = "well done"
  # end
end

# JSON much better
# .gsub('[', '')
# .gsub(']', '')
# .gsub('"', '')
# .split(',')
