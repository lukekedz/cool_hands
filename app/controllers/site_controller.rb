class SiteController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def index
    @months = Month.all.reverse
    @days   = Day.where(month_id: 1).order(:id)
  end

  def practiced
    Day.update(params[:block_id], practiced: params[:practiced])

    data = {:message => "POST practiced"}
    render :json => data, :status => :ok
  end

end
