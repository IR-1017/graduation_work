class TopPagesController < ApplicationController
  def index
    @stationery_templates     = Template.active.stationery.order(:id).limit(12)
    @message_card_templates   = Template.active.message_cards.order(:id).limit(12)
  end
end
