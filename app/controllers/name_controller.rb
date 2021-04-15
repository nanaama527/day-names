class NameController < ApplicationController
    register Sinatra::Flash
    
    get '/namelist/new' do 
        if logged_in?
          erb :'namelist/new'
        else
          flash[:message] = "Looks like you weren't logged in yet. Please log in below."
          redirect to '/login'
        end
    end
    
      post '/namelist' do
        if params[:name] == "" || params[:description] == "" 
          flash[:message] = "Oops! You must enter a day name to see your name description. Please try again."
          redirect to '/namelist/new'
        else
          @name = Name.create(
            :description => params[:description],
            :name => params[:name],
            :user_id => session[:user_id])
          redirect to "/namelist/#{@name.id}"
        end
      end
    
    
      # Read
      get '/namelist' do
        if logged_in?
          @names = Name.all
          erb :'namelist/index'
        else
          flash[:message] = "Looks like you weren't logged in yet. Please log in below."
          redirect to '/login'
        end
      end
    
      get '/namelist/:id' do
        if logged_in?
          @name = Name.find_by_id(params[:id])
          if @name.user_id == session[:user_id]
            erb :'namelist/new'
          elsif @name.user_id != session[:user_id]
            redirect '/namelist'
          end
        else
          flash[:message] = "Looks like you weren't logged in yet. Please log in below."
          redirect to '/namelist'
        end
      end
    
      # Update
      get '/namelist/:id/edit' do
        if logged_in?
          @name = Name.find_by_id(params[:id])
          if @name.user_id == session[:user_id]
            erb :'namelist/edit'
          else
            flash[:message] = "Sorry that's not your profile. You can't edit it."
            redirect to '/namelist'
          end
        else
          flash[:message] = "Looks like you weren't logged in yet. Please log in below."
          redirect to '/login'
        end
      end
    
      patch '/names/:id' do
        if params[:name] == "" || params[:description] == ""  
          flash[:message] = "Oops! Please try again."
          redirect to "/names/#{params[:id]}/edit"
        else
          @name = Name.find_by_id(params[:id])
          @name.description = params[:description]
          @name.name = params[:name]
          @name.user_id = current_user.id
          @name.save
          flash[:messsage] = "Your day name has been updated!"
          redirect to "/names/#{@name.id}"
        end
      end
    
      # Delete
      delete '/names/:id/delete' do
        if logged_in?
          @name = Name.find_by_id(params[:id])
          if @name.user_id == session[:user_id]
            @name.delete
            flash[:message] = "The name profile was deleted."
            redirect to '/signup'
          end
        else
          flash[:message] = "Looks like you weren't logged in yet. Please log in below."
          redirect to '/login'
        end
    end
    
end