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
      flash[:errors] = @request.errors.full_messages
      @cats = Cat.all
      render :new
    end
  end

  def approve
    @request = CatRentalRequest.find(params[:id])

    CatRentalRequest.transaction do
      @request.approve!
      overlapping_pending_requests.each do |req|
        req.deny!
      end
    end

    redirect_to cat_url(@request.cat_id)
  end

  def deny
    @request = CatRentalRequest.find(params[:id])
    @request.deny!

    redirect_to cat_url(@request.cat_id)
  end

  private

  def rental_params
    r_params = params.require(:cat_rental_request).permit(
        :cat_id, :start_date, :end_date)
    r_params.merge(user_id: current_user.id)
  end

end
