function array_rotate_left(ary, by) = let(
	boundedBy = ((by % len(ary)) + len(ary)) % len(ary) // Handle out of bounds and negatives
) (boundedBy == 0 || by == undef) ? ary : concat(
	[for (i=[boundedBy:len(ary)-1]) ary[i]],
	[for (i=[0:boundedBy-1]) ary[i]]
); 

function arrays_rotate_left(arys, bys, i=0) = (i < len(arys))
	? concat([array_rotate_left(arys[i], bys[i])], arrays_rotate_left(arys, bys, i+1))
	: [];
	
function offset_radius(v, r) = v + v * (r / norm(v)); 

function num(v) = v == undef ? 0 : v;
function v2(a,b) = (b == undef) ? (a[1]==undef?[a,a]:[num(a[0]), num(a[1])]) : [a,b];
function v3(a,b,c) = (b == undef) ? (a[1]==undef?[a,a,a]:[num(a[0]), num(a[1]), num(a[2])]) : [a,b,c];

function v2_points(points, i=0) = (i < len(points))
	? concat([v2(points[i])], v2_points(points, i+1))
	: [];
function v3_points(points, i=0) = (i < len(points))
	? concat([v3(points[i])], v3_points(points, i+1))
	: [];

function dist(a, b) = norm(b - a);

function m_translate(v) = [ [1, 0, 0, 0],
                            [0, 1, 0, 0],
                            [0, 0, 1, 0],
                            [v.x, v.y, v.z, 1  ] ];
                            
function m_rotate(v) =  [ [1,  0,         0,        0],
                          [0,  cos(v.x),  sin(v.x), 0],
                          [0, -sin(v.x),  cos(v.x), 0],
                          [0,  0,         0,        1] ]
                      * [ [ cos(v.y), 0,  -sin(v.y), 0],
                          [0,         1,  0,        0],
                          [ sin(v.y), 0,  cos(v.y), 0],
                          [0,         0,  0,        1] ]
                      * [ [ cos(v.z),  sin(v.z), 0, 0],
                          [-sin(v.z),  cos(v.z), 0, 0],
                          [ 0,         0,        1, 0],
                          [ 0,         0,        0, 1] ];
						  
						  
function m_scale(v) = [ [v.x, 0, 0, 0],
                        [0, v.y, 0, 0],
                        [0, 0, v.z, 0],
                        [0, 0, 0, 1  ] ];
                            
function vec3(v) = [v.x, v.y, v.z];
function transform(vec3, mat4) = let(
    vec3 = v3(vec3),
    vec4 = [vec3[0], vec3[1], vec3[2], 1],
    result = mat4_transpose(mat4) * vec4
) [result[0], result[1], result[2]];

                            
function matrix_to(p0, p) = 
                       m_rotate([0, atan2(norm([p.x, p.y]), p.z), 0]) 
                     * m_rotate([0, 0, atan2(p.y, p.x)]) 
                     * m_translate(p0);

function matrix_from(p0, p) = 
                      m_translate(-p0)
                      * m_rotate([0, 0, -atan2(p.y, p.x)]) 
                      * m_rotate([0, -atan2(norm([p.x, p.y]), p.z), 0]); 
					  
function mat4_transpose(m) = [
	[m[0][0], m[1][0], m[2][0], m[3][0]],
	[m[0][1], m[1][1], m[2][1], m[3][1]],
	[m[0][2], m[1][2], m[2][2], m[3][2]],
	[m[0][3], m[1][3], m[2][3], m[3][3]]
];

module transform(m) { multmatrix(mat4_transpose(m)) children(); }

function transform_points(list, matrix, i = 0) = 
    i < len(list) 
       ? concat([ transform(list[i], matrix) ], transform_points(list, matrix, i + 1))
       : [];


//  convert from point indexes to point coordinates

function as_points(indexes,points,i=0) =
     i < len(indexes) 
        ?  concat([points[indexes[i]]], as_points(indexes,points,i+1))
        : [];

//  basic vector functions
function normal_r(face) =
     cross(face[1]-face[0],face[2]-face[0]);

function normal(face) =
     - normal_r(face) / norm(normal_r(face));

function centre(points) = 
      vsum(points) / len(points);

