/**************************************************
    Variables
***************************************************/
$fn=30;

WALL_THICKNESS = 2;
BOTTOM_THICKNESS = 1;

POST_SIZE = 15;

BOARD_X = 30;
BOARD_Y = 60;
BOARD_Z = 18;

BOX_X = 60;
BOX_Y = 60;
BOX_Z = 52;

BAT_Y = 19;
BAT_X = 37.5;
BAT_Z = 19;

SWITCH_DRILL_DIAMETER = 18.5;
BUTTON_DRILL_DIAMETER = 12.5;

STANDOFF_SIZE = 10;

DIVIDER_STANDOFF_HEIGHT = 25;

INSERT_DRILL_DIAMETER = 4.7625;

/**************************************************
    Modules
***************************************************/

module box_bottom(l, w, h, wall_thickness=1, bottom_thickness=1){
    difference(){
        cube([l,w,h], center=true);
        translate([0,0,bottom_thickness])
            cube([l-(wall_thickness*2),w-(wall_thickness*2),h], center=true);
    
        //window to see in.
        //translate([0, w/2, h/2-2])cube([l-2, wall_thickness + 3, 34], center=true);
    }
}

module insert_post(h=10){
    difference(){
        cube([STANDOFF_SIZE, STANDOFF_SIZE, h], center=true);
        //translate([0,0, -h/2])cylinder(h=h, d=15);
        translate([0,0, (h/2)-12])cylinder(r=INSERT_DRILL_DIAMETER/2, h=12);
    }

}

module all_posts(BOX_X, BOX_Y, BOX_Z, wall_thickness=2){
    
    translate([BOX_X/2 - STANDOFF_SIZE/2, 
               BOX_Y/2 - STANDOFF_SIZE/2, 0])
        insert_post(BOX_Z);
    
    translate([-BOX_X/2 + STANDOFF_SIZE/2, 
               -BOX_Y/2 + STANDOFF_SIZE/2, 0])
        insert_post(BOX_Z);
    
    translate([-BOX_X/2 + STANDOFF_SIZE/2, 
               BOX_Y/2 - STANDOFF_SIZE/2, 0])
        insert_post(BOX_Z);
    
    translate([BOX_X/2 - STANDOFF_SIZE/2, 
               -BOX_Y/2 + STANDOFF_SIZE/2, 0])
        insert_post(BOX_Z);
}



module lid(l,w,h, wall_thickness=1){
    translate([0,0, h/2 + 3])
        cube([l, w,2],center=true);
}


module top_screw_holes(){
    
    SCREW_HOLE_DIAMETER = 4.8;
    
    translate([BOX_X/2 - STANDOFF_SIZE/2,
               BOX_Y/2 - STANDOFF_SIZE/2, 0])
        cylinder(r=SCREW_HOLE_DIAMETER/2, h=BOX_Z+10);
    
    translate([-BOX_X/2 + STANDOFF_SIZE/2, 
               -BOX_Y/2 + STANDOFF_SIZE/2, 0])
        cylinder(r=SCREW_HOLE_DIAMETER/2, h=BOX_Z+10);
    
    translate([-BOX_X/2 + STANDOFF_SIZE/2, 
               BOX_Y/2 - STANDOFF_SIZE/2, 0])
        cylinder(r=SCREW_HOLE_DIAMETER/2, h=BOX_Z+10);
    
    translate([BOX_X/2 - STANDOFF_SIZE/2, 
               -BOX_Y/2 + STANDOFF_SIZE/2, 0])
        cylinder(r=SCREW_HOLE_DIAMETER/2, h=BOX_Z+10);
}


module board(){
    cube([BOARD_X,BOARD_Y,BOARD_Z], center=true);
}

module switch_hole(){
   cylinder(r=SWITCH_DRILL_DIAMETER/2, h=BOX_Z + 100, center=true);
}

module button_hole(){
    cylinder(r=BUTTON_DRILL_DIAMETER/2, h=BOX_Z + 100, center=true);
}

module battery_holder(){
    difference(){
        cube([BAT_X, BAT_Y, BAT_Z], center=true);
        translate([0,0,1.01]){
            cube([BAT_X-2,BAT_Y-2,BAT_Z-2], center=true);
            
        }
        
        translate([(BAT_X/2)-3,-10,BAT_Z/2 - 4]){
            cube([2,BAT_Y/2,2], center=true);
        }
        
        translate([0-(BAT_X/2)+3,-10,BAT_Z/2 - 4]){
            cube([2,BAT_Y/2,2], center=true);
        }
    }   
}

module divider_standoffs(){
    Y_DISTANCE = ((BOX_Y/2)-(STANDOFF_SIZE/2));
    Z_DISTANCE = (-1*(BOX_Z/2) + (DIVIDER_STANDOFF_HEIGHT/2) + BOTTOM_THICKNESS);
    translate([0,Y_DISTANCE,Z_DISTANCE]){
        cube([(BOX_X-(2*STANDOFF_SIZE)),STANDOFF_SIZE,DIVIDER_STANDOFF_HEIGHT], center=true);
    }
    
    
    translate([0,-Y_DISTANCE,Z_DISTANCE]){
        cube([(BOX_X-(2*STANDOFF_SIZE)),STANDOFF_SIZE,DIVIDER_STANDOFF_HEIGHT], center=true);
    }
    
    
}

module divider_plate(){
    PLATE_X = BOX_X - (2 * STANDOFF_SIZE) - 2;
    cube([PLATE_X,BOX_Y-(2*WALL_THICKNESS)-3,2], center=true);
    translate([0,10,(BAT_Z/2)]){
        battery_holder();
    }
}





/**************************************************
    Render
***************************************************/

difference(){
    box_bottom(BOX_X, BOX_Y, BOX_Z, wall_thickness=WALL_THICKNESS, bottom_thickness=BOTTOM_THICKNESS);
    
    
    //window
    //cube([BOX_X+1,60,50], center=true);
    
}



//divider_standoffs();

translate([0,(BOX_Y/2)-(BAT_Y/2)-5, -(BOX_Z/2) + (BAT_Z/2)]){
	battery_holder();
}
all_posts(BOX_X, BOX_Y, BOX_Z, wall_thickness=WALL_THICKNESS);


/*
difference(){
    lid(BOX_X, BOX_Y, BOX_Z, wall_thickness=2);
    top_screw_holes();
    
    translate([-12,0,0]){
        switch_hole();
    }
    translate([12,10,0]){
        button_hole();
    }
    
    translate([12,-10,0]){
        button_hole();
    }
}*/

/*
translate([0,0,(BOX_Z/2)-20]){
    divider_plate();
}
*/

