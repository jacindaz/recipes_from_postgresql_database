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
  #pulling in data for a particular recipe---------------------------------------------
  ingredients_query = "SELECT name AS recipe, id, description,
                              recipes.instructions
                        FROM recipes
                        WHERE recipes.id = $1"
  @ingredients = db_connection do |conn|
                    conn.exec_params(ingredients_query, [@id])
                  end
  @title = "#{@ingredients[0]["recipe"]} Recipe"
  erb :show
end


get '/' do
  redirect '/recipes'
end
