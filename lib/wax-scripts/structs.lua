wax.struct.create("CGSize", "ff", "width", "height")
wax.struct.create("CGPoint", "ff", "x", "y")
wax.struct.create("UIEdgeInsets", "ffff", "top", "left", "bottom", "right")
wax.struct.create("CGRect", "ffff", "x", "y", "width", "height")

wax.struct.create("NSRange", "II", "location", "length")

wax.struct.create("CLLocationCoordinate2D", "dd", "latitude", "longitude")
wax.struct.create("MKCoordinateSpan", "dd", "latitudeDelta", "longitudeDelta")
wax.struct.create("MKCoordinateRegion", "dddd", "latitude", "longitude", "latitudeDelta", "longitudeDelta")
wax.struct.create("CGAffineTransform", "ffffff", "a", "b", "c", "d", "tx", "ty")