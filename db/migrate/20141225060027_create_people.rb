class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :email
      t.string :name
      t.float :money

      t.timestamps
    end
  end
end
