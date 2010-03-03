// UITextInputTraits are inaccessable via the runtime (not sure why).
// This is a hack to access them via wax

#import <Foundation/Foundation.h>

@interface WaxTextField : UITextField {}

@end

@implementation WaxTextField
- (UITextAutocapitalizationType)autocapitalizationType {
    return [super autocapitalizationType];
}

- (void)setAutocapitalizationType:(UITextAutocapitalizationType)value {
    return [super setAutocapitalizationType:value];
}


- (void)autocorrectionType:(UITextAutocorrectionType)value {
    [super autocorrectionType];
}

- (void)setAutocorrectionType:(UITextAutocorrectionType)value {
    [super setAutocorrectionType:value];
}


- (UIKeyboardType)keyboardType {
    return [super keyboardType];
}

- (void)setKeyboardType:(UIKeyboardType)value {
    [super setKeyboardType:value];
}

- (UIKeyboardAppearance)keyboardAppearance {
    return [super keyboardAppearance];
}

- (void)setKeyboardAppearance:(UIKeyboardAppearance)value {
    [super setKeyboardAppearance:value];
}


- (UIReturnKeyType)returnKeyType {
    return [super returnKeyType];
}

- (void)setReturnKeyType:(UIReturnKeyType)value {
    [super setReturnKeyType:value];
}


- (BOOL)enablesReturnKeyAutomatically {
    return [super enablesReturnKeyAutomatically];
}

- (void)setEnablesReturnKeyAutomatically:(BOOL)value {
    [super setEnablesReturnKeyAutomatically:value];
}

- (BOOL)isSecureTextEntry {
    return [super isSecureTextEntry];
}

- (void)setSecureTextEntry:(BOOL)value {
    [super setSecureTextEntry:value];
}

@end