//
//  SquarePostionInfo.h
//  SquareProblem
//
//  Created by Nithin Bhaktha on 12/30/15.
//  Copyright © 2015 Airwatch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger) {
    SqaurePositionNone = -1,
    SqaurePositionLeft,
    SqaurePositionRight,
    SqaurePositionBottom,
    SqaurePositionTop
}SqaurePosition;


@interface SquarePostionInfo : NSObject

@property (nonatomic, assign) SqaurePosition position;
@property (nonatomic, assign) CGRect boundary;
@property (nonatomic, weak) UIView *square;

@end
