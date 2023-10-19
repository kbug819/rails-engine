class Item < ApplicationRecord
  belongs_to :merchant
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true

  def self.find_one_item(query)
    Item.where('lower(name) LIKE lower(?)', "%#{query}%").order(:name).limit(1)
  end

  def self.name_present(params)
    Item.where('lower(name) LIKE lower(?)', "%#{params["name"]}%").order(:name)
  end

  def self.min_and_max_present(params)
    Item.where('unit_price >= ? AND unit_price <= ?', "#{params["min_price"]}", "#{params["max_price"]}" ).order(unit_price: :desc)
  end

  def self.min_present(params)
    if params["min_price"].to_i < 0
      items = "error"
    else
      Item.where('unit_price >= ?', "#{params["min_price"]}").order(unit_price: :desc)
    end
  end

  def self.max_present(params)
    if params["max_price"].to_i < 0
      items = "error"
    else
      items = Item.where('unit_price <= ?', "#{params["max_price"]}").order(unit_price: :desc)
    end
  end

  def self.find_all_items(params)
    if params["name"] && params["min_price"].present?
      "error"
    elsif params["name"] && params["max_price"].present?
      items = "error"
    elsif params["name"].present?
      self.name_present(params)
    elsif params["min_price"] && params["max_price"].present?
      self.min_and_max_present(params)
    elsif params["min_price"].present?
      self.min_present(params)
    elsif params["max_price"].present?
      self.max_present(params)
    else
      []
    end
  end

end

