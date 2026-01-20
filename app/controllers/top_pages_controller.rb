class TopPagesController < ApplicationController
  def index
    @stationery_templates     = Template.active.stationery.limit(7)
    @message_card_templates   = Template.active.message_cards.limit(7)
  end
end
