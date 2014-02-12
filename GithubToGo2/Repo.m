//
//  Repo.m
//  GithubToGo2
//
//  Created by Chris Meehan on 2/11/14.
//  Copyright (c) 2014 Chris Meehan. All rights reserved.
//

#import "Repo.h"


@implementation Repo

@dynamic name;
@dynamic html_url;

-(id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context withJSONDictionary:(NSDictionary*)jSON{
    
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    if(self != nil){
        [self parseJSONDictionary:jSON];
    }
    
    return self;
}

-(void)parseJSONDictionary:(NSDictionary*)jSON{
    self.name = [jSON objectForKey:@"name"];
    self.html_url = [jSON objectForKey:@"html_url"];
    [self.managedObjectContext save:nil];
}


@end
