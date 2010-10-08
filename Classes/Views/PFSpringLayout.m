//
//  PFSpringLayout.m
//  Pants-Framework
//
//  Created by Paul Alexander on 10/2/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "PFSpringLayout.h"


#define kIdealDifference    .5

@interface PFSpringNode : NSObject 
{
    UIView * view;
    CGPoint point;
    CGPoint delta;
    double mass;
    BOOL isPinned;
    
    NSMutableArray * connectedTo;
}

@property( nonatomic, retain ) UIView * view;
@property( nonatomic, assign ) CGPoint point;
@property( nonatomic, assign ) CGPoint delta;
@property( nonatomic, assign ) double mass;
@property( nonatomic, assign ) BOOL isPinned;
          
@property( nonatomic, readonly ) NSMutableArray * connectedTo;

@end




@implementation PFSpringLayout

@synthesize frame, spring, charge, damping;


-(id) init
{
    return [self initWithFrame: CGRectNull];
}

-(id) initWithFrame: (CGRect) newFrame 
{
    if( self = [super init] ) 
    {
        frame = newFrame;
        damping = .1;
        charge = 3;
        spring = 0;
        nodes = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) dealloc 
{
    SafeRelease( nodes );
    
    [super dealloc];
}


-(PFSpringNode *) nodeForView: (UIView *) view
{
    for( PFSpringNode * node in nodes )
        if( node.view == view )
            return node;

    
    PFSpringNode * node = [[PFSpringNode alloc] init];
    node.view = view;
    node.point = view.center;
    node.mass = MAX( CGRectGetWidth( view.frame ), CGRectGetHeight( view.frame ) );
    
    [nodes addObject: node];                     
    [node release];
    
    return node;
}

-(void) addView: (UIView *) view
{
    [self nodeForView: view];
}

-(void) repelFrom: (CGPoint) point withMass: (double) mass
{
    PFSpringNode * node = [[PFSpringNode alloc] init];
    node.point = point;
    node.mass = mass;
    [nodes addObject: node];
    [node release];
}

-(void) connectView: (UIView *) view toView: (UIView *) toView
{
    PFSpringNode * node = [self nodeForView: view];
    PFSpringNode * toNode = [self nodeForView: toView];
    
    [node.connectedTo addObject: toView];
    [toNode.connectedTo addObject: view];
}

-(void) connectAll
{
    for( int ix = 0; ix < nodes.count; ix++ )
    {
        PFSpringNode * node = [nodes objectAtIndex: ix];
        
        if( node.view == nil ) continue;
        
        for( int jx = ix + 1; jx < nodes.count; jx++ )
        {
            PFSpringNode * otherNode = [nodes objectAtIndex: jx];
            
            if( otherNode.view == nil ) continue;
            
            [node.connectedTo addObject: otherNode];
            [otherNode.connectedTo addObject: node];
        }
    }
}

-(void) connectAllByProximityToClosest: (NSInteger) closest
{       
    
    for( int ix = 0; ix < nodes.count; ix++ )
    {
        PFSpringNode * node = [nodes objectAtIndex: ix];
        [node.connectedTo removeAllObjects];
        
        for( int jx = 0; jx < nodes.count; jx++ )
        {
            if( ix == jx ) continue;
            
            PFSpringNode * otherNode = [nodes objectAtIndex: jx];
            
            if( node.connectedTo.count < closest )
                [node.connectedTo addObject: otherNode];
            else
            {
                double farthest = hypot( node.point.x - otherNode.point.x, node.point.y - otherNode.point.y );
                int farthestIndex = -1;
                
                
                for( int cx = 0; cx < node.connectedTo.count; cx++ )
                {
                    PFSpringNode * closestNode = [node.connectedTo objectAtIndex: cx];
                    
                    double distance = hypot( node.point.x - closestNode.point.x, node.point.y - closestNode.point.y );
                    if( distance > farthest )
                    {
                        farthestIndex = cx;
                        farthest = distance;
                    }
                }
                
                if( farthestIndex >= 0 )
                {
                    [node.connectedTo replaceObjectAtIndex: farthestIndex withObject: otherNode];
                }
            }            
        }
    }
}

-(void) joinNode: (PFSpringNode *) node toGridOfSize: (CGSize) size atX: (int) x andY: (int) y
{
    int index = ( y * size.width ) + ( x - 1 );
    if( index >= nodes.count )
        return;
    
    PFSpringNode * other = [nodes objectAtIndex: index];
    
    [node.connectedTo addObject: other];
    [other.connectedTo addObject: node];
}

-(void) connectAllByGridOfSize: (CGSize) size
{
    for( PFSpringNode * node in nodes )
        [node.connectedTo removeAllObjects];
    
    
    int x = 0;
    int y = 0;
    
    for( int ix = 0; ix < nodes.count; ix++ )
    {
        PFSpringNode * node = [nodes objectAtIndex: ix];
        
        if( x > 0 )
            [self joinNode: node toGridOfSize: size atX: x - 1 andY: y];
        
        if( x < size.width - 1 )
            [self joinNode: node toGridOfSize: size atX: x + 1 andY: y];
        
        
        if( y > 0 )
            [self joinNode: node toGridOfSize: size atX: x andY: y - 1];

        if( y < size.height - 1)
            [self joinNode: node toGridOfSize: size atX: x andY: y + 1];

        
        x++;
        if( x == size.width )
        {
            x = 0;
            y++;
        }    
    }
    
}

-(void) pinView: (UIView *) view
{
    PFSpringNode * node = [self nodeForView: view];
    node.isPinned = YES;
}

-(BOOL) layoutWithMaxIterations: (NSInteger) iterations
{
    BOOL idealLayout = YES;
    
    if( spring == 0 )
    {
        for( PFSpringNode * node in nodes )
        {
            if( ! node.view ) continue;
            
            CGFloat max = MAX( CGRectGetHeight( node.view.frame ), CGRectGetWidth( node.view.frame ) ) * 1.1;
            
            if( max > spring )
                spring = max;
        }
        
        spring = MAX( 1, spring );
    }
    
    CGFloat maxx = CGRectGetMaxX( frame );
    CGFloat maxy = CGRectGetMaxY( frame );
    CGFloat minx = CGRectGetMinX( frame );
    CGFloat miny = CGRectGetMinY( frame );
    
    CGFloat minDistance = FLT_MAX;
    
    
    for( int ix = 0; ix < iterations; ix++ )
    {
        idealLayout = YES;
        
        for( PFSpringNode * node in nodes )
        {
            if( node.isPinned ) continue;
            
            for( PFSpringNode * otherNode in nodes )
            {
                if( node == otherNode ) continue;
                
                double dx = otherNode.point.x - node.point.x;
                double dy = otherNode.point.y - node.point.y;
                double hyp = hypot( dx, dy );
                double force = 0;
                
                if( hyp < minDistance )
                    minDistance = hyp;

                if( [node.connectedTo indexOfObject: otherNode] != NSNotFound )
                    force = ( hyp - spring ) / 2.0;
                else
                {
                    double gravity = node.mass * otherNode.mass;
                    double power = pow( hyp, 2 );
                    
                    
                    force = -( gravity / power ) * charge;
                }
                
                dx /= hyp;
                dy /= hyp;
                
                dx *= force;
                dy *= force;
                
                node.delta = CGPointMake( node.delta.x + dx, node.delta.y + dy );
            }
            
            CGPoint newPoint = CGPointMake( MAX( minx, MIN( maxx, node.point.x + node.delta.x ) ), 
                                            MAX( miny, MIN( maxy, node.point.y + node.delta.y ) ) );
            
            if( abs( newPoint.x - node.point.x ) > kIdealDifference ||
                abs( newPoint.y - node.point.y ) > kIdealDifference )
                idealLayout = NO;            
            
            node.point = newPoint;
            node.delta = CGPointMake( node.delta.x * damping, node.delta.y * damping );
        }
        
        minDistance *= 1.25;
        if( minDistance > spring )
            idealLayout = YES;
        
        if( idealLayout )
            break;
        
    }
    
    // Centralize the grouping
    double cx = 0;
    double cy = 0;
    double cc = 0;
    
    for( PFSpringNode * node in nodes )
    {
        if( node.isPinned || node.view == nil ) continue;
        
        node.view.center = node.point;         
        cc++;
        cx += node.view.center.x;
        cy += node.view.center.y;
    }
    
    cx /= cc;
    cy /= cc;
    
    CGPoint frameCenter = CGPointMake( CGRectGetMinX( frame ) + ( CGRectGetMaxX( frame ) - CGRectGetMinX( frame ) ) / 2,
                                       CGRectGetMinY( frame ) + ( CGRectGetMaxY( frame ) - CGRectGetMinY( frame ) ) / 2 );
    
    cx = frameCenter.x - cx;
    cy = frameCenter.y - cy;

    for( PFSpringNode * node in nodes )
    {
        if( node.isPinned || node.view == nil ) continue;
        
        node.view.center = CGPointMake( ceil( node.view.center.x + cx ), ceil( node.view.center.y + cy ) );
    }
    
    return idealLayout;
}


@end




@implementation PFSpringNode

@synthesize view, point, delta, mass, connectedTo, isPinned;

-(void) dealloc 
{
    SafeRelease( view );
    SafeRelease( connectedTo );
    
    [super dealloc];
}

-(id) init
{
    if( self = [super init] )
    {
        connectedTo = [[NSMutableArray alloc] init];
    }
    
    return self;
}


@end