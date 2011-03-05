require "SimpleAnnotation"

waxClass{"SimpleMapController", UIViewController, protocols={"MKMapViewDelegate"}}

function init(self)
  self.super:init()
  -- San Francisco, CA
  self.location = {
    lat=37.7749295,
    long=-122.4194155,
  }
end

function viewDidLoad(self)
  self.super:viewDidLoad()
  
  self.mapView = MKMapView:initWithFrame(self:view():bounds())
  local region = MKCoordinateRegion(self.location.lat, self.location.long, 0.02, 0.02)
  local annotation = SimpleAnnotation:initWithLatLong(self.location.lat, self.location.long)
  annotation:setTitle('Downtown')
  
  self.mapView:setScrollEnabled(true)
  self.mapView:setRegion_animated(region, 1)
  self.mapView:addAnnotation(annotation)
  
  self:view():insertSubview_atIndex(self.mapView, 0)
end
