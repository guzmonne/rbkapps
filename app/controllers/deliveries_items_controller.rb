class DeliveriesItemsController < ApplicationController

    respond_to :json

    def index
      respond_with DeliveriesItems.all
    end

end
