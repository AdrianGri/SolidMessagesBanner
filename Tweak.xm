@interface ShadowView : UIView 
@property (nonatomic, copy, readwrite) UIColor *backgroundColor;
@end

%group A
%hook ShadowView
-(void)layoutSubviews {
	%orig;

	ShadowView *me = self;

	if ([me.superview.superview class] == objc_getClass("CKAvatarNavigationBar")) {
		UIView *subV = [me.subviews firstObject];
		
		if (subV.backgroundColor != nil) {
			UIColor *subColor = subV.backgroundColor;
			const CGFloat* components = CGColorGetComponents(subColor.CGColor);
			
			if (components[0] == 1) {
				//dark mode
				me.superview.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:1];
			} else {
				//light mode
				me.superview.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0.5 alpha:1];
			}
		}
	}
}
%end 
%end

%ctor {
	%init(A, ShadowView = objc_getClass("_UIBarBackgroundShadowView"))
}