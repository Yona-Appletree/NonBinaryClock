include <util.scad>;

/////////////////////////////////
// Module Calls

* for (x=[0:9-1], y=[0])
	translate([x*(lgpCubeEdgeLength+5), y*(lgpCubeEdgeLength+17)])
	rotate(90)
	lgpCubeSlice();

* lgpCubeContainerPlate();

* testCubeMountingPlate();

* screwTestingBlock();
* screwTestingPlate();
* textTestingPlate();

* assembledClock();
* lgpCube($extrude=true);
* faceAcrylic();

* for(x=[0:1])
	translateX(x*30)
	for(m=[0,1])
	mirrorY(m)
	translateY(6) lgpCubeRetainerHalf();

* topBottomAcrylic(false);
* translateY(28.5)
	topBottomAcrylic(true);

* backAcrylic();

sideAcrylic(false);
* translateY(clockFrameDepth + facePlateThickness + 1) sideAcrylic(false);

* lgpCubeRetainerHalf($extrude=true);

* clockFrame();

/////////////////////////////////
// Variable Definitions

// Materials
lgpThickness = 8;
blackAcrylicThickness = 2.6;

// LED Strip
ledStripWidth = 5;
ledStripLedsPerMeter = 60;

// LGP Cube
lgpCubeLayers = 3;
lgpCubeEdgeLength = lgpCubeLayers * lgpThickness;
lgpCubeInsideInset = 1;

lgpCubeRetainerInset = 2;
lgpCubeRetainerWidth = blackAcrylicThickness - 0.10; // Calculated from measurement and testing; was 0.125
lgpCubeRetainerOverflow = [2, 6];

lgpCubeHeightTolerance = .125;
lgpCubeHoleSize = [
	lgpCubeEdgeLength - lgpCubeInsideInset * 2,
	lgpCubeEdgeLength + lgpCubeHeightTolerance*2
];

lgpCubeColor = [.3, .3, 1, .7];

// [ width, inset ]
lgpCubeInsetSegments = [
	[ blackAcrylicThickness+.3, 0 ],
	[ lgpCubeRetainerWidth, lgpCubeRetainerInset ],
	[ 3.5                    , 0 ],
	[ ledStripWidth + .5   , 2 ],
	[ 1.25                    , 0 ],
];

// Overall
faceRowSpacing = 5;
faceColSpacing = 37;
faceDigitStairStepOffset = 15;

faceMarginLeft   = 17;
faceMarginRight  = 17;
faceMarginTop    = 14;
faceMarginBottom = 14;

faceDigitColumns = [
	3,
	4,
	4,
];

faceDigitColumnCount = len(faceDigitColumns);
faceDigitMaxRowCount = max(faceDigitColumns);
facePlateThickness = blackAcrylicThickness;

facePlateSize = [
	(lgpCubeEdgeLength + faceColSpacing) * faceDigitColumnCount
		- faceColSpacing
		+ faceDigitStairStepOffset * (faceDigitMaxRowCount-1)
		+ faceMarginLeft
		+ faceMarginRight,

	(lgpCubeEdgeLength + faceRowSpacing) * faceDigitMaxRowCount
		- faceRowSpacing
		+ faceMarginTop
		+ faceMarginBottom,

	facePlateThickness
];


clockFrameDepth = 25;
clockFrameWallThickness = 7;

// USB Hole
usbFemaleCutoutSize = [13, 8.9] + v2(0 /* tolerance */);
usbFemaleDepth = 10;
usbFemaleOffset = [0, -13-usbFemaleCutoutSize.y/2];
usbFemaleInternalTolerance = .5;

// Switch Cutout Hole Size
pushSwitchCutoutSize = [5.8, 3.3] + v2(0 /* tolerance */);
pushSwitchCutoutDepth = 3.80;
pushSwitchWallThickness = 2;
pushSwitchLedgeWidth = 1;
pushSwitchOffset = [0, 8.5];

wireHoleDiameter = 4.5;


mountingScrewHeadHoleDiameter = 8.5;
mountingScrewShaftHoleDiameter = 3.5;

faceScrewClearanceHoleDiameter = 2.6;
faceScrewReceiverHoleDiameter = 2.25;


echo("Face Size (mm)", facePlateSize.x, facePlateSize.y);
echo("Face Size (in)", facePlateSize.x / 25.4, facePlateSize.y / 25.4);
echo("Face Ratio", facePlateSize.x / facePlateSize.y);

/////////////////////////////////
// Module Definitions

module assembledClock() {
	$extrude = true;

	for(x=[0,1])
		translateX((x?0:1)*facePlateSize.z + x * facePlateSize.x)
		rotateY(-90)
		sideAcrylic(flip=x);

