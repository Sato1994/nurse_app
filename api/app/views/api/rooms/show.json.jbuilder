# json.user_messages do
#   json.array! @user_messages, :id, :message, :created_at
# end
# json.host_messages do
#   json.array! @host_messages, :id, :message, :created_at, 
# end



json.user_messages do
  json.array! @user_messages do |message|
    json.id message.id
    json.message message.message
    json.created_at message.created_at
    json.user "user"
  end
end


json.host_messages do
  json.array! @host_messages do |message|
    json.id message.id
    json.message message.message
    json.created_at message.created_at
    json.user "host"
  end
end