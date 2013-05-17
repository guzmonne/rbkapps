class CategoriesController < ApplicationController
  respond_to :json

  def index
    respond_with Category.all
  end

  def show
    respond_with Category.find(params["id"])
  end

  def create
    respond_with Category.create(params["category"])
  end

  def update
    respond_with Category.update(params["id"], params["category"])
  end

  def destroy
    @id = params["id"]
    @level = params["level"]
    @base_category = Category.find(@id)
    @categories = []
    if @level == "1"
      @categories = Category.where("category1 = ?", @base_category.category1)
    elsif @level == "2"
      @categories = Category.where("category1 = ? AND category2 = ?", @base_category.category1, @base_category.category2)
    elsif @level == "3"
      @categories = Category.where("category1 = ? AND category2 = ? AND category3 = ?", @base_category.category1, @base_category.category2, @base_category.category3)
    end
    @categories.each do |category|
      print(category)
      category.destroy
    end
    @result = {status: :ok}
    respond_with @result
  end
end