	for(z=[0,1])
		translateZ(z*(facePlateSize.y - facePlateThickness))
		topBottomAcrylic(wireHole = !z);

	rotateX(90) {
		clockFrame();
		faceAcrylic();
		*translateZ(-clockFrameDepth-facePlateThickness)
			backAcrylic();

		translateZ(-facePlateSize.z)
			lgpCubeContainerPlate();

		placeCubesOnFace()
			translateX(-lgpCubeInsideInset)
			translateY(lgpCubeHoleSize.y)
			rotateZ(-90) {
				translateZ(facePlateSize.z)
				rotateY(90)
					lgpCube();
			}
	}
}

module screwTestingPlate() {
	difference() {
		csquare(
			[ 30, 32 ],
			center=true
		);

		translateY(5)
			screwMountingHole();

		translateX(10)
			rotate(90)
			csquare(pushSwitchCutoutSize, center=true);

			translateX(-10)
				rotate(90)
				circle(d=faceScrewClearanceHoleDiameter, $fn=24);

		translateY(7)
			text("<3 gabe!", size=4, halign="center", valign="bottom", font="Source Sans Pro Light", spacing=1, $fn=50);
	}
}

module textTestingPlate() {
	difference() {
		csquare(
			[ 18, 28 ],
			center=[-.5, -.4]
		);

		translateY(13)
			csquare(pushSwitchCutoutSize, center=true);

		translateY(7)
			text("three", size=3, halign="center", valign="bottom", font="Source Sans Pro Light", spacing=1, $fn=50);

		translateY(0)
			text("four", size=4, halign="center", valign="bottom", font="Source Sans Pro Light", spacing=1, $fn=50);

		translateY(-7)
			text("six", size=6, halign="center", valign="bottom", font="Source Sans Pro Light", spacing=1, $fn=50);
	}
}

module screwTestingBlock() {
	difference() {
		csquare(
			[ 15, 16, 12 ],
			center=[-.5,-.42],
			$fn=12
		);

		for(x=[-1,1], y=[-1,1])
			translate([ x*4, y*4 ])
			translateZ(-.1) {
				i = (x==1?1:0) * 2 + (y==1?1:0);

				d = faceScrewReceiverHoleDiameter + i*.25;
				cylinder(d=d, h=9, $fn=24);
				translateY(1.5)
					linear_extrude(1)
					mirrorY(1)
					text(str(d), size=2, halign="center", valign="top");
			}
	}
}

module testCubeMountingPlate() {
	union() {
		for(m=[0,1])
			mirrorY(m) translateY(36, x=-10) lgpCubeRetainerHalf();

		rotate(90) difference() {
			csquare([60, 40], center=[-.5, -.5]);
			csquare(lgpCubeHoleSize, center=[-.5, -.5]);
		}
	}
}

module wireHole() {
	rotateX(-45)
		linear_extrude(100, center=true)
		hull() {
			for(i=[-1, 1])
				mirrorX(i==1?1:0)
				translateY(i*4)
				circle(d=wireHoleDiameter, $fn=20);
		}
}

module sideAcrylic(
	flip
) {
	buttonLabels = [
		[
			"sec",
			"min",
			"hour",
		],
		[
			"color",
			"base",
			"dim"
		]
	][flip?0:1];

	buttonCount = len(buttonLabels);
	buttonSpacing = 12;
	buttonClusterEdgeMargin = 10;

	color([.3,.3,.3])
		linear_extrude_opt(facePlateThickness)
		translateY(flip ? clockFrameDepth : 0)
		mirrorY(flip ? 1 : 0)
		difference() {
			translateY(facePlateThickness * (flip?-1:0))
				csquare(
					[
						facePlateSize.y,
						clockFrameDepth + facePlateThickness
					]
				);

//			translateX(clockFrameWallThickness + 4)
//				translateY(clockFrameDepth/2)
//				csquare(usbFemaleCutoutSize, center=[0,-.5]);

			for (i=[0:buttonCount-1])
				translateY(clockFrameDepth/2)
				translateX(facePlateThickness + clockFrameWallThickness + buttonClusterEdgeMargin + (pushSwitchCutoutSize.y + buttonSpacing) * i)
				if (buttonLabels[i] != "")
				rotate(-90) union() {
					csquare(pushSwitchCutoutSize, center=true);
					translateY(pushSwitchCutoutSize.y/2 + 1.5)
					#text(buttonLabels[i], size=4, halign="center", valign="bottom", font="Source Sans Pro Light", spacing=1, $fn=50);
				}
		}
}

module screwMountingHole() {
	$fn=24;

	holeSeparation = mountingScrewHeadHoleDiameter * .9;

	mediumFraction = .65;
	mediumHoleSize = mountingScrewShaftHoleDiameter + (mountingScrewHeadHoleDiameter - mountingScrewShaftHoleDiameter) * (1-mediumFraction);

