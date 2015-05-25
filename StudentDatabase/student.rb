require 'dm-core'
require 'dm-migrations'

class Student
  include DataMapper::Resource
  property :id, Serial
  property :firstName, String
  property :nickName, Text
  property :lastName, String
  property :released_on, Date
  
  def released_on=date
    super Date.strptime(date, '%m/%d/%Y')
  end
end


configure do
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

DataMapper.finalize

get '/student' do
  @songs = Student.all
  slim :students
end

get '/student/new' do
  halt(401,'Not Authorized') unless session[:admin]
  @song = Student.new
  slim :new_student
end

get '/student/:id' do
  @song = Student.get(params[:id])
  slim :show_student
end

get '/student/:id/edit' do
  @song = Student.get(params[:id])
  slim :edit_students
end

post '/student' do  
  song = Student.create(params[:song])
  redirect to("/student/#{song.id}")
end

put '/student/:id' do
  song = Student.get(params[:id])
  song.update(params[:song])
  redirect to("/student/#{song.id}")
end

delete '/student/:id' do
  Student.get(params[:id]).destroy
  redirect to('/student')
  
end




