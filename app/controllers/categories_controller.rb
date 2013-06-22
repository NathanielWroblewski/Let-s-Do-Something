class CategoriesController < ApplicationController
  
  def index
    @categories = Category.all_sorted
  end

  def show
    @categories = Category.all_sorted
    @category = Category.find(params[:id])
    @activities = @category.activities
  end

  def about
    @categories = Category.all_sorted
    @category = Category.find(params[:id])
  end

end