// sum a list of vectors
function vsum(points, i=0, count) =
      let(count = count == undef ? len(points) : count)
      i < count
        ?  (points[i] + vsum(points,i+1,count))
        :  (points[0] - points[0]) /* cheater way of getting zero when we don't know the dimension of the vector */;
		
function vavg(points) = vsum(points) / len(points);

function ssum(list, i=0, count=len(list)) =
      i < count
        ?  (list[i] + ssum(list,i+1))
        :  0;


// add a vector to a list of vectors
function vadd(points,v,i=0) =
      i < len(points)
        ?  concat([points[i] + v], vadd(points,v,i+1))
        :  [];

function reverse_r(v,n) =
      n == 0 
        ? [v[0]]
        : concat([v[n]],reverse_r(v,n-1));

function reverse(v) = reverse_r(v, len(v)-1);

function sum_norm(points,i=0) =
    i < len(points)
       ?  norm(points[i]) + sum_norm(points,i+1)
       : 0 ;

function average_radius(points) =
       sum_norm(points) / len(points);


// select one dimension of a list of vectors
function slice(v,k,i=0) =
   i <len(v)
      ?  concat([v[i][k]], slice(v,k,i+1))
      : [];

function max(v, max=-9999999999999999,i=0) =
     i < len(v) 
        ?  v[i] > max 
            ?  max(v, v[i], i+1 )
            :  max(v, max, i+1 ) 
        : max;

function min(v, min=9999999999999999,i=0) =
     i < len(v) 
        ?  v[i] < min 
            ?  min(v, v[i], i+1 )
            :  min(v, min, i+1 ) 
        : min;

function project(pts,i=0) =
     i < len(pts)
        ? concat([[pts[i][0],pts[i][1]]], project(pts,i+1))
        : [];
        
function contains(n, list, i=0) =
     i < len(list) 
        ?  n == list[i]
           ?  true
           :  contains(n,list,i+1)
        : false;

// normalize the points to have origin at 0,0,0 
function centre_points(points) = 
     vadd(points, - centre(points));

//scale to average radius = radius
function normalize(points, radius=1) =
    points * radius /average_radius(points);
	
function normalize_point(pt, r=1) = normalize([pt], r)[0];
 
function triangle(a,b) = norm(cross(a,b))/2;

function modulate_point(p) =
    spherical_to_xyz(fs(xyz_to_spherical(p)));

function modulate_points(points,i=0) =
   i < len(points)
      ? concat([modulate_point(points[i])],modulate_points(points,i+1))
      : [];

function xyz_to_spherical(p) =
    [ norm(p), acos(p.z/ norm(p)), atan2(p.x,p.y)] ;

function spherical_to_xyz_full(r,theta,phi) =
    [ r * sin(theta) * cos(phi),
      r * sin(theta) * sin(phi),
      r * cos(theta)];

function spherical_to_xyz(s) =
     spherical_to_xyz_full(s[0],s[1],s[2]);
                          
module orient_to(centre, normal) {   
      translate(centre)
      rotate([0, 0, atan2(normal[1], normal[0])]) //rotation
      rotate([0, atan2(sqrt(pow(normal[0], 2)+pow(normal[1], 2)),normal[2]), 0])
      children();
}

function orient_to_matrix(centre, normal) =
	m_rotate([0, atan2(sqrt(pow(normal[0], 2)+pow(normal[1], 2)),normal[2]), 0]) *
	m_rotate([0, 0, atan2(normal[1], normal[0])]) *
	m_translate(centre)
;

module orient_from(centre, normal) {   
      rotate([0, -atan2(sqrt(pow(normal[0], 2)+pow(normal[1], 2)),normal[2]), 0])
      rotate([0, 0, -atan2(normal[1], normal[0])]) //rotation
      translate(-centre)
      children();
}

function orient_from_matrix(centre, normal) =
	m_translate(-centre) *
	m_rotate([0, 0, -atan2(normal[1], normal[0])]) *
	m_rotate([0, -atan2(sqrt(pow(normal[0], 2)+pow(normal[1], 2)),normal[2]), 0])
;
              
module make_edge(edge, points, r) {
    assign(p0 = points[edge[0]], p1 = points[edge[1]])
        assign(v = p1 -p0)
        orient_to(p0,v)
        cylinder(r=r, h=norm(v));
}

