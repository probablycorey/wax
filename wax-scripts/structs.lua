oink.struct.create("CGSize", "ff", "width", "height")
oink.struct.create("CGPoint", "ff", "x", "y")
oink.struct.create("CGRect", "ffff", "x", "y", "width", "height")

oink.struct.create("NSRange", "II", "location", "length")

oink.struct.create("CLLocationCoordinate2D", "dd", "latitude", "longitude")
oink.struct.create("MKCoordinateSpan", "dd", "latitudeDelta", "longitudeDelta")
oink.struct.create("MKCoordinateRegion", "dddd", "latitude", "longitude", "latitudeDelta", "longitudeDelta")
