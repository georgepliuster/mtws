class CityStatusesController < ApplicationController
  before_action :set_city_status, only: [:show, :edit, :update, :destroy]


 def getCityStatusesFor


    @cds = City.joins(:devices).where(:devices => { token: params[:token] } ).all

        counter = 0
        @cds.each do |e|
          counter = counter + 1
        end
        puts ">>>>>> DEVICES_CONTROLLER: @cds.COUNT: " + counter.to_s   
        
            
        @jsonResponse = "[]"
        if (counter > 0) 
          @jsonResponse = "["
          @cds.each do |element|
            puts ">>>>>> DEVICES_CONTROLLER: getCityStatusesFor: NAME: " + element["name"]
            puts ">>>>>> DEVICES_CONTROLLER: getCityStatusesFor: ID: " + element["id"].to_s

            @city_status = CityStatus.find_by(:id => element["id"])
            puts ">>>>>> DEVICES_CONTROLLER: getCityStatusesFor: STATUS: " + @city_status["status"]

            @jsonResponse = @jsonResponse + "{ \"name\" : \"" + element["name"] + "\", \"status\" : \"" + @city_status["status"] + "\"}, "
          end
          @jsonResponse = @jsonResponse[0..-3] + "]"
        end


# [{ "name" : "New York NY", "status" : "open"}, { "name" : "Seattle WA", "status" : "closed"}]



# goood
#        @jsonResponse = '[{"update":{"region":"Region 1","state":"CT","city":"Bridgeport","status":"Shelter-In-Place","notes":"The purpose of this status update is to provide a sample of the Status Update in JSON for the DOL API developers ."}},{"update":{"region":"Region 1","state":"ME","city":"Augusta","status":"Delayed-Two-Hours","notes":"The purpose of this status update is to DELAYED TWO HOURS."}},{"update":{"region":"Region 1","state":"MA","city":"Andover","status":"Open","notes":"The purpose of this status update is OPEN."}},{"update":{"region":"Region 1","state":"VT","city":"Burlington","status":"Closed","notes":"The purpose of this status update is CLOSED."}}]'

# NO good 
#        @jsonResponse = '[{"updates":[{"update":{"region":{"region":"National Office","state":"DC","city":"Washington"},"status":"Federal offices are open - delayed arrival - employees must report to their office no later than XX:XX - with option for unscheduled leave or unscheduled telework (refer to additional notes for arrival time)","notes":"All NCR offices are open with a 2 hour delayed arrival. Employees must report to their office no later than 11:00am Eastern."}}]}]'



# @jsonResponse '[{"update": {"region": "National Office","state": "MD","city": "Baltimore","status": "Federal offices are open - delayed arrival - employees must report to their office no later than XX:XX - with option for unscheduled leave or unscheduled telework refer to additional notes for arrival time)","notes": "All NCR offices are open with a 2 hour delayed arrival. Employees must report to their office no later than 11:00am Eastern."}},{"update": {"region": "National Office","state": "TX","city": "Dallas","status": "Them 'catboys' are going to play today","notes": "All them boys are going to stand for the anthem"}},{"update": {"region": "National Office","state": "VA","city": "Alexandria","status": "This Federal Office will be closing for renovations","notes": "There is a major hurricane about to decend on to the Alexandria VA area."}}]'

@jsonResponse '[{"region": "Region 6","state": "TX","city": "Abilene","status": "Federal Offices are closed - Emergency and telework ready employees must follow their agency\u0027s policies","notes": "This is a test\r\n"},{"region": "Region 9","state": "CA","city": "San Francisco","status": "Federal Offices are OPEN","notes": "This is a THE SECOND CITY"}]'




        puts ">>>>>> DEVICES_CONTROLLER: getCityStatusesFor: jsonResponse: "+@jsonResponse

    render :json => @jsonResponse   #@cds  # @citylist
  end



  # GET /city_statuses
  # GET /city_statuses.json
  def index
    @city_statuses = CityStatus.all
  end

  # GET /city_statuses/1
  # GET /city_statuses/1.json
  def show
  end

  # GET /city_statuses/new
  def new
    @city_status = CityStatus.new
  end

  # GET /city_statuses/1/edit
  def edit
  end

  # POST /city_statuses
  # POST /city_statuses.json
  def create
    @city_status = CityStatus.new(city_status_params)

    respond_to do |format|
      if @city_status.save
        format.html { redirect_to @city_status, notice: 'City status was successfully created.' }
        format.json { render :show, status: :created, location: @city_status }
      else
        format.html { render :new }
        format.json { render json: @city_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /city_statuses/1
  # PATCH/PUT /city_statuses/1.json
  def update
    respond_to do |format|
      if @city_status.update(city_status_params)
        format.html { redirect_to @city_status, notice: 'City status was successfully updated.' }
        format.json { render :show, status: :ok, location: @city_status }
      else
        format.html { render :edit }
        format.json { render json: @city_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /city_statuses/1
  # DELETE /city_statuses/1.json
  def destroy
    @city_status.destroy
    respond_to do |format|
      format.html { redirect_to city_statuses_url, notice: 'City status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_city_status
      @city_status = CityStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def city_status_params
      params.require(:city_status).permit(:city_id, :status)
    end
end
