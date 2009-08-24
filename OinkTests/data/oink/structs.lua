-- CGRect = oink.struct.pack("ffff")
-- CGSize = oink.struct.pack("ff")
-- CGPoint = oink.struct.pack("ff")
-- NSRange = oink.struct.pack("ii")
-- CLLocationCoordinate2D = oink.struct.pack("dd")
-- MKCoordinateRegion = oink.struct.pack("dddd")

-- Future? This is how I would like structs to work
-- oink.struct("CGSize", "dd", "width", "height")
-- oink.struct("CGPoint", "dd", "x", "y")
-- oink.struct("CGRect", "{CGPoint}{CGSize}", origin, size)


