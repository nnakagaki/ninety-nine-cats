class CatRentalRequestsController < ApplicationController

  before_action :verify_user, only: [:approve, :deny]

  def new
    @cats = Cat.all
    render :new
  end

  def create
    @request = CatRentalRequest.new(rental_params)
    if @request.save
      redirect_to cat_url(@request.cat_id)
    else
      @cats = Cat.all
      render :new
    end
  end

  def approve
    @request = CatRentalRequest.find(params[:id])
    @request.approve!
    @cat = Cat.find(@request.cat_id)

    redirect_to cat_url(@cat)
  end

  def deny
    @request = CatRentalRequest.find(params[:id])
    @request.deny!
    @cat = Cat.find(@request.cat_id)

    redirect_to cat_url(@cat)
  end

  private
  def rental_params
    r_params = params[:cat_rental_request].permit(
        :cat_id, :start_date, :end_date)
    r_params[:user_id] = current_user.id

    r_params
  end

end
