
#import <UIKit/UIKit.h>

@interface FetchButtonView : UIView {
    UIButton *button;
    UIActivityIndicatorView *spinner;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)startAnimating;
- (void)stopAnimating;
- (void)hide;
@end