	hull() {
		translateY(-holeSeparation) circle(d=mountingScrewHeadHoleDiameter);
		translateY(-holeSeparation * mediumFraction) circle(d=mediumHoleSize);
	}

	hull() {
		translateY(-holeSeparation * mediumFraction) circle(d=mediumHoleSize);
		circle(d=mountingScrewShaftHoleDiameter);
	}
}

module backAcrylic() {
	color([.2,.2,.2,.8])
		linear_extrude_opt(blackAcrylicThickness)
		difference() {
			// Main Face
			translate(v2(facePlateThickness))
				csquare(
					v2(facePlateSize) - v2(facePlateThickness*2)
				);

			// Wire Hole
			translateX(facePlateSize.x/2)
				projection(cut=true)
				wireHole();

			// Mounting Holes
			translateX(facePlateSize.x/2)
				for(x=[-1,1])
				translateY(facePlateSize.y/2 + (facePlateSize.y*1/4))
				translateX(x*(facePlateSize.x*3/5)/2)
				screwMountingHole();

			// Stand Holes
			translateX(facePlateSize.x/2)
				for(x=[-1,1])
				translateY(facePlateSize.y/2 - (facePlateSize.y*1/4))
				translateX(x*(facePlateSize.x*3/5)/2)
				csquare([ lgpCubeRetainerWidth, 15 ], center=true);

			// Screw Holes
			translate(facePlateSize/2)
				for(x=[-1,1], y=[-1,1])
				translateX(x * (facePlateSize.x / 2 - facePlateThickness - clockFrameWallThickness/2))
				translateY(y * (facePlateSize.y / 2 - facePlateThickness - clockFrameWallThickness/2))
				circle(d=faceScrewClearanceHoleDiameter, $fn=24);
		}
}

module topBottomAcrylic(
	wireHole=false
) {
	color([.4,.4,.4])
		linear_extrude_opt(facePlateThickness)
		difference() {
			translateX(facePlateThickness)
				csquare(
					[
						facePlateSize.x - facePlateThickness*2,
						clockFrameDepth + facePlateThickness
					]
				);

			if (wireHole)
				translateY(clockFrameDepth + facePlateThickness)
				translateX(facePlateSize.x/2)
				projection(cut=true)
				wireHole();
		}
}

module clockFrame() {
	color([.6, .1, .1])
		mirrorZ(1)
		translate(v2(facePlateSize.z))
			difference() {
				union() {
					difference() {
						linear_extrude(clockFrameDepth, convexity=5)
							difference() {
								csquare(v2(facePlateSize) - v2(facePlateSize.z*2));

								translate(v2(clockFrameWallThickness))
									csquare(v2(facePlateSize) - v2(facePlateSize.z*2 + clockFrameWallThickness*2));
							}

						translateZ(clockFrameWallThickness)
							translateX(clockFrameWallThickness)
							translateY(-1)
							csquare(
								[
									facePlateSize.x - facePlateSize.z*2 - clockFrameWallThickness*2,
									facePlateSize.y,
									clockFrameDepth - clockFrameWallThickness*2
								]
							);

						translateZ(clockFrameWallThickness)
							translateY(clockFrameWallThickness)
							translateX(-1)
							csquare(
								[
									facePlateSize.x,
									facePlateSize.y - facePlateSize.z*2 - clockFrameWallThickness*2,
									clockFrameDepth - clockFrameWallThickness*2
								]
							);
					}

					translateX(facePlateSize.x/2 - facePlateThickness)
						translateZ(clockFrameDepth)
						csquare(
							[
								wireHoleDiameter*3,
								clockFrameWallThickness*2.5,
								clockFrameWallThickness
							],
							center=[-.5,0,-1],
							r=4,
							$fn=24
						);
				}

				translateX(facePlateSize.x/2 - facePlateThickness)
					translateZ(clockFrameDepth)
					mirrorZ(1)
					wireHole();


				// Screw Holes
				translateZ(clockFrameDepth+.1)
					translate(facePlateSize/2 - v2(facePlateThickness))
					for(x=[-1,1], y=[-1,1])
					translateX(x * (facePlateSize.x / 2 - facePlateThickness - clockFrameWallThickness/2))
					translateY(y * (facePlateSize.y / 2 - facePlateThickness - clockFrameWallThickness/2))
					mirrorZ(1)
					cylinder(d=faceScrewReceiverHoleDiameter, h=15, $fn=24);
			}
}

