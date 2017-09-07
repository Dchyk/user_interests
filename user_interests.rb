require 'yaml'

require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'

before do 
  @users = YAML.load_file("users.yaml")
  @number_of_users = @users.keys.size
  @number_of_interests = count_interests  
end


get "/" do 
  redirect to('/users')
end

get "/users" do 
  erb :user_names
end

get "/:name" do
  @user_name = params['name']

  redirect "/" unless valid?(@user_name)

  @title = @user_name
  @interests = get_interests(@user_name)

  erb :user_page
end

helpers do 
  def get_interests(user_name)
    @users[user_name.to_sym][:interests].join(", ")
  end

  def count_interests
    interests = 0
    @users.values.each do |info|
      interests += info[:interests].size
    end
    interests
  end

  def valid?(name)
    @users.keys.include?(name.to_sym)
  end
end