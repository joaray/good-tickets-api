class EventSerializer < ActiveModel::Serializer
  attributes %i[id name category place start_time]
end
