class Event < ActiveRecord::Base
  has_and_belongs_to_many :people
  has_many :costs
  validates :cost_total, :payer_id, :att_nr, presence: true
end
