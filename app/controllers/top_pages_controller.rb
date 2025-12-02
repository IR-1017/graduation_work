class TopPagesController < ApplicationController
  def index
    @stationery_templates     = Template.active.stationery.limit(4)
    @message_card_templates   = Template.active.message_cards.limit(4)
  end
end
