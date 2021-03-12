class NameController < ApplicationController
    register Sinatra::Flash
    
    get '/namelist/new' do 
        if is_logged_in?
          erb :'namelist/new'
        else
          flash[:message] = "Looks like you weren't logged in yet. Please log in below."
          redirect to '/login'
        end
      end
    
      post '/namelist' do
        if params[:birthday] == "" || params[:day_name] == "" || params[:meaning] == ""  
          flash[:message] = "Oops! You must enter a birthday to see your day name. Please try again."
          redirect to '/namelist/new'
        else
          dayname = current_dayname
          @name = Name.create(
            :birthday => params[:birthday],
            :day_name => params[:day_name],
            :meaning => params[:meaning],
            :name_id => name.id)
          redirect to "/namelist/#{@name.id}"
        end
      end
    
    
      # Read
      get '/namelist' do
        if is_logged_in?
          @dayname = current_dayname
          @name = @dayname.name.all
          erb :'namelist/index'
        else
          flash[:message] = "Looks like you weren't logged in yet. Please log in below."
          redirect to '/login'
        end
      end
    
      get '/namelist/:id' do
        if is_logged_in?
          @name = Name.find_by_id(params[:id])
          if @name.name_id == session[:name_id]
            erb :'namelist/show'
          elsif @name.name_id != session[:name_id]
            redirect '/namelist'
          end
        else
          flash[:message] = "Looks like you weren't logged in yet. Please log in below."
          redirect to '/namelist'
        end
      end
    
      # Update
      get '/namelist/:id/edit' do
        if is_logged_in?
          @name = Name.find_by_id(params[:id])
          if @name.name_id == session[:name_id]
            erb :'namelist/edit'
          else
            flash[:message] = "Sorry that's not your review. You can't edit it."
            redirect to '/namelist'
            end
        else
          flash[:message] = "Looks like you weren't logged in yet. Please log in below."
          redirect to '/login'
        end
      end
    
      patch '/names/:id' do
        if params[:birthday] == "" || params[:day] == "" || params[:month] == "" || params[:year == ""
          flash[:message] = "Oops! Birthdays must have a day, month, and year. Please try again."
          redirect to "/names/#{params[:id]}/edit"
        else
          @name = Name.find_by_id(params[:id])
          @name.birthday = params[:birthday]
          @name.day_name = params[:day_name]
          @name.meaning = params[:meaning]
          @name.name_id = current_name.id
          @name.save
          flash[:messsage] = "Your day name has been updated!"
          redirect to "/names/#{@name.id}"
        end
      end
    
      # Delete
      delete '/names/:id/delete' do
        if is_logged_in?
          @name = Name.find_by_id(params[:id])
          if @name.name_id == session[:name_id]
            @name.delete
            flash[:message] = "The name profile was deleted."
            redirect to '/reviews'
          end
        else
          flash[:message] = "Looks like you weren't logged in yet. Please log in below."
          redirect to '/login'
        end
    end
    
end