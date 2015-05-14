waxClass{"AutoTestUIKitFunction"}

function autoTestStart(self)

    local res = self:respondsToSelector("UIImageWriteToSavedPhotosAlbum:didFinishSavingWithError:contextInfo:")
    print("res=", res)


    UIGraphicsBeginImageContext(CGSize(200,400));
	--renderInContext呈现接受者及其子范围到指定的上下文
    UIApplication:sharedApplication():keyWindow():layer():renderInContext(UIGraphicsGetCurrentContext());
    --返回一个基于当前图形上下文的图片
	local aImage =UIGraphicsGetImageFromCurrentImageContext();
    --移除栈顶的基于当前位图的图形上下文
    UIGraphicsEndImageContext();
    --以png格式返回指定图片的数据
	local imageData =UIImagePNGRepresentation(aImage);
    print("imageData.length=", imageData.length);
    
    local image = aImage;
    -- local image = UIImage:imageNamed("mac_screen");
    local data = UIImageJPEGRepresentation(image, 0.8);
    -- data = toobjc(data)
    print("data.length=", data:length());
    
    data = UIImagePNGRepresentation(image);
    -- data = toobjc(data)
    print("data.length=", data:length());
    
    local info = toobjc({key="value"});
    UIImageWriteToSavedPhotosAlbum(image, self, "UIImageWriteToSavedPhotosAlbum:didFinishSavingWithError:contextInfo:", info);
    
    local point = CGPoint(10, 10);
    print("point=", point)
    local pointString = NSStringFromCGPoint(point);
    print("pointString=", pointString)
    point = CGPointFromString(pointString);
    print("point=", point)
    
    local rect = CGRect(10, 10, 100, 100);
    local rectString = NSStringFromCGRect(rect);
    print("rectString=", rectString)
    rect = CGRectFromString(rectString);
    print("rect=", rect)
end

function UIImageWriteToSavedPhotosAlbum_didFinishSavingWithError_contextInfo(self, image, error, contextInfo)

    print("error=", error, "contextInfo=", contextInfo);
    
end