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

  #pulling in data from ingredients database---------------------------------------------
  ingredients_query = "SELECT * FROM ingredients"
  @ingredients = db_connection do |conn|
                    conn.exec(ingredients_query)
                  end

  erb :index
end

get '/' do
  redirect '/recipes'
end
