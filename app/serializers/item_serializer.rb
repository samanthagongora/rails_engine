class ItemSerializer < ActiveModel::Serializer
  attributes :description, :id, :merhcant_id, :name, :unit_price
end
