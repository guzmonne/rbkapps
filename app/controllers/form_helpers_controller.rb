class FormHelpersController < ApplicationController
  respond_to :json

  def index
    respond_with FormHelper.all
  end

  def show
    respond_with FormHelper.find(params["id"])
  end

  def create
    respond_with FormHelper.create(params["form_helper"])
  end

  def update
    respond_with FormHelper.update(params["id"], params["form_helper"])
  end

  def destroy
    FormHelper.find(params["id"]).destroy
    @result = {status: :ok}
    respond_with @result
  end
end
