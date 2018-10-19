include <util.scad>;

/////////////////////////////////////
// Testing

// squareMachineNutCapture2d(6);

/////////////////////////////////////

// Machine Screw Dimensions
// From http://www.metalwebnews.com/howto/drill-tables/screw2.html
machineScrewShaftData = [
	[0,  inches(.0600), inches(.0635), inches(.0700)],
	[1,  inches(.0730), inches(.0760), inches(.0810)],
	[2,  inches(.0860), inches(.0890), inches(.0960)],
	[3,  inches(.0990), inches(.1040), inches(.1100)],
	[4,  inches(.1120), inches(.1160), inches(.1285)],
	[5,  inches(.1250), inches(.1285), inches(.1360)],
	[6,  inches(.1380), inches(.1440), inches(.1495)],
	[7],
	[8,  inches(.1640), inches(.1695), inches(.1770)],
	[9],
	[10, inches(.1900), inches(.1960), inches(.2010)],
	[11],
	[12, inches(.2160), inches(.2210), inches(.2280)]
];
iMachineScrewShaftNo = 0;
iMachineScrewShaftMajorDiameter = 1;
iMachineScrewShaftCloseFit = 2;
iMachineScrewShaftFreeFit = 3;

// Machine Screw Tap Sizes
// From http://www.physics.ncsu.edu/pearl/Tap_Drill_Chart.html
machineScrewCoarseTapData = [
	[ 0, inches(0.0600), 80, inches(0.0447), "3/64", inches(0.0469), "55",   inches(0.0520)],
	[ 1, inches(0.0730), 64, inches(0.0538), "53",   inches(0.0595), "1/16", inches(0.0625)],
	[ 2, inches(0.0860), 56, inches(0.0641), "50",   inches(0.0700), "49",   inches(0.0730)],
	[ 3, inches(0.0990), 48, inches(0.0734), "47",   inches(0.0785), "44",   inches(0.0860)],
	[ 4, inches(0.1120), 40, inches(0.0813), "43",   inches(0.0890), "41",   inches(0.0960)],
	[ 5, inches(0.1250), 40, inches(0.0943), "38",   inches(0.1015), "7/64", inches(0.1094)],
	[ 6, inches(0.1380), 32, inches(0.0997), "36",   inches(0.1065), "32",   inches(0.1160)],
	[ 7 ],
	[ 8, inches(0.1640), 32, inches(0.1257), "29",   inches(0.1360), "27",   inches(0.1440)],
	[ 9 ],
	[10, inches(0.1900), 24, inches(0.1389), "25",   inches(0.1495), "20",   inches(0.1610)],
	[11 ],
	[12, inches(0.2160), 24, inches(0.1649), "16",   inches(0.1770), "12",   inches(0.1890)]
];

machineScrewFineTapData = [
	[ 0, inches(0.0600), 80, inches(0.0447), "3/64", inches(0.0469), "55", inches(0.0520)],
	[ 1, inches(0.0730), 72, inches(0.0560), "53",   inches(0.0595), "52", inches(0.0635)],
	[ 2, inches(0.0860), 64, inches(0.0668), "50",   inches(0.0700), "48", inches(0.0760)],
	[ 3, inches(0.0990), 56, inches(0.0771), "45",   inches(0.0820), "43", inches(0.0890)],
	[ 4, inches(0.1120), 48, inches(0.0864), "42",   inches(0.0935), "40", inches(0.0980)],
	[ 5, inches(0.1250), 44, inches(0.0971), "37",   inches(0.1040), "35", inches(0.1100)],
	[ 6, inches(0.1380), 40, inches(0.1073), "33",   inches(0.1130), "31", inches(0.1200)],
	[ 7 ],
	[ 8, inches(0.1640), 36, inches(0.1299), "29",   inches(0.1360), "26", inches(0.1470)],
	[ 9 ],
	[10, inches(0.1900), 32, inches(0.1517), "21",   inches(0.1590), "18", inches(0.1695)],
	[11 ],
	[12, inches(0.2160), 28, inches(0.1722), "14",   inches(0.1820), "10", inches(0.1935)]
	// No 12. Has a third size as well: 32	0.1777	13	0.1850	9	0.1960
];

iMachineScrewTapNo = 0;
iMachineScrewTapMajorDiameter = 1;
iMachineScrewTapThreadsPerInch = 2;
iMachineScrewTapMinorDiameter = 3;

// 75% Threads for use with "Aluminum, Brass & Plastics"
iMachineScrewTap75PTapSizeName = 4;
iMachineScrewTap75PTapDiameter = 5;

// 50% Threads for use with "Stainless Steel, Steels & Iron"
iMachineScrewTap50PTapSizeName = 6;
iMachineScrewTap50PTapDiameter = 7;

