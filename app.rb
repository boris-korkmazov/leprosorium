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


  @db.execute "Create table IF NOT EXISTS Comments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    post_id INTEGER,
    created_at DATE,
    content TEXT
    )" 
end

get '/' do
  @results = @db.execute "Select * from Posts order by id desc"
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

  redirect to '/'
end

get '/details/:id' do
  post_id = params[:id]
  @results = @db.execute "Select p.id as post_id, p.content as post_content, p.created_at as post_created_at, c.id as c_id, c.content as c_content, c.created_at as c_created_at, c.post_id as c_post_id  FROM Posts as p LEFT JOIN Comments as c ON p.id = c.post_id Where p.id = ?", [post_id]
  @post = @results.first
  erb  :details
end


post '/details/:id' do

  post_id = params[:id]


  content = params[:content]

  @db.execute 'insert into Comments (content, post_id, created_at) values (?, ?, datetime())', [content, post_id]

  redirect to "/details/#{post_id}"
end