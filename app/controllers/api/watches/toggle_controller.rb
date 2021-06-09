# frozen_string_literal: true

class API::Watches::ToggleController < API::BaseController
  def index
    @watches = Watch.where(
      user: current_user,
      watchable: watchable
    )
  end

  def create
    @watch = Watch.new(
      user: current_user,
      watchable: params[:watchable_type].constantize.find_by(id: params[:watchable_id])
    )

    @watch.save!
    render json: @watch
  end

  def destroy
    @watch = Watch.find(params[:id])
    @watch.destroy
    head :no_content
  end

  private

  def watchable
    params[:watchable_type].constantize.find_by(id: params[:watchable_id])
  end
end