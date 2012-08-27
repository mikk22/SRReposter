//
//  SREditProtocol.h
//  SRReposter
//
//  Created by user on 24.08.12.
//

@protocol SREditDelegate <NSObject>

@optional
//-(void)replaceItem:(id)oldObject withItem:(id)newObject;
-(void)updateItem:(id)anObject;
-(void)addItem:(id)newObject;
-(void)removeItem:(id)anObject;

@end
