default:
	tar zxvf yajl-1.0.9.tar.gz -- yajl-1.0.9/src/*.{c,h}
	rm -rf yajl
	mv yajl-1.0.9/src yajl
	sed -i '' -e 's,include <yajl/yajl_common.h>,include "yajl_common.h",g' yajl/api/yajl_{parse,gen}.h
	ln -sf api/yajl_parse.h  yajl/
	ln -sf api/yajl_gen.h    yajl/
	ln -sf api/yajl_common.h yajl/
	rm -rf yajl-1.0.9
