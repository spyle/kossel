include <configuration.scad>;

use <vertex.scad>;

$fn = 24;

frame_height = 6*extrusion;

motor_offset = 44;
motor_length = 47;

module frame_motor() {
  difference() {
    // No idler cones.
    vertex(frame_height, idler=0, idler_offset=0, idler_space=100);

    for (mirror = [-1, 1]) scale([mirror, 1, 1]) {
      translate([-35, 45, 0]) rotate([0, 0, -30])
         cube([4, 15, extrusion*4-10], center=true);
    }
    translate([0, 0, (frame_height/2)-25]) union() {
      // Motor cable paths.
      for (mirror = [-1, 1]) scale([mirror, 1, 1]) {
        translate([(extrusion_spacing+(extrusion*2))/2-2, 0, 0])
          cylinder(r=2.5, h=40);
        translate([-11, 0, 0])
          #cube([15, 4, 15], center=true);
      }
    
      translate([0, motor_offset, 0]) {
        // Motor shaft/pulley cutout.
        rotate([90, 0, 0]) cylinder(r=13, h=20, center=true, $fn=60);
        // NEMA 17 stepper motor mounting screws.
        for (x = [-1, 1]) for (z = [-1, 1]) {
          scale([x, 1, z]) translate([15.5, -5, 15.5]) {
            rotate([90, 0, 0]) cylinder(r=1.65, h=10, center=true, $fn=12);
          }
        }
      }
    }
    
    translate([-3, motor_offset, -22]) {
      minkowski() {
        rotate([90, 0, 0]) 
          cylinder(r=15, h=20, center=true, $fn=60);
        cube([5, 10, 1]);
      }
    }
    
    // NEMA 17 stepper motor.
    //% translate([0, motor_offset + motor_length/2, 0]) intersection() {
    //  cube([42.2, motor_length, 42.2], center=true);
    //  rotate([0, 45, 0]) cube([52, motor_length, 52], center=true);
    //}
  }
}

frame_motor();
