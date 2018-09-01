//
//  NSString+category.m
//  AntLive
//
//  Created by 毅力起 on 2018/8/27.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "NSString+category.h"

@implementation NSString (category)

-(BOOL)containsEmoji{
    __block BOOL returnValue = NO;
    
    if ([self isNineKeyBoard]) {
        return NO;
    }
    
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              const unichar high = [substring characterAtIndex: 0];
                              
                              // Surrogate pair (U+1D000-1F9FF)
                              if (0xD800 <= high && high <= 0xDBFF) {
                                  const unichar low = [substring characterAtIndex: 1];
                                  const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                  
                                  if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                      returnValue = YES;
                                  }
                                  
                                  // Not surrogate pair (U+2100-27BF)
                              } else {
                                  if (0x2100 <= high && high <= 0x27BF){
                                      returnValue = YES;
                                  }
                              }
                          }];
    
    return returnValue;
}

-(BOOL)isNineKeyBoard
{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)self.length;
    for(int i=0;i<len;i++)
    {
        if(!([other rangeOfString:self].location != NSNotFound))
            return NO;
    }
    return YES;
}

-(NSDictionary *)jsonStringToDictionary{
    
    if (IsEmptyStr(self)) {
        return nil;
    }
    if ((![self hasPrefix:@"{"]||![self hasSuffix:@"}"])) {
        return nil;
    }
    NSData *tmpdata= [self dataUsingEncoding: NSUTF8StringEncoding];
    
    NSError *error;
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:tmpdata options:NSJSONReadingAllowFragments error:&error];
    return dict;
}

-(BOOL)isEmpty{
    if (!self) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimedString = [self stringByTrimmingCharactersInSet:set];
    if ([trimedString length] == 0) {
        return YES;
    }
    return NO;
}

- (BOOL)isIncludingEmoji {
    BOOL __block result = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                              if ([substring containsEmoji]) {
                                  *stop = YES;
                                  result = YES;
                              }
                          }];
    
    return result;
}

- (NSString *)removedEmojiString {
    NSMutableString* __block buffer = [NSMutableString stringWithCapacity:[self length]];
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                              [buffer appendString:([substring containsEmoji])? @"": substring];
                          }];
    
    return buffer;
}


@end
