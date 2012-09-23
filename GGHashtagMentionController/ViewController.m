//
//  ViewController.m
//  GGHashtagMentionController
//
//  Created by John Z Wu on 9/22/12.
//  Copyright (c) 2012 John Z Wu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    UITableView *_tableView;
}

@property (nonatomic, retain) NSArray *names;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) GGHashtagMentionController *hmc;
@property (nonatomic, assign) NSRange replaceRange;
@property (nonatomic, retain) NSArray *matchedNames;

@end

@implementation ViewController
@synthesize names, tableView = _tableView, textView, hmc, replaceRange, matchedNames;

- (void) dealloc {
    self.names = nil;
    self.tableView = nil;
    self.textView = nil;
    self.hmc = nil;
    self.matchedNames = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.names = [@[@"alan", @"alessandro", @"alex", @"amritha", @"brendan", @"caroline", @"cynthia", @"daphne", @"dina", @"elizabeth", @"erica", @"evan", @"frances", @"frank", @"gilbert", @"gloria", @"haley", @"howard", @"hubert", @"irene", @"katie", @"keith", @"lawrence", @"lesley", @"mark", @"nathan", @"nico", @"paul", @"john", @"josh", @"benny", @"cindy", @"anthony", @"jim", @"alysa", @"carrie", @"wade", @"sang", @"jon", @"kevin", @"antonio", @"harry", @"daniel", @"jessica", @"phil", @"phoebe", @"rachel", @"raymond", @"robert", @"sabrina", @"sarah", @"shirley", @"steve", @"tiffany", @"timothy", @"tony", @"vincent", @"victoria", @"wellington", @"yale", @"zack"] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    self.textView = [[[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 216)] autorelease];
    self.textView.keyboardType = UIKeyboardTypeTwitter;
    self.textView.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.textView];

    self.hmc = [[[GGHashtagMentionController alloc] initWithTextView:self.textView delegate:self] autorelease];

    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 156, self.view.frame.size.width, 176)] autorelease];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];

    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.matchedNames.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    cell.textLabel.text = [self.matchedNames objectAtIndex:indexPath.row];

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableString *newText = [NSMutableString stringWithString:self.textView.text];
    [newText replaceCharactersInRange:self.replaceRange withString:[self.matchedNames objectAtIndex:indexPath.row]];
    self.textView.text = [NSString stringWithString:newText];


}

#pragma mark - GGHMCDelegate

- (void) hashtagMentionController:(GGHashtagMentionController *)hashtagMentionController onMentionWithText:(NSString *)text range:(NSRange)range {
    self.replaceRange = range;
    self.matchedNames = [self.names filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject rangeOfString:text].location != NSNotFound;
    }]];
    self.tableView.hidden = self.matchedNames.count == 0;
    [self.tableView reloadData];
}

- (void) hashtagMentionController:(GGHashtagMentionController *)hashtagMentionController onHashtagWithText:(NSString *)text range:(NSRange)range {

}

- (void) hashtagMentionControllerDidFinishWord:(GGHashtagMentionController *)hashtagMentionController {
    self.replaceRange = NSMakeRange(NSNotFound, 0);
    self.matchedNames = nil;
    self.tableView.hidden = YES;
}

@end
