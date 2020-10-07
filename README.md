## iAXLayouts - iOS Layouts
 
**Let's include AndroidLayouts into iOS!**

A `MainLayout` is a special `UIView` that can contain other views (called children or subview.) The `MainLayout` is the base class for layouts and views containers.

As you might expect, one of the main responsibilities of a `Layout` is laying out those children: picking how large each View is (the ‘measure’ phase) and placing the Views within the layout (the ‘layout’ phase).

Currently supported Layouts :
- LinearLayout
- FrameLayout
- RelativeLayout
- ArcLayout

## Usage 

Add framework to your project and import it:
```objc
#import <iAXLayouts/iAXLayouts.h>
```

## Table of Contents  
- [LinearLayout](#linearlayout)
- [FrameLayout](#framelayout)
- [RelativeLayout](#relativelayout)
- [ArcLayout](#arclayout)
- [LayoutParams](#layoutparams)
- [Author](#author)
- [License](#license)


## LinearLayout
`LinearLayout` has one goal in life: lay out children in a single row or column (depending on if its orientation is horizontal or vertical).

![linearlayout](https://user-images.githubusercontent.com/30867537/95322126-e1c14600-08a8-11eb-9e05-0e05126fe72d.png)

Example (Vertical) :
```objc
LinearLayout *layout = [[LinearLayout alloc] initWithOrientation:ORIENTATION_VERTICAL];
...
[self.view addSubview:layout];
[self addItem];
[self addItem];
[self addItem];
...

- (void) addItem {
 UIButton *btn = [[UIButton alloc] init];
 [btn setTitle:@"Item" forState:UIControlStateNormal];
 [btn setBackgroundColor:[UIColor blueColor]];
 
 LinearLayoutParams *lp1 = [[LinearLayoutParams alloc] initWithSize:MATCH_PARENT :WRAP_CONTENT];
 [lp1 setMargins:20 :20 :20 :0];
 lp1.gravity = [Gravity CENTER];
 [layout addSubview:btn :lp1];
}
```

Output:

<img src="https://user-images.githubusercontent.com/30867537/95322717-c73b9c80-08a9-11eb-8981-a42b74c20911.png" width=250 title="Screen"/>

Example (Horizontal) :

```objc
LinearLayout *layout = [[LinearLayout alloc] initWithGravity:ORIENTATION_HORIZONTAL:[Gravity CENTER]];
...
[self.view addSubview:layout];
[self addItem];
[self addItem];
[self addItem];
...

- (void) addItem {
 UIButton* btn = [[UIButton alloc] init];
 [btn setBackgroundColor:[UIColor redColor]];
 [btn setTitle:@"Item" forState:UIControlStateNormal];
 
 LinearLayoutParams *lp1 = [[LinearLayoutParams alloc] initWithSize:WRAP_CONTENT :MATCH_PARENT];
 lp1.gravity = [Gravity CENTER];
 [lp1 setMargins:10 :20 :10 :20];
 [layout addSubview:btn :lp1];
}
```

Output:

<img src="https://user-images.githubusercontent.com/30867537/95323279-c820fe00-08aa-11eb-90ef-c017b89e9581.png" width=250 title="Screen"/>

## FrameLayout
`FrameLayout` acts quite differently compared to LinearLayout: here all children are drawn as a stack — overlapping or not. The only control on positioning is the gravity attribute — pushing the child towards a side or centering it within the FrameLayout.

Example :
```objc
    FrameLayout *layout = [[FrameLayout alloc] init];
    ...
    [self.view addSubview:layout];
    
    // TOP
    UILabel *header = [[UILabel alloc] init];
    [header setText:@"FrameLayout Top"];
    [header setTextColor:[UIColor whiteColor]];
    [header setTextAlignment:NSTextAlignmentCenter];
    [header setBackgroundColor:[UIColor blueColor]];
    LinearLayoutParams *lp1 = [[LinearLayoutParams alloc] initWithSize:MATCH_PARENT :WRAP_CONTENT];
    [lp1 setMargins:20 :20 :20 :20];
    lp1.gravity = [Gravity TOP];
    lp1.extraHeight = 20;
    [layout addSubview:header :lp1];
    
    // BOTTOM
    UILabel *footer = [[UILabel alloc] init];
    [footer setText:@"FrameLayout Bottom"];
    [footer setTextColor:[UIColor whiteColor]];
    [footer setTextAlignment:NSTextAlignmentCenter];
    [footer setBackgroundColor:[UIColor darkGrayColor]];
    LinearLayoutParams *lp2 = [[LinearLayoutParams alloc] initWithSize:MATCH_PARENT :WRAP_CONTENT];
    [lp2 setMargins:20 :20 :20 :20];
    lp2.gravity = [Gravity BOTTOM];
    lp2.extraHeight = 20;
    [layout addSubview:footer :lp2];
    [self.view addSubview:layout];
    
    // CENTER
    UILabel *center = [[UILabel alloc] init];
    [center setText:@"FrameLayout Center"];
    [center setTextColor:[UIColor whiteColor]];
    [center setTextAlignment:NSTextAlignmentCenter];
    [center setBackgroundColor:[UIColor redColor]];
    LinearLayoutParams *lp3 = [[LinearLayoutParams alloc] initWithSize:MATCH_PARENT :WRAP_CONTENT];
    [lp3 setMargins:20 :20 :20 :20];
    lp3.gravity = [Gravity CENTER];
    lp3.extraHeight = 20;
    [layout addSubview:center :lp3];
```

Output:

<img src="https://user-images.githubusercontent.com/30867537/95323600-50070800-08ab-11eb-9ce3-33c679583c2a.png" width=250 title="Screen"/>

## RelativeLayout
`RelativeLayout` is not nearly as simple as the previous two: a look at RelativeLayoutParams and rules shows a large number of attributes all focused around positioning children relative to the edges or center of RelativeLayout (similar to FrameLayout in fact), but also relative to one another — say, one child below another child.

![relativelayout](https://user-images.githubusercontent.com/30867537/95323842-ac6a2780-08ab-11eb-8b94-64a29eb9bc9c.png)

Example : 
```objc
    RelativeLayout *layout = [[RelativeLayout alloc] init];
    ...
    [self.view addSubview:layout];
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"TOP";
    label.backgroundColor = [UIColor blueColor];
    label.textColor = [UIColor whiteColor];
    label.tag = 1;
    RelativeLayoutParams *lp = [[RelativeLayoutParams alloc] initWithSize:MATCH_PARENT :112];
    [lp addRule:RULE_ALIGN_PARENT_TOP];
    [lp setMargins:20 :20 :20 :20];
    [layout addSubview:label :lp];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"BOTTOM";
    label2.backgroundColor = [UIColor redColor];
    label2.textColor = [UIColor whiteColor];
    label2.tag = 2;
    RelativeLayoutParams *lp2 = [[RelativeLayoutParams alloc] initWithSize:MATCH_PARENT :112];
    [lp2 addRule:RULE_ALIGN_PARENT_BOTTOM];
    [lp2 setMargins:20 :20 :20 :20];
    [layout addSubview:label2 :lp2];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.text = @"RIGHT";
    label3.backgroundColor = [UIColor darkGrayColor];
    label3.textColor = [UIColor whiteColor];
    label3.tag = 3;
    RelativeLayoutParams *lp3 = [[RelativeLayoutParams alloc] initWithSize:168 :MATCH_PARENT];
    [lp3 addRule:RULE_BELOW:1];
    [lp3 addRule:RULE_ABOVE:2];
    [lp3 addRule:RULE_ALIGN_PARENT_END];
    [lp3 setMargins:20 :0 :20 :0];
    [layout addSubview:label3 :lp3];
    
    UILabel *label4 = [[UILabel alloc] init];
    label4.textAlignment = NSTextAlignmentCenter;
    label4.text = @"LEFT";
    label4.backgroundColor = [UIColor lightGrayColor];
    label4.textColor = [UIColor whiteColor];
    label4.tag = 4;
    RelativeLayoutParams *lp4 = [[RelativeLayoutParams alloc] initWithSize:MATCH_PARENT:MATCH_PARENT];
    [lp4 addRule:RULE_BELOW:1];
    [lp4 addRule:RULE_ABOVE:2];
    [lp4 addRule:RULE_ALIGN_PARENT_START];
    [lp4 addRule:RULE_LEFT_OF:3];
    [lp4 setMargins:20 :0 :0 :0];
    [lp4 setLayoutDirection:LAYOUT_DIRECTION_RTL];
    [layout addSubview:label4 :lp4];
```

Output:

<img src="https://user-images.githubusercontent.com/30867537/95324061-04089300-08ac-11eb-9d90-f406beebb6fd.png" width=250 title="Screen"/>

Rules:
+ RULE_LEFT_OF
+ RULE_RIGHT_OF
+ RULE_ABOVE
+ RULE_BELOW
+ RULE_ALIGN_BASELINE
+ RULE_ALIGN_LEFT
+ RULE_ALIGN_TOP
+ RULE_ALIGN_RIGHT
+ RULE_ALIGN_BOTTOM
+ RULE_ALIGN_PARENT_LEFT
+ RULE_ALIGN_PARENT_TOP
+ RULE_ALIGN_PARENT_RIGHT
+ RULE_ALIGN_PARENT_BOTTOM
+ RULE_CENTER_IN_PARENT
+ RULE_CENTER_HORIZONTAL
+ RULE_CENTER_VERTICAL
+ RULE_START_OF
+ RULE_END_OF
+ RULE_ALIGN_START
+ RULE_ALIGN_END
+ RULE_ALIGN_PARENT_START
+ RULE_ALIGN_PARENT_END

## ArcLayout
an ArcLayout for iOS based on [Android-ArcLayout-Library](https://github.com/ogaclejapan/ArcLayout)

*Note: ArcLayout is not a Native Layout for Android!*

![arclayout](https://raw.githubusercontent.com/ogaclejapan/ArcLayout/master/art/icon.png)

Example :
```objc
layout = [[ArcLayout alloc] init];
layout.arcRadius = 168;
layout.axisRadius = 120;
layout.arc = [[ArcType alloc] initWithGravity:[Gravity CENTER]];// [Gravity TOP]|[Gravity Left]
...
[self.view addSubview:layout];

[self addLabel :@"A" :UIColorFromRGB(0x03a9f4)];
[self addLabel :@"B" :UIColorFromRGB(0x03a9f4)];
[self addLabel :@"C" :UIColorFromRGB(0x03a9f4)];
[self addLabel :@"D" :UIColorFromRGB(0x03a9f4)];
[self addLabel :@"E" :UIColorFromRGB(0x03a9f4)];
[self addLabel :@"F" :UIColorFromRGB(0x03a9f4)];
    
- (void) addLabel : (NSString*) text : (UIColor*) color {
    UILabel *label = [[UILabel alloc] init];
    label.layer.cornerRadius = 24;
    label.clipsToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.backgroundColor = color;
    label.textColor = [UIColor whiteColor];
    
    ArcLayoutParams *lp = [[ArcLayoutParams alloc] initWithSize:48 :48];
    [layout addSubview:label :lp];
}
```

Output:

<img src="https://user-images.githubusercontent.com/30867537/95325124-99f0ed80-08ad-11eb-918f-d73be0991855.png" width=250 title="Screen"/> <img src="https://user-images.githubusercontent.com/30867537/95325245-c4db4180-08ad-11eb-9c82-277f2cdcaf71.png" width=250 title="Screen"/>

## LayoutParams
LayoutParams are used by views to tell their parents how they want to be laid out.

by `MeasureValueDelegate` you can customize measuredValue of width and height for each View!

Example :
```objc
@interface MyDelegate : NSObject <MeasureValueDelegate>
@end

@implementation MyDelegate
- (int) GetMeasuredHeight : (MeasureValue*_Nonnull) values {
    return values.measuredValue + 20;
}
- (int) GetMeasuredWidth : (MeasureValue*_Nonnull) values {
    return values.measuredValue + 20;
}
@end

layoutParams.delegate = [[MyDelegate alloc] init];
```
or in this case simply use extra size :
```objc
 layoutParams.extraHeight = 20;
 layoutParams.extraWidth = 20;
```

## Author 
- **Amir Hossein Aghajari**

License
=======

    Copyright 2020 Amir Hossein Aghajari
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.


<br><br>
<div align="center">
  <img width="64" alt="LCoders | AmirHosseinAghajari" src="https://user-images.githubusercontent.com/30867537/90538314-a0a79200-e193-11ea-8d90-0a3576e28a18.png">
  <br><a>Amir Hossein Aghajari</a> • <a href="mailto:amirhossein.aghajari.82@gmail.com">Email</a> • <a href="https://github.com/Aghajari">GitHub</a>
</div>

