//
//  SquarePlayground.m
//  SquareProblem
//
//  Created by Vasu N on 12/24/15.
//  Copyright © 2015 Airwatch. All rights reserved.
//

#import "SquarePlayground.h"
#import "SquareView.h"
#import "SquarePostionInfo.h"

#define SQUARE_SIZE 50

@implementation SquarePlayground
{
    NSInteger _sqaureCount;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _sqaureCount = 0;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _sqaureCount = 0;
    }
    return self;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint locationInView = [[touches anyObject] locationInView:self];
    
    SquareView *sqaureView = [self squareAtPoint:locationInView];
    if (nil == sqaureView)
    {
        _sqaureCount++;
        [self addSqaureAtPoint:locationInView];
    }
    else
    {
        /* Sqaure already present, find other possible frames */
        SqaurePosition tappedPosition = [self positionOfTap:locationInView withRespectToSqaure:sqaureView];
        CGRect bestFrame = [self bestBestPositionToPlaceSqaure:sqaureView tappedPosition:tappedPosition];
        if (!CGRectIsEmpty(bestFrame))
        {
            _sqaureCount++;
            SquareView *newSqaure = [[SquareView alloc] initWithFrame:sqaureView.frame];
            [newSqaure setTitle:[NSString stringWithFormat:@"%ld", (long)_sqaureCount]];
            
            [self addSubview:newSqaure];
            [UIView animateWithDuration:0.3 animations:^{
                newSqaure.frame = bestFrame;
            }];
        }
        else {
            NSLog(@"******* Error: Screen is full!! *****");
        }
    }
}

- (void)addSqaureAtPoint:(CGPoint)point
{
    SquareView *sqaure = [[SquareView alloc] initWithFrame:CGRectMake(point.x-SQUARE_SIZE/2, point.y-SQUARE_SIZE/2, SQUARE_SIZE, SQUARE_SIZE)];
    [sqaure setTitle:[NSString stringWithFormat:@"%ld", (long)_sqaureCount]];
    [self addSubview:sqaure];
}

- (void)addSquare:(SquareView *)sqaureView WithFrame:(CGRect)squareFrame
{
    SquareView *sqaure = [[SquareView alloc] initWithFrame:squareFrame];
    sqaure.backgroundColor = [UIColor blueColor];
    [self addSubview:sqaure];
}

- (SquareView *)squareAtPoint:(CGPoint)point
{
    SquareView *squareView = nil;
    CGRect squareBounds = CGRectMake(point.x-SQUARE_SIZE/2, point.y-SQUARE_SIZE/2, SQUARE_SIZE, SQUARE_SIZE);
    
    for (SquareView *subView in self.subviews)
    {
        if(CGRectIntersectsRect(squareBounds, subView.frame))
        {
            squareView = subView;
            break;
        }
    }
    
    return squareView;
}

- (NSDictionary *)possibleFramesForSqaureNeighbourTo:(SquareView *)neighbourSqaureview
{
    CGRect leftFrame = (CGRect){neighbourSqaureview.frame.origin.x+neighbourSqaureview.frame.size.width, neighbourSqaureview.frame.origin.y, neighbourSqaureview.frame.size};
    
    CGRect rightFrame = (CGRect){neighbourSqaureview.frame.origin.x-neighbourSqaureview.frame.size.width, neighbourSqaureview.frame.origin.y, neighbourSqaureview.frame.size};

    CGRect topFrame = (CGRect){neighbourSqaureview.frame.origin.x, neighbourSqaureview.frame.origin.y - neighbourSqaureview.frame.size.height, neighbourSqaureview.frame.size};

    CGRect bottomFrame = (CGRect){neighbourSqaureview.frame.origin.x, neighbourSqaureview.frame.origin.y + neighbourSqaureview.frame.size.height, neighbourSqaureview.frame.size};
 
    return @{@"left": NSStringFromCGRect(leftFrame),
             @"right": NSStringFromCGRect(rightFrame),
             @"top": NSStringFromCGRect(topFrame),
             @"bottom": NSStringFromCGRect(bottomFrame)
             };
}