module make_edges(points, edges, r) {
   for (i = [0:len(edges)-1])
      make_edge(edges[i],points, r);
}

module make_vertices(points,r) { 
   for (i = [0:len(points)-1])
      translate(points[i]) sphere(r); 
}


module axes(l=[5,10,15]) {
    color("blue") cylinder(r=1,h=l.z);
    color("red") rotate([0,90,0]) cylinder(r=1,h=l.x);
    color("green") rotate([-90,0,0]) cylinder(r=1,h=l.y);
}
////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////
function remove(list, removeI, i=0) = (i >= len(list))
    ? []
    : concat(i==removeI?[]:[list[i]], remove(list, removeI, i+1));
    
function det(m) = let(r=[for(i=[0:1:len(m)-1]) i]) det_help(m, 0, r);
function det_help(m, i, r) = len(r) == 0 ? 1 :
 m[len(m)-len(r)][r[i]]*det_help(m,0,remove(r,i)) - (i+1<len(r)?
det_help(m, i+1, r) : 0);

function matrix_invert(m) = let(r=[for(i=[0:len(m)-1]) i]) [for(i=r)
[for(j=r)
 ((i+j)%2==0 ? 1:-1) * matrix_minor(m,0,remove(r,j),remove(r,i))]] / det(m);
function matrix_minor(m,k,ri, rj) = let(len_r=len(ri)) len_r == 0 ? 1 :
 m[ri[0]][rj[k]]*matrix_minor(m,0,remove(ri,0),remove(rj,k)) -
(k+1<len_r?matrix_minor(m,k+1,ri,rj) : 0);

////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

function flatten(input, output, i=0) = 
    i >= len(input)
        ? []
        : concat(input[i], flatten(input, output, i+1));

function interpolateScalar(a, b, f) = a + (b-a) * f;
function interpolateInches(a, b, f) = inches(a + (b-a) * f);
function inches(in) = in * 25.4;
function feet(ft) = inches(ft * 12);
function cot(x) = 1 / tan(x);
function csc(x) = 1 / sin(x);
function sec(x) = 1 / cos(x);
function polyCircumRadiusForSideLength(sides, sideLength) = (1/2) * sideLength * csc(180 / sides); 
function polyInRadiusForSideLength(sides, sideLength) = (1/2) * sideLength * cot(180 / sides); 
function polarPoint2(r, theta) = [r * cos(theta), r * sin(theta)];
function polySideLengthForInRadius(r, sides) = 2 * r * tan(180 / sides);

function triangleRadiusForSideLengthAndCornerRadius(
	sideLength,
	cornerRadius
) = let (
	r = cornerRadius,
	R = (1/3) * sqrt(3) * sideLength,
	C = r / tan(30),
	c = (PI * r) / 3
) R + (C - c) / cos(30);

function m_translate2(v) = [ [1,   0,   v.x],
                             [0,   1,   v.y],
                             [0,   0,   1] ];
                            
function m_rotate2(v) =  [ [cos(v), -sin(v), 0],
                           [sin(v), cos(v),  0],
                           [0,      0,       1] ];
						  
						  
function m_scale2(v) = [ [v.x, 0,   0],
                         [0,   v.y, 0],
                         [0,   0,   1] ];
                            
function vec2(v) = [v.x, v.y];

function transform2(vec2, mat3) = let(
    vec3 = [vec2.x, vec2.y, 1],
    result = mat3 * vec3
) [result[0], result[1]];

function transform_points2(list, matrix, i = 0) = 
    i < len(list) 
       ? concat([ transform2(list[i], matrix) ], transform_points2(list, matrix, i + 1))
       : [];

function interpolateLinePoints(a, b, f) = let(
	d = norm(b-a),
	n = (b - a) / d
) a + n * d * f;

////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

module offsetOutline2(r2, r1=0) {
	difference() {
		offset(r1) children();
		offset(r2) children();
	}
}

