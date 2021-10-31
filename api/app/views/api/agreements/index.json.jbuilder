json.array! @agreements do |agreement|
  json.id agreement.id
  json.user_id agreement.user.id
  json.user_myid agreement.user.myid
  json.host_id agreement.host.id
  json.host_myid agreement.host.myid
  json.start_time agreement.start_time
  json.finish_time agreement.finish_time
  json.state agreement.state
end