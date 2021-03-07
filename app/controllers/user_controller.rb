require 'rack-flash'

class UserController < AppController
    use Rack::flash

    get '/users' do
        if admin?
          @users = User.all
          erb :'users/index'
        else
          flash[:message] = "You are not permitted to view users list."
          if logged_in?
            redirect "/posts"
          end
          redirect "/login"
        end
    end

    get '/users/:id' do
        if admin? || (logged_in? && current_user.id == params[:id].to_i)
          @user = User.find_by_id(params[:id])
          erb :'users/show'
        else
          flash[:message] = "You are not allowed to view other users' info."
          if logged_in?
            redirect "/posts"
          end
          redirect "/login"
        end
    end


    get '/users/:id/posts' do
        if logged_in?
          @user = User.find_by_id(params[:id])
          if @user
            @posts = Post.all.select {|post|
              post.user == @user
            }.reverse
            erb :'users/user_posts'
          else
            flash[:message] = "Something went wrong..."
            redirect "/users/#{@user.id}"
          end
        else
          flash[:message] = "You have to log in first."
          redirect "/login"
        end
    end

    get '/signup' do
        if logged_in?
          flash[:message] = "Hello, #{current_user.username.upcase}"
          redirect "/posts"
        end
        erb :'users/signup'
    end

    post '/signup' do
        if params[:password] != params[:password_confirm]
          flash[:message] = "Passwords did not match..."
          redirect "/signup"
        elsif User.all.find {|user| user.username == params[:username]}
          flash[:message] = "' #{params[:username]} ' is already used by another user."
          redirect "/signup"
        elsif User.all.find {|user| user.email == params[:email]}
          flash[:message] = "' #{params[:email]} ' is a registerd email."
          redirect "/signup"
        end
    
        params.delete("password_confirm")
    
        if User.all.empty?
          @user = User.create(params)
          @user.admin = true
          @user.super = true
          @user.save
        else
          @user = User.create(params)
        end
        
        if @user.id
            session[:user_id] = @user.id
            flash[:message] = "Account successfully created!!!"
            redirect "/users/#{@user.id}"
        else
            flash[:message] = "Could not create your account. Please try again."
            redirect "/signup"
        end
    end

    get '/users/:id/edit' do
        if logged_in? && super? || current_user.id == params[:id].to_i
          @user = User.find_by_id(params[:id])
          erb :'users/edit'
        else
          flash[:message] = "Log in first~"
          redirect "/login"
        end
    end

    patch '/users/:id' do
        if logged_in? && super? || current_user.id == params[:id].to_i
          params.delete("_method")
          User.update(params[:id], params)
          flash[:message] = "User info successfully updated!"
          redirect "/users/#{params[:id]}"
        else
          flash[:message] = "You are not allowed to edit this user info."
          redirect "/users"
        end
    end
    
    delete '/users/:id' do
        if logged_in? && super?
          user = User.find_by_id(params[:id])
          flash[:message] = "The account of #{user.username.upcase} deleted!"
          user.destroy
          redirect "/users"
        else
          flash[:message] = "Could not delete the account..."
          redirect "/users/#{params[:id]}"
        end
    end
    
    get '/login' do
        if logged_in?
          flash[:message] = "Hello, #{current_user.username.upcase}"
          redirect "/posts"
        else
          erb :'users/login'
        end
    end
    
    post '/login' do
        user = User.find_by(username: params[:username])
        if !user
          flash[:message] = "Username not registered..."
          redirect '/login'
        elsif !user.authenticate(params[:password])
          flash[:message] = "Password does not match..."
          redirect '/login'
        end
    
        if user && user.authenticate(params[:password])
          session[:user_id] = user.id
          flash[:message] = "Hello, #{current_user.username.upcase}"
          redirect '/posts'
        else
          flash[:message] = "Log in failed... Try again."
          redirect '/login'
        end
    end
    
    get '/logout' do
        if logged_in?
          session.clear
          redirect '/'
        else
          flash[:message] = "Are you logged in?"
          redirect "/login"
        end
    end
end