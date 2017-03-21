class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.boolean :slides
      t.text :interested_in
      t.integer :event_id

      t.timestamps
    end
  end
end
