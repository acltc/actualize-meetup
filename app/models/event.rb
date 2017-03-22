class Event < ApplicationRecord
  has_many :contacts

  def to_csv
    attributes = %w{id first_name last_name email phone slides interested_in}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      contacts.each do |contact|
        csv << contact.attributes.values_at(*attributes)
      end
    end
  end

  def file_name
    created_at.strftime('%b-%d-%Y')
  end
end
