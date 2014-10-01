class CatsController < ApplicationController
  before_action :verify_user, only: [:edit, :update]

  def index
    @cats = Cat.all

    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def edit
    render :edit
  end

  def update
    if @cat.update(cat_params)
      redirect_to cat_url(@cat)
    else
      render :edit
    end
  end

  def create
    @cat = Cat.new(cat_params)
    if @cat.save
      redirect_to cat_url(@cat)
    else
      p 'you messed up'
      render :new
    end
  end

  def new
    @cat = Cat.new
  end

  private
  def cat_params
    c_params = params[:cat].permit(
        :name, :sex, :color, :birth_date, :description)
    c_params[:user_id] = current_user.id
    c_params
  end


end
