class UsersController < ApplicationController
  def create
    @user = User.new(name: user_params[:name])
    User.transaction do
      @user.save!
      UserAuthentication.create!(
        user_id: @user.id,
        identifier: user_params[:identifier],
        password: user_params[:password]
      )
    end
    render json: { id: @user.id }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
  private
  def user_params
    params.expect(user: [:name, :identifier, :password])
  end
end
