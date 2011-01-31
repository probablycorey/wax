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
  
  -- You need to ensure you add the MapKit framework for this to work
  -- (in Xcode, right-click "Frameworks" -> "Add" -> "Existing Frameworks".
  -- Then select "MapKit.framework" & hit OK).
  -- If you get an error like "Could not find protocol named 'MKAnnotation'",
  -- you've forgotten that step.
  self.map_view = MKMapView:initWithFrame(self:view():bounds())
  local region = MKCoordinateRegion(self.location.lat, self.location.long, 0.02, 0.02)
  local san_fran = SimpleAnnotation:initWithLatLong(self.location.lat, self.location.long)
  san_fran:setTitle('Downtown')
  
  self.map_view:setScrollEnabled(true)
  self.map_view:setRegion_animated(region, 1)
  self.map_view:addAnnotation(san_fran)
  
  self:view():insertSubview_atIndex(self.map_view, 0)
end
