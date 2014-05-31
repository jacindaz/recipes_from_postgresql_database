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
  recipe_query = "SELECT recipes.id,recipes.instructions,recipes.description,
                          ingredients.id, ingredients.name
                  FROM recipes
                      JOIN ingredients ON ingredients.recipe_id = recipes.id
                  "


  @recipes = db_connection do |conn|
                conn.exec(recipe_query)
              end

              #binding.pry
  erb :index
end

get '/' do
  redirect '/recipes'
end
