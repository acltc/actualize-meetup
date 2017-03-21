class Contact < ApplicationRecord
  belongs_to :event

  validates :first_name, :last_name, :email, :phone, presence: true
  validates :email, uniqueness: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.last_week
    where(:created_at => 1.week.ago.beginning_of_week..1.week.ago.end_of_week)
  end
end
