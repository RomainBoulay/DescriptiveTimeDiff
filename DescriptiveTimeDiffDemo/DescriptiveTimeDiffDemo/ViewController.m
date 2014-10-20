//
//  ViewController.m
//  DescriptiveTimeDiffDemo
//
//  Created by Romain Boulay on 20/02/14.
//  Copyright (c) 2014 RBAK. All rights reserved.
//

#import "ViewController.h"

#import "NSDate+DescriptiveTimeDiff.h"


@interface ViewController ()

@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UISwitch *switchControl;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) DescriptiveTimeDiffType timeDiffType;
@end

@implementation ViewController

static NSString *CellIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
     
    self.items = [NSArray arrayWithObjects:
             [NSDate dateWithTimeIntervalSinceNow:-10],
             [NSDate dateWithTimeIntervalSinceNow:-60],
             [NSDate dateWithTimeIntervalSinceNow:-360],
             [NSDate dateWithTimeIntervalSinceNow:-3600],
             [NSDate dateWithTimeIntervalSinceNow:-10800],
             [NSDate dateWithTimeIntervalSinceNow:-3600*24],
             [NSDate dateWithTimeIntervalSinceNow:-3600*24*5],
             [NSDate dateWithTimeIntervalSinceNow:-3600*24*30],
             [NSDate dateWithTimeIntervalSinceNow:-3600*24*100],
             [NSDate dateWithTimeIntervalSinceNow:-3600*24*200],
             [NSDate dateWithTimeIntervalSinceNow:-3600*24*365],
             [NSDate dateWithTimeIntervalSinceNow:-3600*24*1000],
             nil];
    
    [self.tableView reloadData];
}


- (IBAction)segmentedAction:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    switch (segmentedControl.selectedSegmentIndex)
    {
        case 0:
            self.timeDiffType = DescriptiveTimeDiffTypeSuffixNone;
            break;
        case 1:
            self.timeDiffType = DescriptiveTimeDiffTypeSuffixLeft;
            break;
        case 2:
            self.timeDiffType = DescriptiveTimeDiffTypeSuffixAgo;
            break;
    }
    [self.tableView reloadData];
}


- (IBAction)switchAction:(id)sender {
    [self.tableView reloadData];
}


- (IBAction)displayVerbose:(id)sender {
    [self.switchControl setOn:YES animated:YES];
    [self.tableView reloadData];
}


- (IBAction)displayShort:(id)sender {
    [self.switchControl setOn:NO animated:YES];
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSDate *date = [self.items  objectAtIndex:indexPath.row];
    [cell.textLabel setText:[date descriptiveTimeDifferenceWithDate:[NSDate date] type:self.timeDiffType fullString:self.switchControl.on]];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
