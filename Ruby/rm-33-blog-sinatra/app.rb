require 'sinatra'
require 'sequel'
require 'sqlite3'


DB = Sequel.sqlite('app.db')

get '/' do
  @posts = DB[:posts]
  erb :posts
end

#retrieve new post, save to database, .insert redirects to the created post! 
post '/posts' do
  id = DB[:posts].insert(
    title: params[:title],
    author: params[:author],
    content: params[:content]
  )

  redirect "/posts/#{id}"
end

#1 go to the Edit.erb view page 
get '/posts/edit' do
  @posts = DB[:posts]
 
  erb :posts_edit
end

#to show the selected post by given post id
get '/posts/:id' do
  @post = DB[:posts].where(id: params["id"]).first

  erb :post
end

#2 link from index table or indiv post, to iniv post_edit_form view/page. :id _ONEEE
get '/posts/:id/edit' do
  @post = DB[:posts].where(id: params["id"]).first

  erb :post_edit_form
end


#3 Working here, to UPDATE
put '/posts/:id' do
  p params
  DB[:posts].where(id: params["id"]).update(params.slice("title", "author", "content"))

  redirect "/posts/edit"

end

post "/posts/:id/remove" do
  DB[:posts].where(id: params["id"]).delete

  redirect "/posts/edit"
end
