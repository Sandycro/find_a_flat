class BookingsController < ApplicationController
  before_action :find_flat, only: [:create, :new]
  def new
    @booking= Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.flat = @flat
    if @booking.end_date > @booking.start_date
      @booking.cost =  @flat.price * (@booking.end_date - @booking.start_date).to_i
      @booking.user_id = current_user.id
      if @booking.save 
        redirect_to flat_path(@flat)
      else 
        flash[:notice] = "Already booked"
      end
    else
      flash[:alert] = "The end date of your booking should be after the start date!"
      render :new
    end
  end

  def index 
    @bookings = current_user.bookings
  end 

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
    redirect_to flat_path(@booking.flat)
  end

  private

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :cost)
  end

  def find_flat
    @flat = Flat.find(params[:flat_id])
  end
end