module csquareOutline(
	size,
	widthParam,
	center=false,
	r=0
) {
	centerFraction = (center == true) ? ([-.5,-.5,-.5]) : (center == false ? [0,0,0] : [center.x, center.y, center.z]);
	centerOffset = [size.x*centerFraction.x, size.y*centerFraction.y, size.z*centerFraction.z];
	
	extruded = size.z > 0;
	widthVec = extruded ? v3(widthParam) : v2(widthParam);

	if (widthVec.x < 0 || widthVec.y < 0) {
		translate(centerOffset) difference() {
			translate(widthVec) csquare(size-widthVec*2, r=r);
			csquare(size, r=r);
		}
	} else {
		translate(centerOffset) difference() {
			csquare(size, r=r);
			translate(widthVec) csquare(size-widthVec*2, r=r);
		}
	}
}

module csquare(
	size, 
	center=false, 
	r=0, 
	edgeSegmentLength = 1,
	
	flatBottom = false,
	flatLeft = false,
	flatRight = false,

	cncHole = false
) {
	centerFraction = (center == true) ? ([-.5,-.5,-.5]) : (center == false ? [0,0,0] : [center.x, center.y, center.z]);
	centerOffset = [size.x*centerFraction.x, size.y*centerFraction.y, size.z*centerFraction.z];
	cncDogEarInset = sqrt(pow($cncBitDiameter/2, 2) / 2);

	$fn = max(8, ceil($fn/4)*4);

	if (cncHole && $cncBitDiameter && $cncHoleMode == "expand") {
		expandBy = $cncBitDiameter/2 - cncDogEarInset;
		newSize = size + v2(expandBy*2);

		translate(centerOffset + v2(-expandBy)) csquare(
			size = newSize,
			center = false,
			r = r,
			edgeSegmentLength = edgeSegmentLength,
			flatBottom = flatBottom,
			flatLeft = flatLeft,
			cncHole = false
		);
	} else {
		if (size.z == 0 || size.z == undef) {
			squarePart();
		} else {
			translateZ(centerOffset.z) linear_extrude(size.z) squarePart();
		}
	}

	module squarePart() {
			translate(v2(centerOffset)) {
				if (r > 0) {
					union() {
						if (!flatBottom && !flatLeft) translate([r,r]) circle(r=r);
						if (!flatBottom && !flatRight) translate([size.x-r,r]) circle(r=r);
						if (!flatRight) translate([size.x-r,size.y-r]) circle(r=r);
						if (!flatLeft) translate([r,size.y-r]) circle(r=r);

						translate([0,flatBottom?0:r]) square([size.x, size.y-(flatBottom?r:r*2)]);
						translate([flatLeft?0:r,0]) square([size.x-(flatLeft?0:r)-(flatRight?0:r), size.y]);
					}
				} else {
					square([size.x, size.y]);
				}

				if (cncHole && $cncBitDiameter && $cncHoleMode == "dogEars") {
					translate([     0,      0] + [ cncDogEarInset,  cncDogEarInset]) circle(d=$cncBitDiameter);
					translate([     0, size.y] + [ cncDogEarInset, -cncDogEarInset]) circle(d=$cncBitDiameter);
					translate([size.x, size.y] + [-cncDogEarInset, -cncDogEarInset]) circle(d=$cncBitDiameter);
					translate([size.x,      0] + [-cncDogEarInset,  cncDogEarInset]) circle(d=$cncBitDiameter);
				}
			}
		}
}

module roundedTriangle(
	circumRadius,
	cornerRadius,
	middlePoints = []
) {
	cornerInset = cornerRadius / sin(30);
	tangentDistanceFromPoint = cornerRadius / tan(30);
	inRadius = circumRadius * sin(30);
	
	curveSegmentLength = 1;
	$fn = ceil(((PI * cornerRadius) / 3) / curveSegmentLength) * 6;
	
	module main_part() {
		polygon(flatten([
			for (i=[0:2]) let(pointTheta = i * 120) [
				(polarPoint2(circumRadius, pointTheta) + polarPoint2(tangentDistanceFromPoint, pointTheta - 150)),
				(polarPoint2(circumRadius, pointTheta) + polarPoint2(tangentDistanceFromPoint, pointTheta + 150))
			]
		]));
	}
	
	if (cornerRadius > 0) difference() {
		for(i=[0:2]) rotate([0,0,120*i]) translate([circumRadius - cornerInset, 0]) circle(r=cornerRadius);
		main_part();
	}
	polygon(flatten([
		for (i=[0:2]) let(pointTheta = i * 120) concat([
			(polarPoint2(circumRadius, pointTheta) + polarPoint2(tangentDistanceFromPoint, pointTheta - 150)),
			(polarPoint2(circumRadius, pointTheta) + polarPoint2(tangentDistanceFromPoint, pointTheta + 150))
		], transform_points2(transform_points2(middlePoints, m_rotate2(i*120-30)), m_translate2(polarPoint2(inRadius, i * 120 + 60))))
	]));
}


