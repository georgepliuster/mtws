require 'houston'

class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy]
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }


  def getSubscriptionListFor
    # called wioth: http://localhost:3000/SubscriptionList/?token=georgesPhone
    @cities = City.joins(:devices).where(:devices => { token: params[:token] } ).all

    # commented out for testing
    # render :json => @cities  # @citylist

     @cities = '[{ "device": [{"city": "Alexandria","stateCode": "VA","city_id": "7767"},{"city": "Abilene","stateCode": "TX","city_id": "8126"}] }]'



     puts @cities

     render :json => @cities

  end


  def pushNotificationTo (token, city_name)
    puts ">>> DEVICE_CONTROLLER: pushNotificationTo: token: " + token

    @APN = Houston::Client.development
    @APN.certificate = File.read('/Users/george.liu/Desktop/pushCert.pem')

    # An example of the token sent back when a device registers for notifications
    #token = '<a3065d51e9272ac86e99e1ba995f0e54504c1e5bbfeaa83a1c36e97085908a00>'

    # Create a notification that alerts a message to the user, plays a sound, and sets the badge on the app
    notification = Houston::Notification.new(device: token)
    notification.alert = 'DOL ' + city_name.to_s + ' is CLOSED'

    # Notifications can also change the badge count, have a custom sound, have a category identifier, indicate available Newsstand content, or pass along arbitrary data.
    notification.badge = 1
    notification.sound = 'sosumi.aiff'
    notification.category = 'INVITE_CATEGORY'
    notification.content_available = true
    notification.mutable_content = true
    notification.custom_data = { foo: 'bar' }

    # And... sent! That's all it takes.
    @APN.push(notification)


  end


=begin
  #################################################
  # sends notification for ONE city - JUST TEST CODE
  def sendNotification
    # called from the sntd web page.
    # will have params (list of cities) to generate tokens to send notifications to


    puts ">>> DEVICE_CONTROLLER: sendNotification: BEGIN"

    @device = Device.joins(:cities).where(:cities => { name: "Seattle WA"}).all
    token = @device[0]["token"]
    puts ">>> DEVICE_CONTROLLER: sendNotification: token: "+ token

    pushNotificationTo token

    render :json => @device #"hello ernesto trump 5"
  end
  #################################################
=end


  def sendNotification
    # called from the sntd web page.
    # will have params (list of cities) to generate tokens to send notifications to


    puts ">>> DEVICE_CONTROLLER: sendNotification: BEGIN"

    # 1. grab params

=begin
    @device = Device.joins(:cities).where(:cities => { name: "Seattle WA"}).all
    token = @device[0]["token"]
    puts ">>> DEVICE_CONTROLLER: sendNotification: token: "+ token
=end

    array = params[:device][:city_ids]

    puts ">>> DEVICE_CONTROLLER: sendNotification: ARRAY: " + array.to_s
    puts ">>> DEVICE_CONTROLLER: sendNotification: ARRAY.COUNT: " + array.count.to_s
    array.each do |element, index|
      if (element != "")
        puts ">>> DEVICE_CONTROLLER: sendNotification: ELEMENT: " + element
        @city = City.find_by(id: element)
        city_name = @city["name"]
        puts ">>> DEVICE_CONTROLLER: sendNotification: CITY NAME: " + city_name.to_s


        @device = Device.joins(:cities).where(:cities => { name: city_name}).all

        puts ">>> DEVICE_CONTROLLER: sendNotification: @DEVICE: " + @device.count.to_s

        if (@device.count != 0) 

          @device.each do |myDevice|
            puts ">>> DEVICE_CONTROLLER: MYDEVICE: TOKEN: " + myDevice["token"]
            pushNotificationTo myDevice["token"], city_name
          end

         #  token = @device[0]["token"]
         #  puts ">>> DEVICE_CONTROLLER: sendNotification: token: " + token

         # pushNotificationTo token, city_name
        end

      end
    end




  end

  def sntd           #sendNotificationToDevices
    # for now just a place holder to display the sntd web page
    @device = Device.new
    @city = City.all
  end


  # GET /devices
  # GET /devices.json
  def index
    puts ">>> DEVICE_CONTROLLER: index "
    @devices = Device.all
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
     puts ">>> DEVICE_CONTROLLER: show "

      end

  # GET /devices/new
  def new
    puts ">>> DEVICE_CONTROLLER: Newsstand "

        @device = Device.new
    @city = City.all
  end

  # GET /devices/1/edit
  def edit
    puts ">>> DEVICE_CONTROLLER: edit "
    @city = City.all
  end


  # POST /cities
  # POST /cities.json
  def createSubscriptionList

    puts ">>> DEVICE_CONTROLLER: createSubscriptionList: device_params: " + device_params[:token]

    @device = Device.find_by token: device_params[:token]

    if @device == nil     
      puts 'Device ' + device_params[:token] + ' NOT FOUND.  Nothing to destroy.  Continuing.'
    else
      if @device.destroy
        puts 'Device was successfully destroyed.'
      else
        puts 'Device DESTROY ERROR: ' + @device.errors
      end
    end
    
      @device = Device.new(device_params)

      if @device.save
        puts 'Device was successfully created.'
      else
        puts 'Device CREATE ERROR: ' + @device.errors
      end

  end


  # POST /devices
  # POST /devices.json
  def create
    puts ">>> DEVICE_CONTROLLER: create "

    puts ">>> DEVICE_CONTROLLER: create: params: [token] " + device_params["token"]

    if (params["token"] == nil)     # this means we are doing a sendNotification  - yes a hack
      puts ">>> DEVICE_CONTROLLER: create: params: [token]: IS NIL - calling sendNotification "
      sendNotification
    else
      puts ">>> DEVICE_CONTROLLER: create: params: [token]: IS NOT NIL:  CREATING "

      @device = Device.new(device_params)

      respond_to do |format|
        if @device.save
          format.html { redirect_to @device, notice: 'Device was successfully created.' }
          format.json { render :show, status: :created, location: @device }
        else
          format.html { render :new }
          format.json { render json: @device.errors, status: :unprocessable_entity }
        end
      end      
    end


=begin
   
    @device = Device.new(device_params)

    respond_to do |format|
      if @device.save
        format.html { redirect_to @device, notice: 'Device was successfully created.' }
        format.json { render :show, status: :created, location: @device }
      else
        format.html { render :new }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end

=end

  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
      puts ">>> DEVICE_CONTROLLER: update "

      respond_to do |format|
      if @device.update(device_params)
        format.html { redirect_to @device, notice: 'Device was successfully updated.' }
        format.json { render :show, status: :ok, location: @device }
      else
        format.html { render :edit }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy

    puts ">>> DEVICE_CONTROLLER: destroy "


    @device.destroy
    respond_to do |format|
      format.html { redirect_to devices_url, notice: 'Device was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      # params.require(:device).permit(:token)
      # params.require(:device).permit(:token, :name, :city_ids => [])

      params.require(:device).permit(:token, :city_ids => [])
    end
end
