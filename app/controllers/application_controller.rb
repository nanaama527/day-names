class ApplicationController < Sinatra::Base

    configure do
        enable :sessions
        set :session_secret, "daynames1234"
    
        set(:views, 'app/views')
        set :public_folder, 'public'
    end

    register Sinatra::Flash

    get('/') do
        erb :home
    end

    helpers do
        def current_user
            User.find_by(id: session[:user_id]) 
        end

        def logged_in?
            !!current_user
        end

        def owner?
            current_user == post_owner
        end

        def admin?
            logged_in? && current_user.admin?
        end
        
        def super?
            logged_in? && current_user.super?
        end
    end
end