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




#ROUTES---------------------------------------------------------------------------------
get '/recipes' do
  @title = "Find your favorite recipe!"


  #pulling in data from recipes database------------------------------------------------
  recipe_query = "SELECT name AS recipe, id, instructions, description
                  FROM recipes ORDER BY recipes.name
                  LIMIT 10"
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

  @title = "#{@description_instructions[0]["recipe"]} Recipe"
  erb :show
end


get '/' do
  redirect '/recipes'
end














