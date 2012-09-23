//
//  GGHashtagMentionController.m
//  TestApp
//
//  Created by John Z Wu on 9/22/12.
//  Copyright (c) 2012 TFM. All rights reserved.
//

#import "GGHashtagMentionController.h"

NSString * const MentionChar = @"@";
NSString * const HashtagChar = @"#";
NSString * const SpaceChar = @" ";

@interface GGHashtagMentionController () {
    UITextView *_textView;
    id <GGHashtagMentionDelegate> _delegate;
}

@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, assign) id <GGHashtagMentionDelegate> delegate;

- (void) onTextViewTextDidChange:(NSNotification *)notification;

@end

@implementation GGHashtagMentionController
@synthesize textView = _textView;
@synthesize delegate = _delegate;

#pragma mark - Object LifeCycle

- (id) initWithTextView:(UITextView *)textView delegate:(id <GGHashtagMentionDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.textView = textView;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextViewTextDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    self.textView = nil;
    [super dealloc];
}

#pragma mark - NSNotification

- (void) onTextViewTextDidChange:(NSNotification *)notification {
    // don't proceed unless the one we're observing
    if (notification.object == self.textView) {
        // identify the word we're on
        NSUInteger insertionLocation = self.textView.selectedRange.location;
        NSString *fullText = self.textView.text;
        NSRange spaceBeforeRange = [fullText rangeOfString:SpaceChar options:NSLiteralSearch|NSBackwardsSearch range:NSMakeRange(0, insertionLocation)];
        NSRange spaceAfterRange = [fullText rangeOfString:SpaceChar options:NSLiteralSearch range:NSMakeRange(insertionLocation, fullText.length-insertionLocation)];
        NSUInteger location = spaceBeforeRange.location == NSNotFound ? 0 : spaceBeforeRange.location+1;
        NSUInteger length = spaceAfterRange.location == NSNotFound ? fullText.length-location : spaceAfterRange.location-location;
        NSRange range = NSMakeRange(location, length);
        NSString *word = [fullText substringWithRange:range];

        // if word isn't degenerate
        if (word.length >= 1) {
            NSString *first = [word substringToIndex:1];
            NSString *rest = [word substringFromIndex:1];
            NSRange range = [fullText rangeOfString:rest options:NSLiteralSearch|NSAnchoredSearch range:NSMakeRange(location+1, rest.length)];
            if ([first isEqualToString:MentionChar] && [self.delegate respondsToSelector:@selector(hashtagMentionController:onMentionWithText:range:)]) {
                [self.delegate hashtagMentionController:self onMentionWithText:rest range:range];
            } else if ([first isEqualToString:HashtagChar] && [self.delegate respondsToSelector:@selector(hashtagMentionController:onHashtagWithText:range:)]) {
                [self.delegate hashtagMentionController:self onHashtagWithText:rest range:range];
            }
        } else if ([self.delegate respondsToSelector:@selector(hashtagMentionControllerDidFinishWord:)]) {
            [self.delegate hashtagMentionControllerDidFinishWord:self];
        }
    }
}

@end
