require 'rest-client'
require 'json'
require 'pry'

def get_all_characters(character)
  all_characters = RestClient.get('http://www.swapi.co/api/people/')
  character_hash = JSON.parse(all_characters)
end

def films_by_character(character_hash, character)
  character_films = nil
  character_hash["results"].each do |item|
    item.each do |k,v|
      if k == "name"
        if v.downcase == character
          character_films = item["films"]
        end
      end
    end
  end
  character_films
end

def film_hash_from_api(character_films)
  films_hash = []
  character_films.each do |film|
    all_films = RestClient.get(film)
    parsed_films = JSON.parse(all_films)
    films_hash << parsed_films
  end
  films_hash
end

def parse_character_movies(films_hash)
  puts "\nHere are some the character's films:\n\n"
  films_hash.each do |film|
    puts film["title"]
  end
end

def show_character_movies(character)
  character_hash = get_all_characters(character)
  character_films = films_by_character(character_hash, character)
  films_hash = film_hash_from_api(character_films)
  parse_character_movies(films_hash)
end
