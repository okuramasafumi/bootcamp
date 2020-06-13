# frozen_string_literal: true

class API::ReservationsController < API::BaseController
  before_action :set_reservation, only: %i(destroy)

  def index
    @reservations = Reservation.where(
      date: params[:beggining_of_this_month]..params[:end_of_this_month]
    ).includes(:user)
  end

  def create
    if reservation_params[:seat_id].class == Array && reservation_params[:date].class == String
      reservation_params[:seat_id].each_with_index do |seat_id, index|
        @reservation = Reservation.new(seat_id: seat_id, date: reservation_params[:date])
        @reservation.user = current_user
        @reservation.save
      end
    elsif reservation_params[:seat_id].class == Integer && reservation_params[:date].class == Array
      reservation_params[:date].each_with_index do |date, index|
        @reservation = Reservation.new(seat_id: reservation_params[:seat_id], date: date)
        @reservation.user = current_user
        @reservation.save
      end
    else
      @reservation = Reservation.new(reservation_params)
      @reservation.user = current_user
      if @reservation.save
        render :create, status: :created
      else
        render status: :bad_request, json: { message: @reservation.errors.full_messages }
      end
    end
  end

  def destroy
    @reservation.destroy
  end

  private
    def reservation_params
      params.require(:reservation).permit(
        :date,
        :seat_id,
        { seat_id: [] },
        { date: [] },
      )
    end

    def set_reservation
      @reservation = current_user.reservations.find(params[:id])
    end
end
