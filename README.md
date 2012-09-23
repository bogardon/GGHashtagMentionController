GGHashtagMentionController
==========================

this helps you do @mention #hashtag completion by abstracting away the regex logic

#### Sample App
The sample implements @mention completion on a `UITextView` by allowing you to select from a list of predefined names in a `UITableView`.

#### How To Use
Take control of a `UITextView` and become the `delegate`:

    - (void) hashtagMentionController:(GGHashtagMentionController *)hashtagMentionController onMentionWithText:(NSString *)text range:(NSRange)range;

As the `delegate`, you may implement any of the following:

    - (void) hashtagMentionController:(GGHashtagMentionController *)hashtagMentionController onMentionWithText:(NSString *)text range:(NSRange)range;

    - (void) hashtagMentionController:(GGHashtagMentionController *)hashtagMentionController onHashtagWithText:(NSString *)text range:(NSRange)range;
    
When your `UITextView`'s `text` property changes, `GGHashtagMentionController` checks to see if the cursor is touching a word starting with a `@`  or `#`. The corresponding callback is then triggered.
The `text` property is the portion of the word that comes after the modifier. i.e., @word => word, #asdf => asdf, and @#hehehoho => #hehehoho.
The `range` property indicates the range of the `text` in relation to the entire text of the of the `UITextView`, this is to help you autocomplete the word.

    - (void) hashtagMentionControllerDidFinishWord:(GGHashtagMentionController *)hashtagMentionController;

This gets called if the change in the `text` property ends a word. i,e. by pressing spacebar.

#### License

GGHashtagMentionController is available under the MIT license. See the LICENSE file for more info.