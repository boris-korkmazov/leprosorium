require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do

end

def init_db
  @db = SQLite3::Database.new "leprosorium.db"
  @db.results_as_hash = true
end

before do
  init_db
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end


get '/new_post' do
  erb :new_post
end

post '/new_post' do
  content = params[:content]
  erb "You typed '#{content}'"
end