//
//  NSString+category.h
//  AntLive
//
//  Created by 毅力起 on 2018/8/27.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (category)

-(BOOL)containsEmoji;

-(NSDictionary *)jsonStringToDictionary;

-(BOOL)isEmpty;
-(BOOL)isIncludingEmoji;
-(NSString *)removedEmojiString;

@end
