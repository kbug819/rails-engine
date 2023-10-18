class Item < ApplicationRecord

  belongs_to :merchant

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true

  def self.find_one_item(query)
    Item.where('lower(name) LIKE lower(?)', "%#{query}%").order(:name).limit(1)
  end

  def self.find_all_items(params)
    if params["name"] && params["min_price"].present?
      items = []
    elsif params["name"].present?
      Item.where('lower(name) LIKE lower(?)', "%#{params["name"]}%").order(:name)
    elsif params["min_price"].present?
      Item.where('unit_price >= ?', "#{params["min_price"]}").order(unit_price: :desc)
    elsif params["max_price"].present?
      Item.where('unit_price <= ?', "#{params["max_price"]}").order(unit_price: :desc)
    else
      return []
    end
  end
end

# Item.where('lower(name) LIKE lower(?)', "%kaylee%").order(:name)