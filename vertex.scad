include <configuration.scad>;


$fn = 24;
roundness = 6;

module extrusion_cutout(h, extra) {
  difference() {
    cube([extrusion+extra, extrusion+extra, h], center=true);
    for (a = [0:90:359]) rotate([0, 0, a]) {
      translate([extrusion/2, 0, 0])
        cube([6, 2.5, h+1], center=true);
    }
  }
}

module screw_socket() {
  cylinder(r=m3_wide_radius, h=20, center=true);
  translate([0, 0, 3.8]) cylinder(r=3.5, h=5);
}

module screw_socket_cone() {
  union() {
    screw_socket();
    scale([1, 1, -1]) cylinder(r1=4, r2=7, h=4);
  }
}

module vertex(height, idler_offset, idler_space) {
  union() {
    difference() {
      union() {
        intersection() {
          translate([0, 21, 0])
            cylinder(r=38, h=height, center=true, $fn=60);
          translate([0, -25, 0]) rotate([0, 0, 30])
            cylinder(r=50, h=height+1, center=true, $fn=6);
        }
        translate([0, 30, 0]) intersection() {
          rotate([0, 0, -90])
            cylinder(r=55, h=height, center=true, $fn=3);
          translate([0, 10, 0])
            cube([100, 100, 2*height], center=true);

        }
        
      }
      
      // Extrusion cutouts
      for(i = [1, -1]) {
        translate(v = [i * ((extrusion/2) + (extrusion_spacing/2)), 0, 0])
          extrusion_cutout(height+10, 2*extra_radius);
      }    
      
      // Cutout for idler
      difference() {
        translate([0, 58, 0]) minkowski() {
          intersection() {
            rotate([0, 0, -90])
              cylinder(r=61, h=height, center=true, $fn=3);
            translate([0, -32, 0])
              cube([100, 14, 2*height], center=true);
          }
          cylinder(r=roundness, h=1, center=true);
        }
        if(idler) {
          // Idler support cones.
          translate([0, 26+idler_offset-30, 0]) rotate([-90, 0, 0])
            cylinder(r1=30, r2=2, h=30-idler_space/2);
          translate([0, 26+idler_offset+30, 0]) rotate([90, 0, 0])
            cylinder(r1=30, r2=2, h=30-idler_space/2);
        }
      }
      
      // Front cutout
      translate([0, 58, 0]) minkowski() {
        intersection() {
          rotate([0, 0, -90])
            cylinder(r=61, h=height, center=true, $fn=3);
          translate([0, 7, 0])
            cube([100, 30, 2*height], center=true);
        }
        cylinder(r=roundness, h=1, center=true);
      }
      
      #for (z = [0, height-extrusion]) {
        // Screw holes for back of extrusion
        for(i = [1, -1]) {
          translate(v = [i * ((extrusion/2) + (extrusion_spacing/2)), 0, 0])
          translate([0, -7.5-extra_radius, z+7.5-height/2]) rotate([90, 0, 0])
            screw_socket_cone();
        }
        for (a = [-1, 1]) {
          rotate([0, 0, 30*a]) translate([-20*a, 121, z+7.5-height/2]) {
            % rotate([90, 0, 0]) extrusion_cutout(200, 0);
            // Screw sockets.
            for (y = [-95, -56]) {
              translate([a*7.5, y, 0]) rotate([0, a*90, 0]) screw_socket();
            }
            // Nut tunnels.
	          for (nut_z = [-1, 1]) {
	            scale([1, 1, nut_z]) translate([0, -100, 3]) minkowski() {
	              rotate([0, 0, -a*30]) cylinder(r=4, h=extrusion+1, $fn=6);
		            cube([0.1, 5, 0.1], center=true);
	            }
            }
          }
        }
      }
        
    }
  }
}

vertex(extrusion, idler=1, idler_offset=0, idler_space=10);




