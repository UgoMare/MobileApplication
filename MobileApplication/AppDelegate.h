//
//  AppDelegate.h
//  MobileApplication
//
//  Created by Ugo on 11/12/2014.
//  Copyright (c) 2014 Epitech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSMutableArray *pictures;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

