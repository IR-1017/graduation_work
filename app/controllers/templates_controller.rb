class TemplatesController < ApplicationController
  before_action :authenticate_user!, only: [:select]

  def index
    @templates = Template.active
  end

  def select
    # タブ切り替え用の kind パラメータ（デフォルトは便箋）
    @kind = params[:kind].presence || 'stationery'
    @templates = Template.active.where(kind: @kind)
  end
end