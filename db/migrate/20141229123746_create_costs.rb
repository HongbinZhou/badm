class CreateCosts < ActiveRecord::Migration
  def change
    create_table :costs do |t|
      t.float :money

      t.timestamps
    end
  end
end
