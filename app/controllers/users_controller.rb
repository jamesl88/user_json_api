class UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users, each_serializer: UserSerializer
  end

  def create
    user = User.new(user_params)

    if user.save
      render json: user
    else
      render json: user.errors
    end
  end

  def update
    @user = User.find_by(email: user_params[:email])
    render(json: {}, status: 401) && return unless(authenticated_password?)

    @user.assign_attributes(user_params.except(:email))
    if @user.save
      render json: @user
    else
      render json: {}, status: 401
    end
  end

  def destroy
    @user = User.find_by(email: user_params[:email])
    render(json: {}, status: 401) && return unless(authenticated_password?)

    if @user.soft_delete!
      render json: @user
    else
      render json: {}, status: 401
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

  def authenticated_password?
    Digest::SHA1.hexdigest("Add #{@user.salt} to #{user_params[:password]}") == @user.encrypted_password
  end
end
