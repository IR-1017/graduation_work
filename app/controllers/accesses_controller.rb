class AccessesController < ApplicationController
  def show
    @letter = Letter.find_by!(view_token: params[:token])
    @template = @letter.template
  end

  def public_page?
    true
  end
end