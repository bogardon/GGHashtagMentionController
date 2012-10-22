//
//  GGHashtagMentionController.m
//  TestApp
//
//  Created by John Z Wu on 9/22/12.
//  Copyright (c) 2012 TFM. All rights reserved.
//

#import "GGHashtagMentionController.h"

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
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\b[@#\\w]+\\b" options:NSRegularExpressionUseUnicodeWordBoundaries error:NULL];
        __block NSString *word = nil;
        __block NSRange range = NSMakeRange(NSNotFound, 0);
        [regex enumerateMatchesInString:self.textView.text options:0 range:NSMakeRange(0, self.textView.text.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if (result.range.location <= insertionLocation && result.range.location+result.range.length >= insertionLocation) {
                word = [self.textView.text substringWithRange:result.range];
                range = result.range;
                *stop = YES;
            }

        }];

        // if word isn't degenerate
        if (word.length >= 1 && range.location != NSNotFound) {
            NSString *first = [word substringToIndex:1];
            NSString *rest = [word substringFromIndex:1];
            if ([first isEqualToString:@"@"] && [self.delegate respondsToSelector:@selector(hashtagMentionController:onMentionWithText:range:)]) {
                [self.delegate hashtagMentionController:self onMentionWithText:rest range:range];
            } else if ([first isEqualToString:@"#"] && [self.delegate respondsToSelector:@selector(hashtagMentionController:onHashtagWithText:range:)]) {
                [self.delegate hashtagMentionController:self onHashtagWithText:rest range:range];
            }
        } else if ([self.delegate respondsToSelector:@selector(hashtagMentionControllerDidFinishWord:)]) {
            [self.delegate hashtagMentionControllerDidFinishWord:self];
        }
    }
}

@end
