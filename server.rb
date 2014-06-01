require 'sinatra'
require 'rubygems'
require 'pry'
require 'json'
require 'net/http'
require 'uri'
require 'pg'



#METHODS---------------------------------------------------------------------------------
def db_connection
  begin
    connection = PG.connect(dbname: 'recipes')
    yield(connection)
  ensure
    connection.close
  end
end

def split_value(hash, target_key, split_by)
  array = []
  hash.each do |key, value|
    if key == target_key
      array = value.split(split_by)
    end
  end
  #puts "#{array}"
  return array
end

def cleaned_up(array)
  remove_method_word = array[0].split("1")
  stripped = remove_method_word[1].strip
  new_array = array
  new_array[0] = stripped
  return new_array
end

def split_instruction_steps(array)

  array.each do |sentence|
    sentence.strip!
  end
  new_array = array

  array_of_hashes = []
  nested_hash = {}
  nested_hash["1"] = nil
  index = 1
  new_hash_value = nil
  new_array.each do |sentence|
    if sentence[0].to_i == 0  #if does not begin with a number, update hash
      current_hash_value = nested_hash[index.to_s]
      new_hash_value = "#{current_hash_value} #{sentence}."
      nested_hash[index.to_s] = new_hash_value
    else  #if does begin with a number
      if sentence[0].to_i != 0
        sentence = sentence[2..-1]
      end
      array_of_hashes << nested_hash
      nested_hash = {}
      index += 1
      current_hash_value = nested_hash[index.to_s]
      new_hash_value = "#{current_hash_value} #{sentence}."
      nested_hash[index.to_s] = new_hash_value
    end
  end
  array_of_hashes << nested_hash
  return array_of_hashes
end


#ROUTES---------------------------------------------------------------------------------
get '/recipes' do
  @title = "Find your favorite recipe!"
  #@num_recipes = params[:num_recipes]



  #pulling in data from recipes database------------------------------------------------
  recipe_query = "SELECT name AS recipe, id, instructions, description
                  FROM recipes ORDER BY recipes.name
                  LIMIT 100"
  @recipes = db_connection do |conn|
                conn.exec(recipe_query)
              end
  erb :index
end


get '/recipes/:id' do

  @id = params[:id]
  #pulling in data for 1 recipe's description and instructions-----------------------------
  descrip_instruc_query = "SELECT name AS recipe, id, description,
                              recipes.instructions
                        FROM recipes
                        WHERE id = $1"
  @description_instructions = db_connection do |conn|
                    conn.exec_params(descrip_instruc_query, [@id])
                  end

  #pulling in data for 1 recipe's ingredients----------------------------------------------
  ingredients_query = "SELECT id, name, recipe_id FROM ingredients
                        WHERE recipe_id = $1"

  @ingredients = db_connection do |conn|
                  conn.exec_params(ingredients_query, [@id])
                end
  @instructions = split_value(@description_instructions[0], "instructions", ".")


  #clean up instructions into a list--------------------------------------------------
  @instructions_array = cleaned_up(@instructions)
  @instructions_cleaned_up = split_instruction_steps(@instructions)


  @title = "#{@description_instructions[0]["recipe"]} Recipe"
  erb :show
end


get '/' do
  redirect '/recipes'
end














