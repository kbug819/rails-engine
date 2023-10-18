class Merchant < ApplicationRecord

  has_many :items

  def self.find_one_merchant(query)
    Merchant.where('lower(name) LIKE lower(?)', "%#{query}%").order(:name).limit(1)
  end

  def self.find_all_merchants(query)
    Merchant.where('lower(name) LIKE lower(?)', "%#{query}%").order(:name)
  end
end
