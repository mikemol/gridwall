BASEA=26; // Affects the size of the grid squares acommodated.
BASEB=4; // Affects the thickness of the wall and meshing interfaces.

SEGLENGTH=BASEA;
WALLDEPTH=BASEB;
WALLHEIGHT=BASEA;

// Interface for interlocking with walls
module subpost() {
	// The subpost has two key components. A long vertical bar to give the
	// attached wall horizontal stability, and a protuding stub at the top
	// to anchor the wall in place. The whole assembly is raised and moved
	// outward so the post() module needs only specify its position by
	// rotation.
	translate( v=[WALLDEPTH/4,0-WALLDEPTH/4,WALLDEPTH/2] ) union() {
		cube(size = [WALLDEPTH/2,WALLDEPTH/2,WALLHEIGHT-WALLDEPTH/2]);
		translate( v=[WALLDEPTH/4,0,WALLHEIGHT-WALLDEPTH])
			cube(size = [WALLDEPTH/2,WALLDEPTH/2,WALLDEPTH/2]);
	}
}

// Post for connecting walls to. The post is designed to be after the walls
// are in place. The post will stabilize them.
module post() {
	// A post consists of a center column with four interfaces
	// attached on each side.
	union() {
		translate( v=[0 - WALLDEPTH/2,0 - WALLDEPTH/2,0])
			cube(size = [WALLDEPTH,WALLDEPTH,WALLHEIGHT]);
		subpost();
		rotate(90) subpost();
		rotate(180) subpost();
		rotate(270) subpost();
	}
}

// Wall module. 
module wall() {
	// The wall consists of a core component, with interface sockets placed
	// at the end via CSG subtraction. The interface is defined by the
	// post() module.
	difference() {
		// The core of the wall module consists of a large wall block with a
		// long strip protruding from the bottom. This protrusion is intended
		// to be fitted into a large horizontal plate under the wall, affixing
		// it in place on the game map.
		translate( v=[0,0-WALLDEPTH/2,0]) union() {
			cube(size = [SEGLENGTH,WALLDEPTH,WALLHEIGHT]);
			translate( v = [0,WALLDEPTH/4,0-WALLDEPTH/2])
				cube( size = [SEGLENGTH,WALLDEPTH/2,WALLDEPTH/2] );
		}
		// The interface sockets are set at either end of the wall
		// segment.
		union() {
			translate( v=[0-WALLDEPTH/2, 0,0]) post();
			translate( v=[SEGLENGTH+WALLDEPTH/2,0,0]) post();
		}

	}
}

// Plate module; what the walls and posts should be set on.
module plate() {
	// The plate module has just enough space to place one post and two
	// walls. It's defined by taking a cube and subtracting the
	// interfacees under the walls and posts.
	difference() {
		// The basic plate.
		cube(size=[SEGLENGTH+WALLDEPTH,SEGLENGTH+WALLDEPTH,WALLDEPTH]);

		// The post and two walls, moved into place.
		translate( v = [WALLDEPTH/2,WALLDEPTH/2,WALLDEPTH] )
			union() {
				post();
	
				translate( v = [WALLDEPTH/2,0,0] )
					wall();
	
				rotate(90)
					translate( v = [WALLDEPTH/2,0,0] )
						wall();
			}
	}
}

// Demonstrate the modules.

translate( v = [0-WALLDEPTH/2,0-WALLDEPTH/2,0-WALLDEPTH*2] )
	plate();

post();

translate( v = [WALLDEPTH*2,0,0] )
	wall();

rotate(90)
	translate( v = [WALLDEPTH*2,0,0] )
		wall();

