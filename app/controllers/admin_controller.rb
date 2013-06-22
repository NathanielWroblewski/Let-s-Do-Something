class AdminController < ApplicationController

  def index
    render :error
  end

  def scubasteve
    @words = Word.where(:wordable_type => "to_check").limit(30).order(:counter).reverse_order
    render :table
  end

  def edit
    @word = Word.find(params[:id])
    render :editing
  end

  def destroy
    Word.destroy(params[:id])
    flash[:notice] = "Successfully destroyed word"
    redirect_to admin_scubasteve_path
  end

  def edit_multiple
    @words = Word.find(params[:word_ids])
    render :editing
  end

  def update
    @word = Word.find(params[:id])
    if @word.update_attributes(params[:word])
      flash[:notice] = "Successfully updated word"
      redirect_to admin_scubasteve_path
    else
      render :update
    end
  end

  def update_multiple
    @words = Word.find(params[:word_ids])
    @words.each do |word|
      word.update_attributes!(params[:word].reject { |key, value| value.blank? })
    end
    flash[:notice] = "Updated products!"
    redirect_to admin_scubasteve_path
  end
end
