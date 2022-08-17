output main_network_id {
  value =  google_compute_network.main_network.id
}

output main_network_name {
  value =  google_compute_network.main_network.name
}

#This is always default I don't change it here
output main_subnetwork_name {
  value =  "default"
}