require 'sinatra'
require 'data_mapper'
require 'json'

  # helpers Sinatra::JSON
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/simple.db")

class Application
  include DataMapper::Resource
  
  property :api_key,     APIKey, :key => true
end

class ApplicationData
  include DataMapper::Resource

  property :id,          Serial, :key => true
  property :api_key,     String, :required => true
  property :data_key,    String, :length => 20 
  property :data_value,  String, :length => 100
end

DataMapper.finalize

Application.auto_upgrade!
ApplicationData.auto_upgrade!


post '/' do
  # For debugging
  @key = Application.all

  { "http_code" => 200, "keys" => Array(@key) }.to_json

end

post '/register' do 
  @key = Application.new()
  @key.save
  @key.to_json
end

post '/store' do
  # For creation
  opts = JSON.parse(request.body.read) 
  halt(404, 
        {
          "return_code" => 404, 
          "reason" => "required value not found"
        }.to_json
      ) if !valid_request?(opts,['api_key', 'data_key', 'data_value'])

  key = Application.get(opts["api_key"])
  halt(404, {"return_code" => 404, "reason" => "key not found"}.to_json) if key.nil?

  if !ApplicationData.first(:api_key => opts["api_key"], :data_key => opts["data_key"]).nil?
    halt(403, {"return_code" => 403, "reason" => "Record already exists"})
  end

  data = ApplicationData.create(:api_key => opts["api_key"], :data_key => opts["data_key"], :data_value => opts["data_value"])
  data.save

  { "http_code" => 200}.to_json
  
end

put '/store' do
  # For altering an existing thing
  
  # Return error if no key provided

  # Return error if key is provided but does not exist in our registered
  # applications database

  opts = JSON.parse(request.body.read) 
  halt(404, 
        {
          "return_code" => 404, 
          "reason" => "required value not found"
        }.to_json
      ) if !valid_request?(opts,['api_key', 'data_key'])

  key = Application.get(opts["api_key"])
  halt(404, {"return_code" => 404, "reason" => "key not found"}.to_json) if key.nil?

  if ApplicationData.first(:api_key => opts["api_key"], :data_key => opts["data_key"]).nil?
    halt(404, { "http_code" => 404, "reason" => "record not found" }.to_json)
  end

  data = ApplicationData.update(:api_key => opts["api_key"], :data_key => opts["data_key"], :data_value => opts['data_value'])

  { "http_code" => 200, "reason" => "update success"}.to_json
 
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
  
  opts = JSON.parse(request.body.read) 
  halt(404, 
        {
          "return_code" => 404, 
          "reason" => "required value not found"
        }.to_json
      ) if !valid_request?(opts,['api_key'])

  key = Application.get(opts["api_key"])
  halt(404, {"return_code" => 404, "reason" => "key not found"}.to_json) if key.nil?

  data = ApplicationData.all(:api_key => opts["api_key"], :data_key => opts["data_key"])

  { "http_code" => 200, "data" => Array(data)}.to_json
 
end

private

def valid_request?(body, required=[:api_key])

  return false if required.find { | value | body[value].nil? }
  return true 

end

def is_valid_key?(key)
  # Search Application table for key.

  # Return true/false
end
