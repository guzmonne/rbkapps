class ComexReportsController < ApplicationController
  def index
    @report = params["report"]
    if @report == 'items_status'
      @items = Item.items_deliveries
      respond_to do |format|
        format.xls  { render :action => 'items_status' }
      end
    elsif @report == 'days_to_dispatch'
      @deliveries = Delivery.all
      respond_to do |format|
        format.xls  { render :action => 'days_to_dispatch' }
      end
    elsif @report == 'deliveries'
      @deliveries = Delivery.all
      respond_to do |format|
        format.xls { render :action => 'deliveries' }
      end
    end
  end
end
