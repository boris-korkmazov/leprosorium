require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
  @db = SQLite3::Database.new "leprosorium.db"
  @db.results_as_hash = true
end

before do
  init_db
end

configure do
  init_db
  @db.execute "Create table IF NOT EXISTS Posts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    created_at DATE,
    content TEXT
    )" 
end

get '/' do
  erb :index
end


get '/new_post' do
  erb :new_post
end

post '/new_post' do

  content = params[:content]

  if content.length <= 0
    @error = "Type text"

    return erb :new_post
  end

  @db.execute 'insert into Posts (content, created_at) values (?, datetime())', [content]

  erb "You typed '#{content}'"
end
