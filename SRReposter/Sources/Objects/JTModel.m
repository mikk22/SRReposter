//
//  JTModel.m
//  Jeetrium
//
//

#import "JTModel.h"

@implementation JTModel

@synthesize isLoaded=_isLoaded;
@synthesize isLoading=_isLoading;
@synthesize isLoadingMore=_isLoadingMore;
@synthesize isOutdated=_isOutdated;
@synthesize hasChanged=_hasChanged;

@synthesize dataObjects=_dataObjects;
@synthesize delegate=_delegate;



-(void)dealloc
{
    _dataObjects=nil;
}

-(id)initWithDelegate:(id<JTModelDelegate>)delegate
{
    self=[super init];
    if (self)
    {
        self.delegate=delegate;
    }
    
    return self;
}


#pragma mark -
#pragma mark - Properties

-(NSArray*)dataObjects
{
    if (!_dataObjects)
        _dataObjects=[NSArray array];
    
    return _dataObjects;
}


-(void)load
{
    self.isLoading=YES;    
    if ([self.delegate respondsToSelector:@selector(modelWillLoad:)])
        [self.delegate modelWillLoad:self];
    
    if ([self.delegate respondsToSelector:@selector(modelIsLoading:)])
        [self.delegate modelIsLoading:self];
}



-(void)refresh
{
    [self changedWithItems:[NSArray array]];
}



-(void)unload
{
    _dataObjects=nil;
    self.isLoaded=NO;
}





-(void)didLoad
{
    self.isLoading=NO;
    self.isLoaded=YES;
    
    if ([self.delegate respondsToSelector:@selector(modelDidLoad:)])
        [self.delegate modelDidLoad:self];
    if ([self.delegate respondsToSelector:@selector(modelChanged:)])
        [self.delegate modelChanged:self];
}


-(void)changed
{
    if ([self.delegate respondsToSelector:@selector(modelChanged:)])
        [self.delegate modelChanged:self];
    
    self.hasChanged=YES;
}

-(void)changedWithItems:(NSArray*)newItems
{
    if ([self.delegate respondsToSelector:@selector(modelChanged:withItems:)])
        [self.delegate modelChanged:self withItems:newItems];
}



-(void)addObject:(id)object
{
    _dataObjects=[self.dataObjects arrayByAddingObject:object];
    //[self changedAtIndexes:[NSIndexSet indexSetWithIndex:(_dataObjects.count-1)]];
    [self changed];
}


-(void)removeObjectAtIndex:(NSUInteger)index
{
    if (index<self.dataObjects.count)
    {
        NSMutableArray *mutableDataObjects=[NSMutableArray arrayWithArray:self.dataObjects];
        [mutableDataObjects removeObjectAtIndex:index];
        _dataObjects=[NSArray arrayWithArray:mutableDataObjects];
        [self changed];
    }
}


-(void)updateObject:(id)anObject
{
    //implement in subclass
    [self changed];
}


-(void)removeObject:(id)anObject
{
    if (anObject)
    {
        NSMutableArray *mutableDataObjects=[NSMutableArray arrayWithArray:self.dataObjects];
        [mutableDataObjects removeObject:anObject];
        _dataObjects=[NSArray arrayWithArray:mutableDataObjects];
        [self changed];
    }
}

-(void)insertObject:(id)anObject AtIndex:(NSUInteger)index
{
    if (index<self.dataObjects.count && anObject)
    {
        NSMutableArray *mutableDataObjects=[NSMutableArray arrayWithArray:self.dataObjects];
        [mutableDataObjects insertObject:anObject atIndex:index];
        _dataObjects=[NSArray arrayWithArray:mutableDataObjects];
        [self changed];
    }
}


-(void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject 
{
    if (index<self.dataObjects.count && anObject)
    {
        NSMutableArray *mutableDataObjects=[NSMutableArray arrayWithArray:self.dataObjects];
        [mutableDataObjects replaceObjectAtIndex:index withObject:anObject];
        _dataObjects=[NSArray arrayWithArray:mutableDataObjects];
        [self changed];
    }
}


-(void)replaceObject:(id)anObject withObject:(id)newObject
{
    if (newObject && anObject)
    {
        NSUInteger oldObjIndex=[self.dataObjects indexOfObject:anObject];
        
        if (oldObjIndex!=NSNotFound)
        {
            NSMutableArray *mutableDataObjects=[NSMutableArray arrayWithArray:self.dataObjects];
            [mutableDataObjects replaceObjectAtIndex:oldObjIndex withObject:newObject];
            _dataObjects=[NSArray arrayWithArray:mutableDataObjects];
            [self changed];
        } else
        {
            DLog(@"OBJECT %@ NOT FOUND",anObject);
        }
    }
}


@end
