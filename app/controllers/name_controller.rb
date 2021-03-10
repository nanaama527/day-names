class NameController < ApplicationController
    register Sinatra::Flash
    
    get '/names' do
        @names = Name.all
        erb :'namelist/index'
    end
    
    get '/names/name-meanings' do
        if params[:name] == "Day Names (You can type)"
          flash[:message] = "Select a Name."
          redirect "/names"
        end
        name meanings = Name.find_by(name: params[:name], day: params[:day])
        redirect "/names/#{country.id}"
    end
    
    get '/names/:id' do
        @names = Name.find_by(id: params[:id])
        @posts = Post.select {|post| post.name == @name}.sort_by {|post| post.created_at}.reverse
        erb :'/names/show'
    end
end