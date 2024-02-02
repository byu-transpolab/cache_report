make_gmns_nodes <- function(nodes_file){
  nodes <- nodes_file %>% 
    read_csv() %>% 
    rename(
      node_id = N,
      x_coord = X,
      y_coord = Y,
      zone_id = TAZID
    ) %>% 
    # select(node_id, zone_id, x_coord, y_coord) %>% 
    st_as_sf(
      coords = c("x_coord", "y_coord"),
      crs = st_crs(26912),
      remove = FALSE) %>% 
    mutate(wkt_geom = st_as_text(geometry)) %>% 
    st_drop_geometry()
  
  nodes
}

make_gmns_links <- function(links_file, nodes){
  links <- links_file %>% 
    read_csv() %>% 
    transmute(
      from_node_id = A,
      to_node_id = B,
      length = DISTANCE,
      name = STREET,
      link_id = LINKID,
      zone_id = TAZID
    )
  
  nodes_geom <- nodes %>% 
    select(node_id, x_coord, y_coord)
  
  links %>% 
    left_join(nodes_geom, join_by(from_node_id == node_id)) %>% 
    rename_with(\(x) paste0(x, "_from"), x_coord:y_coord) %>% 
    left_join(nodes_geom, join_by(to_node_id == node_id)) %>% 
    rename_with(\(x) paste0(x, "_to"), x_coord:y_coord)
}
