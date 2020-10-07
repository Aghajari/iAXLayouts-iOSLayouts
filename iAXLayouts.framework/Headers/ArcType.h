//
//  ArcType.h
//  iAXLayouts
//
//  Created by AmirHossein Aghajari on 10/3/20.
//  Copyright © 2020 Amir Hossein Aghajari. All rights reserved.
//

@interface ArcPoint : NSObject {
    int x;
    int y;
}

- (id _Nonnull) initWithValue : (int) x : (int) y;

@property (nonatomic) int x;
@property (nonatomic) int y;

@end

@protocol ArcTypeDelegate <NSObject>
@optional

- (ArcPoint* _Nonnull) computeOrigin : (int) l : (int) t : (int) r : (int) b;
- (int) computeWidth :(int) radius;
- (int) computeHeight :(int) radius;

@end

@interface ArcType : NSObject {
    int startAngle;
    int sweepAngle;
}

- (id _Nonnull ) initWithGravity : (int) gravity;
- (id _Nonnull ) initWithValue : (int) startAngle : (int) sweepAngle;

@property (nullable, nonatomic, weak) id <ArcTypeDelegate> delegate;
@property (nonatomic) int startAngle;
@property (nonatomic) int sweepAngle;

- (ArcPoint* _Nonnull) computeOrigin : (int) l : (int) t : (int) r : (int) b;
- (int) computeWidth :(int) radius;
- (int) computeHeight :(int) radius;

- (float) computeDegrees : (int) index : (float) perDegrees;
- (float) computeReverseDegrees : (int) index : (float) perDegrees;
- (float) computePerDegrees : (int) size;

+ (int) centerX : (int) left : (int) right;
+ (int) centerY : (int) top : (int) bottom;
+ (int) x : (int) radius : (float) degrees;
+ (int) y : (int) radius : (float) degrees;
+ (int) diameter : (int) radius;
+ (ArcType* _Nonnull) of : (int) origin;
+ (ArcType* _Nonnull) ofTop : (int) origin;
+ (ArcType* _Nonnull) ofCenter : (int) origin;
+ (ArcType* _Nonnull) ofBottom : (int) origin;

+ (float) computeCircleX : (float) r : (float) degrees;
+ (float) computeCircleY : (float) r : (float) degrees;
+ (int) computeWidth : (int) origin : (int) size : (int) x ;
+ (int) computeHeight : (int) origin : (int) size : (int) y;

@end


