// UITextInputTraits are inaccessable via the runtime (not sure why).
// This is a hack to access them via wax

#import <Foundation/Foundation.h>

@interface WaxTextField : UITextField {}

- (UIKeyboardType)keyboardType;
- (void)setKeyboardType:(UIKeyboardType)type;

- (UIReturnKeyType)returnKeyType;
- (void)setReturnKeyType:(UIReturnKeyType)type;

@end

@implementation WaxTextField
- (UIKeyboardType)keyboardType {
  return [super keyboardType];
}
  
- (void)setKeyboardType:(UIKeyboardType)type {
  [super setKeyboardType:type];
}

- (UIReturnKeyType)returnKeyType {
  return [super returnKeyType];
}

- (void)setReturnKeyType:(UIReturnKeyType)type {
  [super setReturnKeyType:type];
}

@end