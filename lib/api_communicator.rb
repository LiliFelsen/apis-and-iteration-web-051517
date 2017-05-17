require 'rest-client'
require 'json'
require 'pry'

class Api
  def initialize params
    @params = params
  end

  def call
    JSON.parse(RestClient.get('http://www.swapi.co/api/' + @params + '/'))
  end

  def call_full
    JSON.parse(RestClient.get(@params))
  end
end

class Film
  ALL_FILMS = Api.new("films").call

  attr_accessor :data

  def initialize title
    @title = title
    @data = self.get_data
  end

  def get_data
    ALL_FILMS["results"].each do |item|
      item.each do |k,v|
        if k == "title"
          if v.downcase == @title
            return item
          end
        end
      end
    end
  end

  def get_titles title_url_array
    title_url_array.each do |url|
      ALL_FILMS["results"].each do |item|
        item.each do |k,v|
          if k == "url"
            if v == url
              puts item["title"]
            end
          end
        end
      end
    end
  end
end

class Character
  ALL_CHARACTERS = Api.new("people").call

  attr_accessor :data

  def initialize name
    @name = name
    @data = self.get_data
  end

  def get_data
    ALL_CHARACTERS["results"].each do |item|
      item.each do |k,v|
        if k == "name"
          if v.downcase == @name
            return item
          end
        end
      end
    end
  end

  def get_films
    film_urls = @data["films"]
    puts "\nHere are #{@name.capitalize}'s films:\n\n"
    film_urls.each do |url|
      film_hash = Api.new(url).call_full
      puts film_hash["title"]
    end
  end
end

def show_character_movies(character)
  new_input = Character.new character
  new_input.get_films
end
