/*
 * Utility functions.
 * 
 * Originally by Hans Häggström, 2010.
 * Licenced under Creative Commons Attribution-Share Alike 3.0.
 */

function distance(a, b) = sqrt( (a[0] - b[0])*(a[0] - b[0]) + 
                                (a[1] - b[1])*(a[1] - b[1]) + 
                                (a[2] - b[2])*(a[2] - b[2]) );

function length2(a) = sqrt( a[0]*a[0] + a[1]*a[1] );

function normalized(a) = a / (max(distance([0,0,0], a), 0.00001));



function angleOfNormalizedVector(n) = [0, -atan2(n[2], length2([n[0], n[1]])), atan2(n[1], n[0]) ];

function angle(v) = angleOfNormalizedVector(normalized(v));

function angleBetweenTwoPoints(a, b) = angle(normalized(b-a));
