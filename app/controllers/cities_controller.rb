require 'json'

class CitiesController < ApplicationController
  before_action :set_city, only: [:show, :edit, :update, :destroy]
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  def getSubscriptionListFor
    @cities = City.includes(:devices).find(params[:id])

    # puts ">>>>>>>>> CitiesController: getSubscriptionListFor: " + @cities

    render :json => @cities
  end

  def getcitieslist
    @cities = City.all

    @cities = File.read('/Users/george.liu/Desktop/CityList.json')
 
    puts ">>>>>>>>> CitiesController: getcitieslist: " + @cities

    render :json => @cities
    
  end
  # GET /cities
  # GET /cities.json
  def index
    @cities = City.all

  end

  # GET /cities/1
  # GET /cities/1.json
  def show
  end

  # GET /cities/new
  def new
    @city = City.new
    @device = Device.all
  end

  # GET /cities/1/edit
  def edit
    @device = Device.all
  end

  # POST /cities
  # POST /cities.json
  def create
    @city = City.new(city_params)

    respond_to do |format|
      if @city.save
        format.html { redirect_to @city, notice: 'City was successfully created.' }
        format.json { render :show, status: :created, location: @city }
      else
        format.html { render :new }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cities/1
  # PATCH/PUT /cities/1.json
  def update
    respond_to do |format|
      if @city.update(city_params)
        format.html { redirect_to @city, notice: 'City was successfully updated.' }
        format.json { render :show, status: :ok, location: @city }
      else
        format.html { render :edit }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cities/1
  # DELETE /cities/1.json
  def destroy
    @city.destroy
    respond_to do |format|
      format.html { redirect_to cities_url, notice: 'City was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_city
      @city = City.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def city_params
      # params.require(:city).permit(:name)

      # v.00 - original
      # params.require(:city).permit(:name, :device_ids => [])

      # v.01 - see xcode
      # params.require(:city)


      params.require(:city).permit(:device_token, cities:[])

    end
end
