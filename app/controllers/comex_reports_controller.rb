class ComexReportsController < ApplicationController
  def index
    @report = params["report"]
    if @report == 'items_status'
      @items = Item.items_deliveries
      respond_to do |format|
        format.json { render :json => Item.items_deliveries }
        format.xls  { render :template => '/items/index', :layout => false }
      end
    elsif @report == 'days_to_dispatch'
      @deliveries = Delivery.all
      respond_to do |format|
        format.xls { send_data @deliveries.to_xls, content_type: 'application/vnd.ms-excel', filename: 'days_to_dispatch.xls' }
      end
    end
  end
end
