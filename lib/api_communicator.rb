require 'rest-client'
require 'json'
require 'pry'

def get_character_movies_from_api(character)
  all_characters = RestClient.get('http://www.swapi.co/api/people/')
  character_hash = JSON.parse(all_characters)

  character_films = nil
  films_hash = []

  character_hash["results"].each do |item|
    item.each do |k,v|
      if k == "name"
        if v.downcase == character
          character_films = item["films"]
        end
      end
    end
  end

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
  films_hash = get_character_movies_from_api(character)
  parse_character_movies(films_hash)
end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
