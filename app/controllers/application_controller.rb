# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :public_page?


  def public_page?
    false
  end
  
  private

  def configure_permitted_parameters
    added_attrs = %i[email password]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
  end
end
