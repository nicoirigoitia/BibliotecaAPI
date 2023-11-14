# frozen_string_literal: true

class Api::V1::UsersController < Api::ApiController
  before_action :set_user, only: %i[show update destroy]

  def index
    @users = User.all
    render json: serialize(@users)
  end

  def show
    render json: serialize(@user)
  end

  def create
    @user = User.create!(user_params)
    render json: serialize(@user), status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e }, status: :unprocessable_entity
  end

  def update
    @user.update!(user_params)
    render json: serialize(@user)
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e }, status: :unprocessable_entity
  end

  def destroy
    @user.destroy!
    head :no_content
  rescue ActiveRecord::RecordNotDestroyed => e
    render json: { errors: e.record&.errors }, status: :conflict
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'User not found' }, status: :not_found
  end
end
