class CreateCityStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :city_statuses do |t|
      t.belongs_to :city, index: true
      t.integer :city_id
      t.string :status

      t.timestamps
    end
  end
end
