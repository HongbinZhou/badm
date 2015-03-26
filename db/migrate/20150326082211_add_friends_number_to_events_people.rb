class AddFriendsNumberToEventsPeople < ActiveRecord::Migration
  def change
    add_column :events_people, :friends_number, :integer
  end
end