- (NSDictionary *)possiblePositionInfoForSqaureNeighbourTo:(SquareView *)neighbourSqaureview {
    SquarePostionInfo *leftPositionInfo = [[SquarePostionInfo alloc] init];
    SquarePostionInfo *rightPositionInfo = [[SquarePostionInfo alloc] init];
    SquarePostionInfo *topPositionInfo = [[SquarePostionInfo alloc] init];
    SquarePostionInfo *bottomPositionInfo = [[SquarePostionInfo alloc] init];
    
    CGRect leftFrame = (CGRect){neighbourSqaureview.frame.origin.x+neighbourSqaureview.frame.size.width, neighbourSqaureview.frame.origin.y, neighbourSqaureview.frame.size};
    leftPositionInfo.boundary = leftFrame;
    
    CGRect rightFrame = (CGRect){neighbourSqaureview.frame.origin.x-neighbourSqaureview.frame.size.width, neighbourSqaureview.frame.origin.y, neighbourSqaureview.frame.size};
    rightPositionInfo.boundary = rightFrame;
    
    CGRect topFrame = (CGRect){neighbourSqaureview.frame.origin.x, neighbourSqaureview.frame.origin.y - neighbourSqaureview.frame.size.height, neighbourSqaureview.frame.size};
    topPositionInfo.boundary = topFrame;
    
    CGRect bottomFrame = (CGRect){neighbourSqaureview.frame.origin.x, neighbourSqaureview.frame.origin.y + neighbourSqaureview.frame.size.height, neighbourSqaureview.frame.size};
    bottomPositionInfo.boundary = bottomFrame;
    
    for (SquareView *subView in self.subviews)
    {
        if(CGRectIntersectsRect(leftFrame, subView.frame))
        {
            leftPositionInfo.square = subView;
        }
        
        if(CGRectIntersectsRect(rightFrame, subView.frame))
        {
            rightPositionInfo.square = subView;
        }
        
        if(CGRectIntersectsRect(bottomFrame, subView.frame))
        {
            bottomPositionInfo.square = subView;
        }
        
        if(CGRectIntersectsRect(topFrame, subView.frame))
        {
            topPositionInfo.square = subView;
        }
    }

    NSDictionary *resultDictionary = [NSDictionary dictionaryWithObjectsAndKeys:leftPositionInfo,@"left",rightPositionInfo,@"right",bottomPositionInfo,@"bottom",topPositionInfo,@"top", nil];
    return resultDictionary;
}

- (CGRect)bestBestPositionToPlaceSqaure:(SquareView *)sqaureView tappedPosition:(SqaurePosition)tappedPosition
{
    __block CGRect bestFrame = CGRectZero;
    NSDictionary *possiblePositionInfo = [self possiblePositionInfoForSqaureNeighbourTo:sqaureView];
    
    // Check if all positions are filled
    SquareView *leftSquare = (SquareView *)[[possiblePositionInfo objectForKey:@"left"] square];
    SquareView *rightSquare = (SquareView *)[[possiblePositionInfo objectForKey:@"right"] square];
    SquareView *topSquare = (SquareView *)[[possiblePositionInfo objectForKey:@"top"] square];
    SquareView *bottomSquare = (SquareView *)[[possiblePositionInfo objectForKey:@"bottom"] square];
    
    if (leftSquare && rightSquare && topSquare && bottomSquare)
    {
        // Check if neighbours of Left is Free
        [self checkNeighboursAndGetBestPositionForSquare:leftSquare tappedPosition:tappedPosition onCompletion:^(SqaurePosition position, CGRect availableFrame) {
            if (position == SqaurePositionNone)
            {
                [self checkNeighboursAndGetBestPositionForSquare:rightSquare tappedPosition:tappedPosition onCompletion:^(SqaurePosition position, CGRect availableFrame) {
                    if (position == SqaurePositionNone)
                    {
                        [self checkNeighboursAndGetBestPositionForSquare:topSquare tappedPosition:tappedPosition onCompletion:^(SqaurePosition position, CGRect availableFrame) {
                            if (position == SqaurePositionNone)
                            {
                                [self checkNeighboursAndGetBestPositionForSquare:bottomSquare tappedPosition:tappedPosition onCompletion:^(SqaurePosition position, CGRect availableFrame) {
                                    if (position == SqaurePositionNone)
                                    {
                                        bestFrame = [self bestBestPositionToPlaceSqaure:leftSquare tappedPosition:tappedPosition];
                                    }
                                    else {
                                        bestFrame = availableFrame;
                                    }
                                }];
                            }
                            else {
                                bestFrame = availableFrame;
                            }
                        }];
                    }
                    else {
                        bestFrame = availableFrame;
                    }
                }];
            }
            else {
                bestFrame = availableFrame;
            }
            
        }];
    }
    else {
        // One of the position is free, get the best one
        if (!leftSquare)
        {
            bestFrame = [[possiblePositionInfo objectForKey:@"left"] boundary];
        }
        else if (!rightSquare)
        {
            bestFrame = [[possiblePositionInfo objectForKey:@"right"] boundary];
        }
        else if (!topSquare)
        {
            bestFrame = [[possiblePositionInfo objectForKey:@"top"] boundary];
        }
        else
        {
            bestFrame = [[possiblePositionInfo objectForKey:@"bottom"] boundary];
        }
    }
    
    
    NSLog(@"******* Best Frame = %@", NSStringFromCGRect(bestFrame));
    return bestFrame;
}

