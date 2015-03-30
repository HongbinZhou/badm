class Event < ActiveRecord::Base
  has_and_belongs_to_many :people
  has_many :costs
  validates :cost_total, :payer_id, presence: true
  validates :att_nr, numericality: { greater_than: 0 }
end
