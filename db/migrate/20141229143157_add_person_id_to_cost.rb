class AddPersonIdToCost < ActiveRecord::Migration
  def change
    add_column :costs, :person_id, :integer
  end
end