// Square Machine Screw Nut Dimensions
// From https://www.fastenal.com/content/product_specifications/SQ.MSN.SS.pdf
squareMachineNutData = [
	[ 0, inches(.156), inches(.150), inches(.050), inches(.043)],
	[ 1, inches(.156), inches(.150), inches(.050), inches(.043)],
	[ 2, inches(.188), inches(.180), inches(.066), inches(.057)],
	[ 3, inches(.188), inches(.180), inches(.066), inches(.057)],
	[ 4, inches(.250), inches(.241), inches(.098), inches(.087)],
	[ 5, inches(.312), inches(.302), inches(.114), inches(.102)],
	[ 6, inches(.312), inches(.302), inches(.114), inches(.102)],
	[ 7],
	[ 8, inches(.344), inches(.332), inches(.130), inches(.117)],
	[ 9],
	[10, inches(.375), inches(.362), inches(.130), inches(.117)],
	[11],
	[12, inches(.438), inches(.423), inches(.161), inches(.148)]
];

iSquareMachineNutNo = 0;
iSquareMachineNutFlatWidthMax = 1;
iSquareMachineNutFlatWidthMin = 2;
iSquareMachineNutThicknessMax = 3;
iSquareMachineNutThicknessMin = 4;

// Stainless steel sheet metal thickness
stainlessSteelGuageThickness = [
	0, // 0
	0, // 1
	0, // 2
	0, // 3
	0, // 4
	0, // 5
	0, // 6
	inches(.1793), //  7
	inches(.1644), //  8
	inches(.1495), //  9
	inches(.1345), // 10
	inches(.1196), // 11
	inches(.1046), // 12
	inches(.0897), // 13
	inches(.0747), // 14
	inches(.0673), // 15
	inches(.0598), // 16
	inches(.0538), // 17
	inches(.0478), // 18
	inches(.0418), // 19
	inches(.0359), // 20
	inches(.0329), // 21
	inches(.0299), // 22
	inches(.0269), // 23
	inches(.0239), // 24
	inches(.0209), // 25
	inches(.0179), // 26
	inches(.0164), // 27
	inches(.0149)  // 28
];

acrylic1_16thickness = 1.524; // inches(.060);
acrylic3_16thickness = 4.4958; // inches(.177);
acrylic5_64thickness = 2.032; // inches(.080);
acrylic1_8thickness  = 2.9972; // inches(.118);
acrylic1_4thickness  = 5.588; // inches(.220);

stainlessSteelHexDriveRoundedHeadScrewData = [
	undef, // 0
	undef, // 1
	undef, // 2
	undef, // 3
	undef, // 4
	undef, // 5
	undef, // 6
	undef, // 7
	[inches(0.312), inches(0.087), inches(3/32), inches(0.164)], // 8 - https://www.mcmaster.com/#92949a190/=15qmokf
];

iHexScrewDataHeadDiameter = 0;
iHexScrewDataHeadHeight = 1;
iHexScrewDataDriveInradius = 2;
iHexScrewDataShaftDiameter = 3;

/////////////////////////////////////////////////////////////////////////////////////////////////////
// Parametric

// From http://forums.shoryuken.com/discussion/113947/neutrik-drilling-template

neutrikFaceSize = [26, 31];
neutrikFaceCornerRadius=3;
module neutrikHoles() {
	mainHoleDiameter = 24;
	screwHoleDiameter = machineScrewCoarseTapData[4][iMachineScrewTap50PTapDiameter];
	screwHolePitch = [19, 24];
	
	circle(r=24/2);
	
	translate([-screwHolePitch.x,screwHolePitch.y]/2) 
		circle(r=screwHoleDiameter/2,$fn=20);
	
	translate([screwHolePitch.x,-screwHolePitch.y]/2) 
		circle(r=screwHoleDiameter/2,$fn=20);
}

module neutricFace() {
	difference() {
		csquare(neutrikFaceSize, r=neutrikFaceCornerRadius, center=true, $fn=20);
		neutrikHoles();
	}
}

module squareMachineNut(
	sizeNo,
	toleranceFraction = .5,
	cutCenterHole = true
) {
	nutData = squareMachineNutData[sizeNo];
	width = interpolateScalar(nutData[iSquareMachineNutFlatWidthMin], nutData[iSquareMachineNutFlatWidthMax], toleranceFraction);
	thickness = interpolateScalar(nutData[iSquareMachineNutThicknessMin], nutData[iSquareMachineNutThicknessMax], toleranceFraction);
	
	difference() {
		translate([0,0,thickness/2]) cube([width, width, thickness], center=true);
		if (cutCenterHole)
			cylinder(h=20,r=inches(.138)/2,center=true);
	}
}

module squareMachineNutCapture2d(
	sizeNo,
	nutToleranceFraction = .5,
	insetDepth = 2,
	overallDepth = 10,
	freeFit = true
) {
	holeDiameter = machineScrewShaftData[sizeNo][freeFit ? iMachineScrewShaftFreeFit : iMachineScrewShaftCloseFit];
	
	nutData = squareMachineNutData[sizeNo];
	width = interpolateScalar(nutData[iSquareMachineNutFlatWidthMin], nutData[iSquareMachineNutFlatWidthMax], nutToleranceFraction);
	thickness = interpolateScalar(nutData[iSquareMachineNutThicknessMin], nutData[iSquareMachineNutThicknessMax], nutToleranceFraction);
	
	translate([insetDepth, 0]) csquare([thickness, width],center=[0,-.5]);
	csquare([overallDepth, holeDiameter], center=[0,-.5]);
}


