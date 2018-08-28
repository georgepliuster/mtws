class CitiesDevices < ActiveRecord::Migration[5.1]
	def change
	  create_table :cities_devices, :id => false do |t|
	    t.integer :city_id
	    t.integer :device_id
	  end
	end
end
