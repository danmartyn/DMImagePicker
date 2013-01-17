// From cscade on iphonedevbook.com forums
// And Bjorn Sallarp on blog.sallarp.com

@interface UIImage (Extras)

+ (UIImage *)imageFromView:(UIView *)view;
+ (UIImage *)imageFromView:(UIView *)view scaledToSize:(CGSize)newSize;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end