module lgpCubeContainerPlate(
	colNum = 0
) {
	module retainers(
		colNums,
		colMirrorValues,
		includeInside,
		includeOutside
	) {
		placeCubesOnFace(colNums=colNums)
			translateX(lgpCubeEdgeLength)
			rotateZ(90)
			for (m=colMirrorValues)
			mirrorY(m)
			translateY(m*-lgpCubeHoleSize.y)
			lgpCubeRetainerHalf(
				includeInside=includeInside,
				includeOutside=includeOutside,
				$extrude=false
			);
	}

	module columnRetainer(col, side, edgeBrace=0) {
		linear_extrude_opt(blackAcrylicThickness) {
			difference() {
				hull() {
					retainers(
						colNums=[col],
						colMirrorValues=[side],
						includeOutside = true,
						includeInside = false
					);

					if (edgeBrace != 0) {
						translate(
							v2(facePlateSize.z+clockFrameWallThickness) +
								v2(
									edgeBrace==1
										? facePlateSize.x - facePlateSize.z*2 - clockFrameWallThickness*2
										: 0,
									0
								)
						)
							csquare(
								[
									15,
									facePlateSize.y - facePlateSize.z*2 - clockFrameWallThickness*2,
								],
								center=[
									edgeBrace==1?-1:0,
									0
								]
							);
					}
				}

				hull()
					retainers(
						colNums=[col],
						colMirrorValues=[side?0:1],
						includeOutside = false,
						includeInside = true
					);

				retainers(
					colNums=[col],
					colMirrorValues=[side],
					includeOutside = false,
					includeInside = true
				);
			}

			retainers(
				colNums=[col],
				colMirrorValues=[side],
				includeOutside = true,
				includeInside = true
			);
		}
	}

	color([.3,0,0]) columnRetainer(0, 1, edgeBrace=-1);
	color([.5,0,0]) columnRetainer(0, 0);

	color([0,.3,0]) columnRetainer(1, 1);
	color([0,.5,0]) columnRetainer(1, 0);

	color([0,0,.3]) columnRetainer(2, 1);
	color([0,0,.5]) columnRetainer(2, 0, edgeBrace=1);
}

module lgpCubeRetainerHalf(
	includeOutside = true,
	includeInside = true
) {
	// Guide
	* translateZ(-blackAcrylicThickness)
		translateX(lgpCubeHoleSize.y) rotateY(-90) lgpCube();

	color([.5,.5,.5])
		linear_extrude_opt(facePlateSize.z)
		difference() {
			if (includeOutside)
				translate(-lgpCubeRetainerOverflow)
					translateY(lgpCubeInsideInset)
					csquare(
						[
							lgpCubeEdgeLength + lgpCubeRetainerOverflow.x*2,
							lgpCubeEdgeLength/2 - lgpCubeInsideInset + lgpCubeRetainerOverflow.y - .3
						]
					);

			if (includeInside)
				translateX(-lgpCubeHeightTolerance)
					translateY(lgpCubeRetainerInset + lgpCubeInsideInset)
					csquare(
						[
							lgpCubeEdgeLength + lgpCubeHeightTolerance*2,
							lgpCubeEdgeLength/2 - lgpCubeInsideInset,
						]
					);
		}
}

module placeCubesOnFace(colNums=[0:len(faceDigitColumns)-1]) {
	translateX(lgpCubeInsideInset)
		translate([faceMarginLeft, faceMarginBottom])
		for($colNum = colNums) {
			rowCount = faceDigitColumns[$colNum];

			translateX($colNum * (lgpCubeEdgeLength + faceColSpacing))
				for(rowNum = [0:rowCount-1]) {
					translateX(faceDigitStairStepOffset * rowNum)
						translateY(rowNum * (lgpCubeEdgeLength + faceRowSpacing))
						children();
				}
		}
}

module faceAcrylic() {
	color([.2,.2,.2])
		linear_extrude_opt(blackAcrylicThickness)
		difference() {
			csquare(
				v2(facePlateSize)
			);

			placeCubesOnFace()
				csquare(lgpCubeHoleSize);
		}
}

module lgpCube() {
	for (z=[0:lgpCubeLayers-1])
		translateZ(lgpThickness * z)
		lgpCubeSlice($extrude = true);
}

module lgpCubeSlice() {
	color(lgpCubeColor)
		linear_extrude_opt(lgpThickness) {
			// Exterior Body
			csquare(
				[
					lgpCubeEdgeLength,
					lgpCubeEdgeLength
				],
				center=[-1, 0]
			);

			// Interior Body
			union() {
				for (i = [0 : len(lgpCubeInsetSegments) - 1]) {
					segment = lgpCubeInsetSegments[i];

					translateX(vsum(lgpCubeInsetSegments, count = i).x)
						translateY(segment[1] + lgpCubeInsideInset)
						csquare(
							[
								segment[0],
								lgpCubeEdgeLength - lgpCubeInsideInset*2 - segment[1]*2
							],
							center=[0, 0]
						);
				}
			}
		}
}