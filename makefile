install:
	mkdir -p /usr/local/bin
	mkdir -p /usr/local/lib/wax

	cp wax /usr/local/bin 
	cp -R * /usr/local/lib/wax/
	@echo
	@echo
	@echo "---------------------------------------"
	@echo "Wax was installed to /usr/local/bin/wax"
	@echo
