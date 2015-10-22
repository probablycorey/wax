if wax.isArm64 == true then
    wax.struct.create("CGSize", "dd", "width", "height")
	wax.struct.create("CGPoint", "dd", "x", "y")
	wax.struct.create("UIEdgeInsets", "dddd", "top", "left", "bottom", "right")
	wax.struct.create("CGRect", "dddd", "x", "y", "width", "height")

	wax.struct.create("NSRange", "QQ", "location", "length")
	wax.struct.create("_NSRange", "QQ", "location", "length")--typedef _NSRange to NSRange

	wax.struct.create("CLLocationCoordinate2D", "dd", "latitude", "longitude")
	wax.struct.create("MKCoordinateSpan", "dd", "latitudeDelta", "longitudeDelta")
	wax.struct.create("MKCoordinateRegion", "dddd", "latitude", "longitude", "latitudeDelta", "longitudeDelta")
	wax.struct.create("CGAffineTransform", "dddddd", "a", "b", "c", "d", "tx", "ty")
	wax.struct.create("UIOffset", "dd", "horizontal", "vertical")
else
	wax.struct.create("CGSize", "ff", "width", "height")
	wax.struct.create("CGPoint", "ff", "x", "y")
	wax.struct.create("UIEdgeInsets", "ffff", "top", "left", "bottom", "right")
	wax.struct.create("CGRect", "ffff", "x", "y", "width", "height")

	wax.struct.create("NSRange", "II", "location", "length")
	wax.struct.create("_NSRange", "II", "location", "length")--typedef _NSRange to NSRange

	wax.struct.create("CLLocationCoordinate2D", "dd", "latitude", "longitude")
	wax.struct.create("MKCoordinateSpan", "dd", "latitudeDelta", "longitudeDelta")
	wax.struct.create("MKCoordinateRegion", "dddd", "latitude", "longitude", "latitudeDelta", "longitudeDelta")
	wax.struct.create("CGAffineTransform", "ffffff", "a", "b", "c", "d", "tx", "ty")
	wax.struct.create("UIOffset", "ff", "horizontal", "vertical")
end
