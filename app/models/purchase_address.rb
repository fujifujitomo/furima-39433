class PurchaseAddress
  include ActiveModel::Model
  attr_accessor :postal_code, :prefecture, :city, :addresses, :building, :phone_number, :purchase_id, :item_id, :user_id
  attr_accessor :token

  with_options presence: true do
    validates :postal_code, format: { with: /\A[0-9]{3}-[0-9]{4}\z/, message: 'is invalid. Include hyphen(-)' }
    validates :city
    validates :addresses
    validates :phone_number, format: { with: /\A[0-9]+\z/, message: 'is not a number' }, length: { in: 10..11 }
    validates :user_id
    validates :item_id
    validates :token
  end
  validates :prefecture, numericality: { other_than: 0, message: "can't be blank" }

  def save
    purchase = Purchase.create(item_id: item_id, user_id: user_id)
    Address.create(postal_code: postal_code, prefecture: prefecture, city: city, addresses: addresses,
                   building: building, phone_number: phone_number, purchase_id: purchase.id)
  end
end