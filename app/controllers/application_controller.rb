class ApplicationController < Sinatra::Base

    configure do
        set(:views, 'app/views')
        set :public_folder, 'public'
        enable :sessions
        set :session_secret, "secret"
       
    end

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
            logged_in? && current_user.super
        end
    end
end