module inradiusCylinder(
    r,
    r2,
    h,
	side = false,
    center=false,
    $fn=undef
) {
    rotate(side?(360/$fn/2):0) cylinder(
        r=r / cos(180/$fn), 
        r2=r2 == undef ? undef : r2 / cos(180/$fn), 
        h=h, 
        center=center, 
		$fn=$fn
    );
}

function inRadiusForCircum(r, sides = $fn) = r * cos(180/sides);
function circumRadiusForIn(r, sides = $fn) = r / cos(180/sides);

module circumRadiusPolygon(
	r,
	sides
) {
	circle(
        r=r,
		$fn=sides
    );
}

module inradiusPolygon(
	r,
	sides
) {
	circle(
        r=r / cos(180/sides), 
		$fn=sides
    );
}

module sphereCap(r, h) {
	R = (h*h+r*r)/(2*h);
	
	intersection() {
		translate([0,0,-R+h]) rotateX(90) sphere(R);
		translateZ(h/2) cube([r*3,r*3,h], center=true);
	}
}

module round2d(r) {
	if ($freeCAD == true) {
		//echo("FreeCAD: round2d disabled");
		children();
	}
	else {
		offset(r) offset(-r) children();
	}
}
module fillet2d(r) {
	if ($freeCAD == true) {
		//echo("FreeCAD: fillet2d disabled");
		children();
	}
	else {
		offset(-r) offset(r) children();
	}
}

module safeText(s, size, halign, valign) {
	if ($freeCAD == true) {
		//echo("FreeCAD: text disabled", s);
	}
	else text(s, size=size, halign=halign, valign=valign);
}

function radiusOnPoly(a, r, sides) = let(
	inRadius = r * cos(180/sides),
	degPerSide = 360 / sides,
	degFromSideEdge = a % degPerSide,
	degFromSideCenter = degFromSideEdge - degPerSide/2,
	r = inRadius / cos(degFromSideCenter)
) r;

module roundedPolygon(sides, radius, cornerRadius, $fn=50) {
	difference() {
		circle(r=radius, $fn=sides);
		
		if (cornerRadius > 0) {
			for (i=[0:sides-1]) rotate(i*360/sides) difference() {
				translate([radius,0]) circle(r=sin(360/sides/2)*cornerRadius);	
				translate([radius - cornerRadius,0]) circle(r=cos(360/sides/2)*cornerRadius);
			}
		}
	}
}


module cmRefSquare(showText = true) {
    difference() {
        square([10,10],center=true);
		if (showText)
			translate([0,0]) text("1cm", size=3.8, halign="center", valign="center");
    }
}

module placeOnFace(points, face, invert = false) {
    placeOnFaceAtPoint(
        points,
        face,
        centre(as_points(face, points)),
        invert
    ) children();
}

function normalize_point(pt,r=1) = normalize([pt],r)[0];

function placeOnFaceAtPointMatrix(points, face, center) = let(
    expFace = as_points(face, points),
    
    v1 = expFace[1] - expFace[0],
    v2 = expFace[2] - expFace[0],
            
    kPrime = normalize_point(cross(v1, v2)),
    jPrime = normalize_point(expFace[0] - center),
    iPrime = normalize_point(cross(jPrime, kPrime)),

    transformMatrix = [
        [iPrime[0], jPrime[0], kPrime[0], center[0]],
        [iPrime[1], jPrime[1], kPrime[1], center[1]],
        [iPrime[2], jPrime[2], kPrime[2], center[2]],
        [0, 0, 0,  1]
    ]
) transformMatrix;

module placeOnFaceAtPoint(points, face, center, invert = false) {
    transformMatrix = placeOnFaceAtPointMatrix(points, face, center);
	expFace = as_points(face, points);
	v1 = expFace[1] - expFace[0];
    v2 = expFace[2] - expFace[0];
        
