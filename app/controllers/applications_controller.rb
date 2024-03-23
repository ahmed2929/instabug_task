# app/controllers/applications_controller.rb
class ApplicationsController < ApplicationController
  def create
    application = Application.new(application_params)
    application.token = SecureRandom.hex(10) # Generate a random token

    if application.save
      render json: { name: application.name, token: application.token }, status: :created
    else
      render json: { errors: application.errors.full_messages }, status: :unprocessable_entity
    end
  end
  def update
    #if no token or application is not found, return 404
    @application = Application.find_by!(token: params[:token])
    if @application.update(application_params)
      render json: @application
    else
      render json: { errors: @application.errors.full_messages }, status: :unprocessable_entity
    end
  end
  def index
    @applications = Application.all
    render json: @applications
  end
  def show
    if params[:token].nil?
      @applications = Application.all
      render json: @applications
    else
      @application = Application.find_by(token: params[:token])
      if @application
        render json: @application
      else
        render json: { error: 'Application not found' }, status: :not_found
      end
    end
  end
  private

  def application_params
    params.require(:application).permit(:name)
  end


end