module capturedSquareMachineShaftAndSquareNut(
	sizeNo,
	nutToleranceFraction = .5,
	insetDepth = 2,
	overallDepth = 10,
	freeFit = true
) {
	holeDiameter = machineScrewShaftData[sizeNo][freeFit ? iMachineScrewShaftFreeFit : iMachineScrewShaftCloseFit];
	
	translate([0,0,insetDepth]) squareMachineNut(sizeNo, toleranceFraction=nutToleranceFraction);
	cylinder(h=overallDepth, r=holeDiameter/2);
}

module stainlessSteelHexDriveRoundedHeadScrew(screw, length) {
	data = len(screw) ? screw : stainlessSteelHexDriveRoundedHeadScrewData[screw];
	headHeight = data[iHexScrewDataHeadHeight];

	linear_extrude(length) circle(d=data[iHexScrewDataShaftDiameter], $fn=12);
	mirror([0,0,1]) difference() {
		sphereCap(r=data[iHexScrewDataHeadDiameter]/2, h=headHeight);
		// TODO: Using circle here expects a circumradius, but we have inradius. Oh well.
		linear_extrude(headHeight+.1) circle(d=data[iHexScrewDataDriveInradius], $fn=6);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
// LEGACY

module carriageBolt10Actual(length) {
	carriageBolt(
		length = length, 
		bodyDiameter = 4.75,
		headDiameter = 11.28, 
		headHeight = 2.87, 
		squareWidth = 4.68, 
		squareDepth = 2.54, 
		squareCornerRadius = inches(0.031), 
		filletRadius = inches(0.031)
	);
}

module carriageBolt10(length, sizeFraction = .5) {
	carriageBolt(
		length = length, 
		bodyDiameter = interpolateInches(0.159, 0.199, sizeFraction),
		headDiameter = interpolateInches(0.436, 0.469, sizeFraction), 
		headHeight = interpolateInches(0.094, 0.114, sizeFraction), 
		squareWidth = interpolateInches(0.185, 0.199, sizeFraction), 
		squareDepth = interpolateInches(0.094, 0.125, sizeFraction), 
		squareCornerRadius = inches(0.031), 
		filletRadius = inches(0.031)
	);
}

module carriageBolt(
	length,
	bodyDiameter,
	headDiameter,
	headHeight,
	squareWidth,
	squareDepth,
	squareCornerRadius,
	filletRadius
) {
	linear_extrude(squareDepth) csquare([squareWidth,squareWidth], r=squareCornerRadius, center=true, $fn=24);
	linear_extrude(length) circle(r=bodyDiameter/2, $fn=12);
	mirror([0,0,1]) sphereCap(r=headDiameter/2, h=headHeight);
}

module flatMachineScrew(
	headDiameter,
	headAngle,
	headHeight,
	majorDiameter,
	overallLength,
	$fn=12
) {
	R = headDiameter/2;
	h = headHeight;
	t = headAngle / 2;
	u = h * tan(t);
	r = R - u;
	cylinder(r1=r, r2=R, h=headHeight);

	translateZ(0.01)
		mirror([0,0,1]) {
			cylinder(r=majorDiameter/2, h=overallLength + 0.01);
		}
}

module flatMachineScrew6(length) {
	// From https://www.mcmaster.com/94414a148
	flatMachineScrew(
		headDiameter = inches(0.307),
		headAngle = 82,
		headHeight = inches(0.097),
		majorDiameter = inches(0.138),
		overallLength = length
	);
}
//flatMachineScrew6(inches(.5),.7);

module nylockNut(
	overallHeight,
	inRadius,
	hexHeight,
	holeRadius
) {
	difference() {
		union() {
			inradiusCylinder(h=hexHeight, r = inRadius/2, $fn=6);
			cylinder(h=overallHeight, r=inRadius/2, $fn=16);
		}
		
		translate([0,0,-.5]) cylinder(r=holeRadius/2, h=overallHeight+2);
	}
}

module nylockNut10(fraction = .5) {
	// From https://www.mcmaster.com/#91831a009/=15qrofh
	nylockNut(
		overallHeight = interpolateInches(.249, .229, fraction),
		inRadius = interpolateInches(.376, .367, fraction),
		hexHeight = inches(.140),
		holeRadius = inches(0.199)
	);
}

module nylockNut8() {
	nylockNut(
		overallHeight = inches(11/64),
		inRadius = inches(11/32),
		hexHeight = inches(11/64),
		holeRadius = machineScrewFineTapData[8][iMachineScrewTapMajorDiameter]
	);
}

module hexNut(
	overallHeight,
	inRadius,
	holeRadius
) {
	difference() {
		inradiusCylinder(h=hexHeight, r = inRadius/2, $fn=6);
		translate([0,0,-.5]) cylinder(r=holeRadius/2, h=overallHeight+2);
	}
}
module hexNut10(fraction = .5) {
	hexNut(
		overallHeight = interpolateInches(.130, .117, fraction),
		inRadius = interpolateInches(.344, .332, fraction),
		holeRadius = inches(0.199)
	);
}