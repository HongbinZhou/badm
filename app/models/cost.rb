class Cost < ActiveRecord::Base
  belongs_to :event
  belongs_to :person

  validates :money, :person_id, :event_id, :att_nr, presence: true
end
