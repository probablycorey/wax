waxClass{"ViewController"}



function setMyView(self)
	print(self:getIvarInteger("_aInteger"))
	print(self:getIvarCGFloat("_aCGFloat"))

	self:setIvar_withInteger("_aInteger", 567)
	self:setIvar_withCGFloat("_aCGFloat", 567.89)

	print(self:getIvarInteger("_aInteger"))
	print(self:getIvarCGFloat("_aCGFloat"))
    local view = UIView:init()
    self:view():addSubview(view)
    view:setBackgroundColor(UIColor:greenColor())
    view:masUNDERxLINEmakeConstraints(toblock(
      function ( make )
        make:center():equalTo()(self:view())
        make:width():offset()(50)
        make:height():offset()(50)
        -- make:centerOffset()(CGPoint(10, 20))
      end
      ,{"void", "MASConstraintMaker *"}))
end

function setMyView2(self)
    local view = UIView:init()
    self:view():addSubview(view)
    view:setBackgroundColor(UIColor:greenColor())
    view:masUNDERxLINEmakeConstraints(toblock(
      function ( make )
        make:top():equalTo()(self:view():masUNDERxLINEleft()):offset()(200);
        make:left():equalTo()(self:view()):offset()(50);
        -- luaCallBlock(luaCallBlock(make:top():equalTo(), self:view()):offset(),200);
        make:width():offset()(10);
        make:height():offset()(10);
      end
      ,{"void", "MASConstraintMaker *"}))
    print("lua setMyView2")
end
