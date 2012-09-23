//
//  GGHashtagMentionController.h
//  TestApp
//
//  Created by John Z Wu on 9/22/12.
//  Copyright (c) 2012 TFM. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol GGHashtagMentionDelegate;

@interface GGHashtagMentionController : NSObject

- (id) initWithTextView:(UITextView *)textView delegate:(id <GGHashtagMentionDelegate>)delegate;

@end

@protocol GGHashtagMentionDelegate <NSObject>

@optional

- (void) hashtagMentionController:(GGHashtagMentionController *)hashtagMentionController onMentionWithText:(NSString *)text range:(NSRange)range;

- (void) hashtagMentionController:(GGHashtagMentionController *)hashtagMentionController onHashtagWithText:(NSString *)text range:(NSRange)range;

- (void) hashtagMentionControllerDidFinishWord:(GGHashtagMentionController *)hashtagMentionController;

@end