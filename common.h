//
//  common.h
//  objective_resource
//
//  Created by JP on 10. 5. 17..
//  Copyright 2010 com.fobikr. All rights reserved.
//




#define GET_APP_DELEGATE()	(objective_resourceAppDelegate *)[[UIApplication sharedApplication] delegate]
#define DebugLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
///////////////////////////////////////////////////////////////////////////////////////////////////
// Safe releases

#define TT_RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }
#define TT_INVALIDATE_TIMER(__TIMER) { [__TIMER invalidate]; __TIMER = nil; }

// Release a CoreFoundation object safely.
#define TT_RELEASE_CF_SAFELY(__REF) { if (nil != (__REF)) { CFRelease(__REF); __REF = nil; } }

#define DARK_BACKGROUND  [UIColor colorWithRed:151.0/255.0 green:152.0/255.0 blue:155.0/255.0 alpha:1.0]
#define LIGHT_BACKGROUND [UIColor colorWithRed:172.0/255.0 green:173.0/255.0 blue:175.0/255.0 alpha:1.0]
#define PAGINATION_COUNT 15

#define FULL_FRAME	CGRectMake(0, 0, 320, 460)

// View area
#define VIEW_LOC_X	0
#define VIEW_LOC_Y	0
#define VIEW_WIDTH	320
#define VIEW_HEIGHT 411//400
#define VIEW_FRAME	CGRectMake(VIEW_LOC_X, VIEW_LOC_Y, VIEW_WIDTH, VIEW_HEIGHT)
#define VIEW_FRAME_WITH_TABBAR	CGRectMake(VIEW_LOC_X, VIEW_LOC_Y, VIEW_WIDTH, VIEW_HEIGHT-45)

// Tab Menu area
#define TAB_BUTTON_WIDTH 80

#define TAB_WIDTH	320
#define TAB_HEIGHT	49
#define TITLE_SIZE	20
#define SUBTITLE_SIZE	14

#define TAB_LOC_X	0
#define TAB_LOC_Y	480-TAB_HEIGHT

#define TAB_FRAME	CGRectMake(TAB_LOC_X, TAB_LOC_Y, TAB_WIDTH, TAB_HEIGHT)

#define TAB_FRAME2	CGRectMake(TAB_LOC_X, TAB_LOC_Y-20, TAB_WIDTH, TAB_HEIGHT)

//ToolbaTab area
#define TOOLTAB_WIDTH	320
#define TOOLTAB_HEIGHT	44

#define SCREEN_FRAME	CGRectMake(0, TOOLTAB_HEIGHT, VIEW_WIDTH, VIEW_HEIGHT-TOOLTAB_HEIGHT-TAB_HEIGHT)
#define TOOLTAB_FRAME	CGRectMake(0, 0, VIEW_WIDTH, TOOLTAB_HEIGHT)

#define FETCH_BUTTON_ICON @"btn_more.png"
#define FETCH_BUTTON_ICON2 @"btn_more_o.png"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]  
