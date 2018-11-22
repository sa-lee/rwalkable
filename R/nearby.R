#' @export
#' @param location where to compute walkability
#' @param radius walkable distance in meters 
#' @param amenities character vector of amenities to include
#'  (or with minus sign exclude) from calculation. The default
#'  is to include all of them
#' @title 

nearby <- function(location, radius=1500, amenities=NULL){
  
  location <-whereis(location)
  delta_lat<-2*radius_to_latitude(radius)
  delta_long<-2*radius_to_longitude(radius, location$latitude)
  
  amenities <- get_amenities(location, delta_lat, delta_long, amenities)
  
  road_graph<- get_road_graph(bounding_box)
  
  road_distances <- get_shortest_paths(road_graph)
  
  connectivity <- get_cool_graph_metrics(road_graph)
  
  ## we don't know how to do this yet
  nearby_amenities <- amenities[is_nearby(amenities, road_distances, road_graph)]
  
  pop_density<- get_population_density(location) ## NA if not available
  
  rval<- list( location=location, bounding_box=bounding_box, sys.call(), amenities=nearby_amenities, 
               person_density=pop_density$persons, dwelling_density=pop_density$dwellings, 
               connectivity=connectivity)
  class(rval)<-"nearby"
  rval
}