#import "FetchButtonView.h"



@implementation FetchButtonView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImage *buttonImage = [UIImage imageNamed:FETCH_BUTTON_ICON];
        button = [[UIButton alloc] initWithFrame:frame];
        [button setImage:buttonImage forState:UIControlStateNormal];
		[button setImage:[UIImage imageNamed:FETCH_BUTTON_ICON2] forState:UIControlStateHighlighted];
        [self addSubview:button];

        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.frame = CGRectMake(150, buttonImage.size.height/2 - 10, 20, 20);
        spinner.center = self.center;
        spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:spinner];
    }

    return self;
}

- (void)dealloc {
    [spinner release];
    [button release];
    [super dealloc];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [button addTarget:target action:action forControlEvents:controlEvents];
}

- (void)startAnimating {
    button.hidden = YES;
    [spinner startAnimating];
}

- (void)stopAnimating {
    [spinner stopAnimating];
    button.hidden = NO;
}


- (void)hide {
    [spinner stopAnimating];
    button.hidden = YES;
}
@end
