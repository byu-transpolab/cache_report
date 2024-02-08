make_gmns_nodes <- function(nodes_geo_file){
  nodes <- nodes_geo_file %>% 
    st_read() %>% 
    rename(
      node_id = N,
      x_coord = X,
      y_coord = Y,
      zone_id = TAZID
    ) %>% 
    # select(node_id, zone_id, x_coord, y_coord) %>% 
    # st_as_sf(
    #   coords = c("x_coord", "y_coord"),
    #   crs = st_crs(26912),
    #   remove = FALSE) %>% 
    mutate(wkt_geom = st_as_text(geometry)) %>% 
    st_drop_geometry() %>% 
    as_tibble()
  
  nodes
}

make_gmns_links <- function(links_geo_file){
  links <- links_geo_file %>% 
    st_read() %>% 
    mutate(
      from_node_id = A,
      to_node_id = B,
      length = DISTANCE,
      name = STREET,
      link_id = paste(from_node_id, to_node_id, sep = "_"),
      zone_id = TAZID,
      .keep = "unused"
    ) %>% 
    relocate(from_node_id:zone_id) %>% 
    mutate(wkt_geom = st_as_text(geometry)) %>% 
    st_drop_geometry() %>% 
    as_tibble()
  
  # nodes_geom <- nodes %>% 
  #   select(node_id, x_coord, y_coord)
  # 
  # links_geom %>% 
  #   left_join(nodes_geom, join_by(from_node_id == node_id)) %>% 
  #   rename_with(\(x) paste0(x, "_from"), x_coord:y_coord) %>% 
  #   left_join(nodes_geom, join_by(to_node_id == node_id)) %>% 
  #   rename_with(\(x) paste0(x, "_to"), x_coord:y_coord) %>% 
  #   select(link_id, x_coord_from:y_coord_to) %>% 
  #   rename_with(\(x) str_remove(x, "_coord")) %>% 
  #   pivot_longer(
  #     -link_id,
  #     names_to = c("xy", "end"),
  #     values_to = "coord",
  #     names_sep = "_") %>%
  #   pivot_wider(names_from = "xy", values_from = "coord") %>% 
  #   mutate(end = factor(end, c("from", "to"))) %>% 
  #   arrange(link_id, end) %>% 
  #   sf_linestring("x", "y", linestring_id = "link_id")
}

# convert_shp_to_geojson <- function(shp_file, geojson_file) {
#   shp_file %>% 
#     st_read() %>% 
#     st_write(geojson_file)
# }

# add_crs <- function(sf_file, crs = st_crs(26912)) {
#   st_read(sf_file) %>% 
#     st_set_crs(crs) %>% 
#     st_write(paste0(sf_file, "_crs.geojson"))
# }