- (void)checkNeighboursAndGetBestPositionForSquare:(SquareView *)sqaureView tappedPosition:(SqaurePosition)tappedPosition onCompletion:(void (^)(SqaurePosition position, CGRect bestFrame))completionHandler
{
    NSDictionary *possibleFrameInfo = [self possibleFramesForSqaureNeighbourTo:sqaureView];
    SqaurePosition newPosition = SqaurePositionNone;
    CGRect bestFrame = CGRectZero;
    SquareView *neighbourView = [self getExistingSqaureInFrames:possibleFrameInfo withPositionOfTap:tappedPosition availablePosition:&newPosition];
    if (newPosition != SqaurePositionNone)
    {
        switch (newPosition)
        {
            case SqaurePositionLeft:
            {
                bestFrame = CGRectFromString(possibleFrameInfo[@"left"]);
                break;
            }
            case SqaurePositionRight:
            {
                bestFrame = CGRectFromString(possibleFrameInfo[@"right"]);
                break;
            }
            case SqaurePositionBottom:
            {
                bestFrame = CGRectFromString(possibleFrameInfo[@"bottom"]);
                break;
            }
            case SqaurePositionTop:
            {
                bestFrame = CGRectFromString(possibleFrameInfo[@"top"]);
                break;
            }
                
            default:
                break;
        }
    }
    
    completionHandler(newPosition, bestFrame);
}

- (SquareView *)getExistingSqaureInFrames:(NSDictionary *)possiblePositions withPositionOfTap:(SqaurePosition)tappedPosition availablePosition:(SqaurePosition *)availablePos
{
    SquareView *sqaureView = nil;
    *availablePos = SqaurePositionNone;
    
    SquareView *leftSqaureView = nil;
    SquareView *rightSqaureView = nil;
    SquareView *topSqaureView = nil;
    SquareView *bottomSqaureView = nil;

    CGRect leftFrame = CGRectFromString(possiblePositions[@"left"]);
    CGRect rightFrame = CGRectFromString(possiblePositions[@"right"]);
    CGRect topFrame = CGRectFromString(possiblePositions[@"top"]);
    CGRect bottomFrame = CGRectFromString(possiblePositions[@"bottom"]);
    
    for (SquareView *subView in self.subviews)
    {
        if(CGRectIntersectsRect(leftFrame, subView.frame))
        {
            leftSqaureView = subView;
        }
        
        if(CGRectIntersectsRect(rightFrame, subView.frame))
        {
            rightSqaureView = subView;
        }

        if(CGRectIntersectsRect(bottomFrame, subView.frame))
        {
            bottomSqaureView = subView;
        }

        if(CGRectIntersectsRect(topFrame, subView.frame))
        {
            topSqaureView = subView;
        }
    }
    
    if (leftSqaureView && rightSqaureView && topSqaureView && bottomSqaureView)
    {
        // TODO: Get SqaureView based on tap direction to the original touch point
        switch (tappedPosition)
        {
            case SqaurePositionLeft:
                sqaureView = leftSqaureView;
                break;
            case SqaurePositionRight:
                sqaureView = rightSqaureView;
                break;
            case SqaurePositionTop:
                sqaureView = topSqaureView;
                break;
            case SqaurePositionBottom:
                sqaureView = bottomSqaureView;
                break;
            default:
                break;
        }
        sqaureView = leftSqaureView;
    }
    else {
        /* Some place is free, find the best one */
        switch (tappedPosition)
        {
            case SqaurePositionLeft:
                if (!leftSqaureView) {
                    *availablePos = SqaurePositionLeft;
                }
                break;
            case SqaurePositionRight:
                if (!rightSqaureView) {
                    *availablePos = SqaurePositionRight;
                }

                break;
            case SqaurePositionTop:
                if (!topSqaureView) {
                    *availablePos = SqaurePositionTop;
                }
                break;
            case SqaurePositionBottom:
                if (!bottomSqaureView) {
                    *availablePos = SqaurePositionBottom;
                }
                break;
            default:
                break;
        }
        
        if (*availablePos == SqaurePositionNone) {
            if (!leftSqaureView)
            {
                *availablePos = SqaurePositionLeft;
            }
            else if (!rightSqaureView)
            {
                *availablePos = SqaurePositionRight;
            }
            else if (!bottomSqaureView)
            {
                *availablePos = SqaurePositionBottom;
            }
            else if (!topSqaureView)
            {
                *availablePos = SqaurePositionTop;
            }
        }
    }
    
    return sqaureView;
}

- (SqaurePosition)positionOfTap:(CGPoint)tappedPoint withRespectToSqaure:(SquareView *)squareView
{
    SqaurePosition position = SqaurePositionNone;
    CGPoint center = squareView.center;
    if (tappedPoint.x < center.x)
    {
        position = SqaurePositionRight;
    }
    else {
        position = SqaurePositionLeft;
    }
    
    return position;
}

@end
