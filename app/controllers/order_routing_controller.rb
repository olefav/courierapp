require 'coordinates'
require 'route_finder'

class OrderRoutingController < ApplicationController
  def index
  end

  def route_orders
    @orders = Order.where("delivered_date >= ?", DateTime.current)
    
    @orders = @orders.where("issued_date >= ?", DateTime.current.to_date.yesterday)
    logger.debug(@orders.inspect)
    
    @senders_coords = []
    @receivers_coords = []
    
    @orders.each do |order|
      sender_address = order.sender.address
      sender_coords = Coordinates.new(sender_address.latitude, sender_address.longitude)
      @senders_coords.push(sender_coords)
      
      receiver_address = order.receiver.address
      receiver_coords = Coordinates.new(receiver_address.latitude, receiver_address.longitude)
      @receivers_coords.push(receiver_coords)
    end
    
    @op = Coordinates.new(47.989936, 37.765762)
    
    router = RouteFinder.new(@senders_coords, @receivers_coords, @op)
    
    route = router.find_best_route
    
    route_array = []
    route_array.push(@op.to_a)
    
    route.each do |r|
      coord_array = []
      coord_array.push(r.latitude)
      coord_array.push(r.longitude)
      route_array.push(coord_array)
    end
    
    route_array.push(@op.to_a)
     
    render :json => route_array.to_json
  end
end
