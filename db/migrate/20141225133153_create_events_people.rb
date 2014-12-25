class CreateEventsPeople < ActiveRecord::Migration
  def change
    create_table :events_people, :id => false do |t|
      t.references :event, :person
    end

    add_index :events_people, [:event_id, :person_id],
      name: "events_people_index",
      unique: true
  end
end
