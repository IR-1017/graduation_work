# frozen_string_literal: true

class ApplicationController < ActionController::Base

  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    added_attrs = [ :email, :password ]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
  end
end
