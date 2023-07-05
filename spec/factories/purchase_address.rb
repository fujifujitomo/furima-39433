FactoryBot.define do
  factory :purchase_address do
    postal_code { '123-4567' }
    prefecture { 1 }
    city { '横浜市' }
    addresses { '1-2-3' }
    phone_number { '09012345678' }

  end
end
