//
//  JTModel.h
//  Jeetrium
//
//

#import <Foundation/Foundation.h>

@protocol JTModelDelegate;

@interface JTModel : NSObject
{
    BOOL                        _isLoaded;
    BOOL                        _isLoading;
    BOOL                        _isLoadingMore;
    BOOL                        _isOutdated;
    BOOL                        _hasChanged;
    
    NSArray                     *_dataObjects;
    __weak id<JTModelDelegate>  _delegate;
}

@property (nonatomic)   BOOL    isLoaded;
@property (nonatomic)   BOOL    isLoading;
@property (nonatomic)   BOOL    isLoadingMore;
@property (nonatomic)   BOOL    isOutdated;
@property (nonatomic)   BOOL    hasChanged;

@property (nonatomic, readonly)     NSArray                     *dataObjects;
@property (nonatomic, weak)         __weak id<JTModelDelegate>  delegate;


-(id)initWithDelegate:(id<JTModelDelegate>)delegate;
-(void)load;
-(void)refresh;
-(void)didLoad;
-(void)changed;
-(void)changedWithItems:(NSArray*)newItems;
-(void)unload;

-(void)addObject:(id)object;
-(void)updateObject:(id)anObject;
-(void)removeObject:(id)anObject;
-(void)removeObjectAtIndex:(NSUInteger)index;
-(void)insertObject:(id)anObject AtIndex:(NSUInteger)index;
-(void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
-(void)replaceObject:(id)anObject withObject:(id)newObject;


@end


@protocol JTModelDelegate <NSObject>
@optional
    -(void)modelIsLoading:(JTModel*)model; 
    -(void)modelWillLoad:(JTModel*)model; 
    -(void)modelDidLoad:(JTModel*)model; 
    -(void)modelChanged:(JTModel*)model; 
    -(void)modelChanged:(JTModel*)model withItems:(NSArray*)newItems;
    -(void)modelError:(JTModel*)model; 
@end
