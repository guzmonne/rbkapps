class NotesController < ApplicationController

  respond_to :json

  def index
    @notes = Note.where('table_name = ? AND table_name_id = ?', params["table_name"], params["table_name_id"])
    respond_with @notes
  end

  def create
    respond_with Note.create(params["note"])
  end

  def destroy
    respond_with Note.find(params["id"]).destroy
  end
end
