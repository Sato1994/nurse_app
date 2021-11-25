json.id @room.id
json.start_time @start_time
json.finish_time @finish_time
json.consensus @consensus

json.partner do
  json.id @partner.id
  json.name @partner.name
end

json.user_messages do
  json.array! @user_messages do |message|
    json.id message.id
    json.message message.message
    json.created_at message.created_at
    json.name message.user.name
  end
end

json.host_messages do
  json.array! @host_messages do |message|
    json.id message.id
    json.message message.message
    json.created_at message.created_at
    json.name message.host.name
  end
end