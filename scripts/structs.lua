CGRect = oink.struct.pack("dddd")
CGSize = oink.struct.pack("dd")
CGPoint = oink.struct.pack("dd")
CLLocationCoordinate2D = oink.struct.pack("dd")
MKCoordinateRegion = oink.struct.pack("dddd")

-- Future? This is how I would like structs to work
-- oink.struct("CGSize", "dd", "width", "height")
-- oink.struct("CGPoint", "dd", "x", "y")
-- oink.struct("CGRect", "{CGPoint}{CGSize}", origin, size)


