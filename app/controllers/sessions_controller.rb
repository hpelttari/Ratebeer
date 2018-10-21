class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create
    user = User.find_by username: params[:username]
    # tarkastetaan että käyttäjä olemassa, ja että salasana on oikea
    if user&.authenticate(params[:password]) && user&.active
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back!"
    elsif user.active == false
      redirect_to signin_path, notice: "The account is closed, contact administrators"
    else
      redirect_to signin_path, notice: "Username and/or password mismatch"
    end
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end

  def create_oauth
    user = User.github_signin(request.env['omniauth.auth'].info)

    if user
      session[:user_id] = user.id
      redirect_to user_path(user)
    else
      redirect_to signin_path, notice: "Signin with Github failed"
    end
  end
end