    // The mirror here handles the case where the vertices are in an order that would send Z towards, rather than away from, the origin
    if (invert) {
        mirror([0,0,norm(transformMatrix*[0,0,1,1]) < norm(transformMatrix*[0,0,0,1])?1:0])
            multmatrix(matrix_invert(transformMatrix)) {
            children();
            // # cylinder(r=2,h=50);
            // rotate([90,0,0]) cylinder(r=2,h=200,center=true);
        }
    } else {
        multmatrix(transformMatrix) 
            mirror([0,0,norm(transformMatrix*[0,0,1,1]) < norm(transformMatrix*[0,0,0,1])?1:0]) {
            children();
            // # cylinder(r=2,h=50);
            // rotate([90,0,0]) cylinder(r=2,h=200,center=true);
        }
    }
}

module placeOnFaceEdge(points, face, edge = 0) {
	face = faces[6];
	a = points[face[(0+edge)%len(face)]];
	b = points[face[(1+edge)%len(face)]];
	c = points[face[(2+edge)%len(face)]];

	ctr = centre([a,b,c]);
	t = (b+a)/2;

	zPrime = normalize_point(t);
	xPrime = normalize_point(t-a);
	yPrime = normalize_point(cross(xPrime, zPrime));

	multmatrix([
		[xPrime.x,yPrime.x,zPrime.x,t.x],
		[xPrime.y,yPrime.y,zPrime.y,t.y],
		[xPrime.z,yPrime.z,zPrime.z,t.z],
		[1,1,1,1],
	]) children();
}

module translateX(x=0, y=0, z=0) { translate([x, y, z]) children(); }
module translateY(y=0, x=0, z=0) { translate([x, y, z]) children(); }
module translateZ(z=0, x=0, y=0) { translate([x, y, z]) children(); }

module rotateX(x=0, y=0, z=0) { rotate([x, y, z]) children(); }
module rotateY(y=0, x=0, z=0) { rotate([x, y, z]) children(); }
module rotateZ(z=0, x=0, y=0) { rotate([x, y, z]) children(); }

module mirrorX(x=0, y=0, z=0) { mirror([x, y, z]) children(); }
module mirrorY(y=0, x=0, z=0) { mirror([x, y, z]) children(); }
module mirrorZ(z=0, x=0, y=0) { mirror([x, y, z]) children(); }

module translateX_opt(x=0, y=0, z=0) { if ($extrude) { translate([x, y, z]) children(); } else { children(); } }
module translateY_opt(y=0, x=0, z=0) { if ($extrude) { translate([x, y, z]) children(); } else { children(); } }
module translateZ_opt(z=0, x=0, y=0) { if ($extrude) { translate([x, y, z]) children(); } else { children(); } }

module rotateX_opt(x=0, y=0, z=0) { if ($extrude) { rotate([x, y, z]) children(); } else { children(); } }
module rotateY_opt(y=0, x=0, z=0) { if ($extrude) { rotate([x, y, z]) children(); } else { children(); } }
module rotateZ_opt(z=0, x=0, y=0) { if ($extrude) { rotate([x, y, z]) children(); } else { children(); } }

module mirrorX_opt(x=0, y=0, z=0) { if ($extrude) { mirror([x, y, z]) children(); } else { children(); } }
module mirrorY_opt(y=0, x=0, z=0) { if ($extrude) { mirror([x, y, z]) children(); } else { children(); } }
module mirrorZ_opt(z=0, x=0, y=0) { if ($extrude) { mirror([x, y, z]) children(); } else { children(); } }

module linear_extrude_opt(h, scale=1, convexity = 2, center=false, z = 0) {
	if ($extrude) translate([0,0,z]) linear_extrude(h, scale=scale, center=center, convexity=convexity) children();
	else children();
}

// Adapted from http://www.thingiverse.com/thing:34027

module pieSlice(radius, angle, center=true) {
	count = max([$fn, angle/10]);
	
	rotate(center ? -angle/2 : 0)
	polygon(concat(
		[[0,0]],
		[ for (i = [0 : count]) [
			radius * cos(i * (angle/count)),
			radius * sin(i * (angle/count)),
		] ]
	));
}

module partial_rotate_extrude(angle, radius, convex) {
	intersection () {
		rotate_extrude(convexity=convex, $fn = (360 / angle) * $fn) translate([radius,0,0]) children();
		linear_extrude(radius*4, center=true)
			pieSlice(radius*2, angle);
	}
}

