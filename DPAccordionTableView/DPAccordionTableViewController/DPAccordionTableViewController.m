//
//  DPAccordionTableViewController.m
//  DPAccordionTableView
//
//  Created by Kostas Antonopoulos on 9/30/12.
//  Copyright (c) 2012 Kostas Antonopoulos. All rights reserved.
//

#import "DPAccordionTableViewController.h"

@interface DPAccordionTableViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>{

    
}

@end

@implementation DPAccordionTableViewController
@synthesize datasource;
@synthesize delegate;
@synthesize tableView;
@synthesize openSection = _openSection;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _openSection=NSNotFound;

    tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
    
    [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];

    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(tableView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:0 metrics:nil views:viewsDictionary]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [tableView reloadData];

    if (self.openSection!=NSNotFound) {
        [self openSection:self.openSection];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)openSection{
    return _openSection;
}

-(void)setOpenSection:(NSInteger)openSection{
    if (openSection!=NSNotFound) {
        [self openSection:openSection];
    }else{
        [self closeSection:_openSection];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)itableView
{
    // Return the number of sections.
    return [self.datasource numberOfSectionsInAccordionTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)itableView numberOfRowsInSection:(NSInteger)section
{
    if (section==_openSection) {
        return [self.datasource accordionTableView:tableView numberOfRowsInExpandedSection:section];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.datasource accordionTableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView2 didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView2 deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(accordionTableView:didSelectRowAtIndexPath:)]) {
        [self.delegate accordionTableView:tableView2 didSelectRowAtIndexPath:indexPath];
    }
    
    
}

-(UIView*)tableView:(UITableView *)itableView viewForHeaderInSection:(NSInteger)section{
    UIView *header;
    if (self.delegate && [self.delegate respondsToSelector:@selector(accordionTableView:headerViewForSection:)]) {
        header = [self.delegate accordionTableView:tableView headerViewForSection:section];
    }else{
        header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 30)];
        
        if ([self.datasource respondsToSelector:@selector(accordionTableView:titleForSection:)]) {
            [titleLabel setText:[self.datasource accordionTableView:tableView titleForSection:section]];
        }else{
            [titleLabel setText:[NSString stringWithFormat:@"Section %d",section]];
        }
        [header addSubview:titleLabel];
    }

    UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTapped:)];
    [tapRecognizer setDelegate:self];
    [header addGestureRecognizer:tapRecognizer];

    header.tag=section;
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.tableHeaderHeight) {
        return self.tableHeaderHeight;
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView2 heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.delegate accordionTableView:tableView2 heightForRowAtIndexPath:indexPath];
}

#pragma mark - Header Actions

-(void)headerTapped:(UITapGestureRecognizer*)sender{
    if (_openSection!=sender.view.tag) { //einai kleisto
        [self openSection:sender.view.tag];
    }else{
        [self closeSection:sender.view.tag];
    }
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIControl class]]) {
        // we touched a button, slider, or other UIControl
        return NO; // ignore the touch
    }
    return YES; // handle the touch
}

#pragma mark - Open/Close TableView

-(void)openSection:(NSInteger)section{
    if (self.delegate && [self.delegate respondsToSelector:@selector(accordionTableView:shouldOpenSection:)]) {
        if (![self.delegate accordionTableView:tableView shouldOpenSection:section]) {
            return;
        }
    }
    NSInteger oldOpenSection=_openSection;

    if ([self.delegate respondsToSelector:@selector(accordionTableView:willCloseSection:)]&&oldOpenSection!=NSNotFound) {
        [self.delegate accordionTableView:tableView willCloseSection:oldOpenSection];
    }
    
    if ([self.delegate respondsToSelector:@selector(accordionTableView:willOpenSection:)]) {
        [self.delegate accordionTableView:tableView willOpenSection:section];
    }
    
    //close previous open rows
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
     if (_openSection != NSNotFound) {
        for (NSInteger i = 0; i < [self.datasource accordionTableView:tableView numberOfRowsInExpandedSection:_openSection]; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:_openSection]];
        }
    }
    //open new rows
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [self.datasource accordionTableView:tableView numberOfRowsInExpandedSection:section]; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (section == NSNotFound || section < _openSection) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    _openSection=section;

    // Apply the updates.
    [self.view setUserInteractionEnabled:NO];
    [tableView beginUpdates];
    [tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [tableView endUpdates];

    if ([indexPathsToInsert count]!=0) {
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }

    
    if ([self.delegate respondsToSelector:@selector(accordionTableView:didCloseSection:)]&&oldOpenSection!=NSNotFound) {
        [self.delegate accordionTableView:tableView didCloseSection:oldOpenSection];
    }
    
    if ([self.delegate respondsToSelector:@selector(accordionTableView:didOpenSection:)]) {
        [self.delegate accordionTableView:tableView didOpenSection:section];
    }
    

    [self.view setUserInteractionEnabled:YES];
}

-(void)closeSection:(NSInteger)section{
    if (self.delegate && [self.delegate respondsToSelector:@selector(accordionTableView:shouldCloseSection:)]) {
        if (![self.delegate accordionTableView:tableView shouldCloseSection:section]) {
            return;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(accordionTableView:willCloseSection:)]) {
        [self.delegate accordionTableView:tableView willCloseSection:section];
    }
    
    //close open rows
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    if (_openSection != NSNotFound) {
        for (NSInteger i = 0; i < [self.datasource accordionTableView:tableView numberOfRowsInExpandedSection:section]; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
    }
    
    _openSection=NSNotFound;
    // Apply the updates.
    [self.view setUserInteractionEnabled:NO];
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    [tableView endUpdates];
    
    if ([self.delegate respondsToSelector:@selector(accordionTableView:didCloseSection:)]) {
        [self.delegate accordionTableView:tableView didCloseSection:section];
    }
//    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.view setUserInteractionEnabled:YES];
}

@end
