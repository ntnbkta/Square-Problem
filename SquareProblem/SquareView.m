//
//  SquareView.m
//  SquareProblem
//
//  Created by Vasu N on 12/24/15.
//  Copyright © 2015 Airwatch. All rights reserved.
//

#import "SquareView.h"

@interface SquareView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SquareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 1.0;
        self.backgroundColor = [UIColor blueColor];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:12.0];
        self.titleLabel.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

@end
