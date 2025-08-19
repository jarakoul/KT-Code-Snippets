// Gaussian Random Number Generation with the Box-Muller Transform
// License: CC0 - Public Domain, no warranty
// https://creativecommons.org/publicdomain/zero/1.0/legalcode
//
// Math reference: https://www.statisticshowto.com/box-muller-transform-simple-definition/
//
// Generate random numbers that behaves along a normal curve using the specified
// mean and standard deviation (as opposed to the linear randomness of llFRand())
// 
// Functions ready to be copied and pasted to scripts where you want them.


//
// Functions for copying:
//


//
// float gRand( float mean, float sd )
//  Generate a random number using the polar form of the Box-Muller Transform
//  The numbers will be centered around mean, and sd determines how tightly grouped
//  they are, a low sd will result in a very tight grouping, high will be wide
//
//  Note: code in the assorted gRand* functions are repeated, so you can copy any of them
//  independently without having to worry about copying code you don't need.  If maintaining
//  multiple functions, make sure to update them all.
//
float gRand( float mean, float sd )
{
    // Early out for no standard deviation
    if ( sd == 0 )      return mean;
    
    float u;            // First random number
    float v;            // Second random number
    float r;            // Radius squared of (u,v) from center (0,0)

    // Repeat until we get a (u,v) pair that is within 1 unit of (0,0)    
    do {
        u = llFrand(2) - 1;     // Linear random between -1 and 1
        v = llFrand(2) - 1;     // Linear random between -1 and 1
        r = u*u + v*v;          // How far are we from (0,0)
    } while ( r >= 1 );

    // Do the preliminary transformation
    float t = llSqrt( -2 * llLog(r)/r );
    
    // Adjust to mean and sd and return
    return mean + u * sd * t;
}


//
// vector gRandXY( float mean, float sd )
//  Generate a pair of random numbers using the polar form of the Box-Muller Transform
//  The numbers will be centered around mean, and sd determines how tightly grouped
//  they are, a low sd will result in a very tight grouping, high will be wide
//  These numbers are returned as the X and Y coordinates of a vector ( Z = 0.0 )
//
//  Note: code in the assorted gRand* functions are repeated, so you can copy any of them
//  independently without having to worry about copying code you don't need.  If maintaining
//  multiple functions, make sure to update them all.
//
//  Note 2: This is the purest form of the gRand* functions, since the Box-Muller Transform
//  produces random numbers in pairs anyway. If you want the others without
//  duplicating needless code, copy this one, and use the following:
//
//
vector gRandXY( float mean, float sd )
{
    vector vec = ZERO_VECTOR;

    // Early out for no standard deviation, return <mean, mean, 0.0>
    if ( sd == 0 ) {
        vec.x   = mean;
        vec.y   = mean;
        return vec;
    }
    
    float u;            // First linear random number
    float v;            // Second linear random number
    float r2;           // Radius squared of (u,v) from center (0,0)

    // Repeat until we get a (u,v) pair that is within 1 unit of (0,0)    
    do {
        u = llFrand(2) - 1;     // Linear random between -1 and 1
        v = llFrand(2) - 1;     // Linear random between -1 and 1
        r2 = u*u + v*v;          // How far are we from (0,0)
    } while ( r2 >= 1 );

    // Calculate the transformation
    float t = llSqrt( -2 * llLog(r2)/r2 );
    
    // Adjust u & v to mean and sd, load them in the vector and return
    vec.x = mean + u * sd * t;
    vec.y = mean + v * sd * t;
    return vec;
}



//
// float bounds( float n, float lower, float upper)
//  Constrain n between the specified lower and upper boundaries
//
float bounds( float n, float lower, float upper )
{
    // Early out for upper <= lower, return the actual lower end of the boundary
    if ( upper <= lower )   return upper;
    
    if ( n < lower )        return lower;       // n below the bounds
    if ( n > upper )        return upper;       // n above the bounds
    return n;                                   // n is fine
}


//
// float listMean( list l )
//  Traverse a list of floats and return the calculated mean
//
float listMean( list l )
{
    integer len     = llGetListLength( l );     // How long is the list?
    if ( len <= 0 )     return 0.0;             // Early out for empty lists

    float   total   = 0.0;                      // Sum of the list, start with 0.0
    integer i       = 0;                        // Iterator through the list
    
    // Sum up the list
    for ( i=0; i<len; i++ ) {
        total += llList2Float( l, i );          // Add in this element
    }
    
    // Calculate and return the mean
    return ( total / len );
}



//
// Constants:
//  These constants are only used for testing with the event handler of this script, they
//  do not affect the above functions.  The functions should be safe to copy and paste into
//  your own works, and are all CC0 so you can do so without worrying about your own
//  licensing.
//

float   m   = 0.3;      // The mean to use
float   d   = 0.1;      // The standard deviation to use
integer n   = 10;       // The batch size to generate



//
// Event Handlers:
//  Here's a place to test and demonstrate these functions.  When reusing them elsewhere,
//  copy the functions, not this space.
//

default
{
    state_entry()
    {
        llOwnerSay( "Reset" );
    }

    touch_start(integer total_number)
    {
        list    l   = [];
        integer i   = 0;
        
        for ( i=0; i<n; i++ ) {
            l += bounds( gRand(m,d), 0, 1);     // Add a gaussian random constrained 0<=n<=1
        }
        
        llOwnerSay( "\n\n" + llDumpList2String(l,", ") );
        llOwnerSay( "Mean: " + (string)listMean(l) + "\n\n" );
    }
}
