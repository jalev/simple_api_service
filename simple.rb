require 'sinatra'
require 'data_mapper'
require 'json'

  # helpers Sinatra::JSON
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/simple.db")

class Application
  include DataMapper::Resource
  
  property :api_key,     APIKey, :key => true
end

class Data
  include DataMapper::Resource

  property :api_key,     APIKey, :key => true, :required => true
  property :data_key,    String, :length => 20
  property :data_values, String, :length => 100
end

DataMapper.finalize

Application.auto_upgrade!
Data.auto_upgrade!


post '/' do
  # For debugging
  @key = Application.all

  {"keys" => Array(@key)}.to_json

end

post '/register' do 
  @key = Application.new()
  @key.save
  @key.to_json
end

post '/store' do
  # For creation

end

put '/store' do
  # For altering an existing thing
  
  # Return error if no key provided

  # Return error if key is provided but does not exist in our registered
  # applications database

end

delete '/store' do 
  # For deleting a thing


  # Return error if no key provided

  # Return error if key is provided but does not exist in our registered
  # applications database


end

get '/retrieve' do
  # Parse JSON data for Key

  # Return error if no key provided
  
  # Return error if key is provided but does not exist in our registered
  # applications database

end

private

def is_valid_key?(key)
  # Search Application table for key.

  # Return true/false
end