function polyInradius(sides, sideLength) = (1/2) * sideLength * cot(180 / sides);


function doHsvMatrix(h,s,v,p,q,t,a=1)=[h<1?v:h<2?q:h<3?p:h<4?p:h<5?t:v,h<1?t:h<2?v:h<3?v:h<4?q:h<5?p:p,h<1?p:h<2?p:h<3?t:h<4?v:h<5?v:q,a];
function hsv(h, s=1, v=1,a=1)=doHsvMatrix((h%1)*6,s<0?0:s>1?1:s,v<0?0:v>1?1:v,v*(1-s),v*(1-s*((h%1)*6-floor((h%1)*6))),v*(1-s*(1-((h%1)*6-floor((h%1)*6)))),a);

function triangleAreaFromPoints(points) = let(
	a = dist(points[0], points[1]),
	b = dist(points[1], points[2]),
	c = dist(points[2], points[0]),

	p = (a + b + c) / 2
	// Calculate area using Heron's Formula: http://www.mathopenref.com/heronsformula.html
) sqrt(p * (p - a) * (p - b) * (p - c));

function vectorAngle(u,v) = acos( (u*v) / (norm(u)*norm(v)) );

// Finds the intesection of two lines in 3d space, assuming they intersect. Returns undef otherwise.
function lineIntersection(a, b) = let(
	// From: https://math.stackexchange.com/questions/270767/find-intersection-of-two-3d-lines
	
	// Let A1, B1 be points on a, b, resp.
	// Note that we don't just use a[0] and b[0] because they may actually be the intersection point, any thusly be the
	// same point. We should probably add short-circuit logic for those cases.
	A1 = v3(a[0] + (a[1] - a[0]) * .1),
	B1 = v3(b[0] + (b[1] - b[0]) * .3),

	A2 = v3(a[0] + (a[1] - a[0]) * .5),
	B2 = v3(b[0] + (b[1] - b[0]) * .7),

	//Let Adir and Bdir be direction vectors of a, b, resp.
	Adir = (A2 - A1)/norm(A2 - A1),
	Bdir = (B2 - B1)/norm(B2 - B1),

	// Let ABdir=CD→
	ABdir = B1 - A1,

	h = norm(cross(Bdir, ABdir)),
	k = norm(cross(Bdir, Adir)),

	l = h/k * Adir,

	// The two candidate points
	R1 = A1 + l,
	R2 = A1 - l
)
	// If h or k are zero, there is no intersection
	(abs(h) < 1e-10 || abs(k) < 1e-10)
		? undef
		// Check which point is along both lines
		: ((abs(norm(Adir - (A2 - R1)/norm(A2 - R1))) < 0.001 || abs(norm(Adir - (R1 - A2)/norm(R1 - A2))) < 0.001)
          && (abs(norm(Bdir - (B2 - R1)/norm(B2 - R1))) < 0.001 || abs(norm(Bdir - (R1 - B2)/norm(R1 - B2))) < 0.001)
			? R1
			: R2
		);

module chainHull(close = false) {
	if ($children == 1)
		children();
	else
		for (i=[0 : close ? $children-1 : $children-2])
			hull() {
				children(i);
				children((i+1) % $children);
			}
}

/**
 * Offsets a line by a given amount normal to the line
 */
function offsetLine(
	line,
	offset
) = let(
	A = line[0],
	B = line[1],
	dir = B - A,
	dis = norm(dir),
	normal = [-dir.y, dir.x] / dis,
	translateBy = normal * offset
) [
	A + translateBy,
	B + translateBy
];

/**
 * Given a new triangle, this function generates a new triangle where each side of the original triangle has been offset
 * by a given amount. Positive offsets go outward from the triangle, while negative offsets go inwards.
 */
function offsetTriangleSides(
	points,
	offsets
) = let(
	A = points[0],
	B = points[1],
	C = points[2],

	AB = offsetLine([A, B], offsets[0]),
	BC = offsetLine([B, C], offsets[1]),
	CA = offsetLine([C, A], offsets[2]),

	newA = lineIntersection(AB, CA),
	newB = lineIntersection(AB, BC),
	newC = lineIntersection(CA, BC)
) [ newA, newB, newC ];