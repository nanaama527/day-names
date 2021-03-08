class NameListController < ApplicationController

    get '/names/new' do
        if is_logged_in?
            erb :'names/new'
          else
            flash[:message] = "Looks like you weren't logged in yet. Please log in below."
            redirect to '/login'
          end
        end
    end
    
    post '/names' do
        if params[:month] == "" || params[:day] == "" || params[:year] == "" # must have month, day & year, 
          flash[:message] = "Oops! To figure out your day name, you must enter your birthday. Please try again."
          redirect to '/name/new'
        else
           = 
          critic.Review.create(
            :title => params[:title],
            :genre => params[:genre],
            :content => params[:content],
            :rating => params[:rating],
            :critic_id => critic.id)
          redirect to "/reviews/#{@review.id}"
        end
    end

    
    get '/reviews' do
        if is_logged_in?
          @critic = current_critic
          @reviews = @critic.reviews.all
          erb :'reviews/index'
        else
          flash[:message] = "Looks like you weren't logged in yet. Please log in below."
          redirect to '/login'
        end
    end
    
    get '/reviews/:id' do
        
    
end