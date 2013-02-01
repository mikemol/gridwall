SEGHEIGHT=26;

// Interface for interlocking with walls
module subpost() {
	translate( v=[1,-1,2] ) union() {
		cube(size = [2,2,SEGHEIGHT-2]);
		translate( v=[1,0,SEGHEIGHT-4]) cube(size = [2,2,2]);
	}
}

// Post for connecting walls to.
module post() {
	union() {
		translate( v=[-2,-2,0]) cube(size = [4,4,SEGHEIGHT]);
		subpost();
		rotate(90) subpost();
		rotate(180) subpost();
		rotate(270) subpost();
	}
}

// Wall module. Designed for 26mm grid, with 4mm gaps between grid squares.
module wall() {
	difference() {
		translate( v=[-2,0,0]) union() {
			cube(size = [4,26,SEGHEIGHT]);
			translate( v = [1,0,-2])
				cube( size = [2,26,2] );
		}
		union() {
			translate( v=[0,-2,0]) post();
			translate( v=[0,28,0]) post();
		}

	}
}

post();

translate( v = [42 ,-34,0] ) wall();

translate ( v = [34,-42,0] ) rotate(90) wall();

rotate(180) translate ( v = [0,8,0] ) wall();

rotate(270) translate ( v = [0,8,0] ) wall();

translate( v = [ 42, 0, 0 ] ) post();

translate( v = [ 0, -42, 0] ) post();

translate( v = [42, -42, 0] ) post();
