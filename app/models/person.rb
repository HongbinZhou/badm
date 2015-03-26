class Person < ActiveRecord::Base
  has_and_belongs_to_many :events
  has_many :costs

  # http://guides.rubyonrails.org/active_record_validations.html
  validates :name, :email, :money, presence: true
  validates :email, uniqueness: true

end
