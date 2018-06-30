/*
Game Control Panel
===================
A customizable button panel for creating button panels for gaming and quick task macros.
The board can be customized to almost any number of buttons, scale and layout.

This is designed to be used with manufactured buttons and an arduino, teensy, or itsy bitsy board to wire the buttons.
The number of buttons and joysticks you are limited to is dependant on your controller and how many pins you have available.

Defaults to a 5x5 grid with even spacing between rows and columns for 30mm diameter buttons.
One 40mm diameter hole for joystick

This is a work in progress, the back panel will not fit with the buttons in place, need to add more clearance.


Directions:
===========
comment out all the parts except the one you need.
export the piece.
edit length and width to include "mm", no units are set by default.
move on to next piece until you have a full set of svg files.
send svg files to laser cutter.

==TODO==
-fix back panel
-mount controller board
-close up with bottom with screws
*/

// User customizable values
buttons_wide = 5;
buttons_high = 4;
button_spacing_wide = 16;
button_spacing_high = 16;
joystick_spacing_high = 16;
joystick_diameter = 40;
joystick_screws = 32.5;
wall_thick = 3;
button_diameter = 24;
bevel=1;
hand_rest=20;
base_hight=30;
face_angle=45;

// Non-customizable values
face_wide=buttons_wide*(button_diameter+button_spacing_wide)+button_spacing_wide;
face_high=buttons_high*(button_diameter+button_spacing_high)+button_spacing_high;
face_hight=sin(face_angle)*(face_high);
face_depth=sqrt(pow(face_high,2)-pow(face_hight,2));
base_depth=button_spacing_high*2+button_diameter+joystick_spacing_high*2+joystick_diameter+hand_rest;
base_cutoff_depth=joystick_spacing_high*2+joystick_diameter;
echo("face_depth: ",face_depth)

//sanity checks
if(buttons_wide<1){
  buttons_wide=1;
}
if(buttons_high<1){
  buttons_high=1;
}
if(button_spacing_wide<5){
  button_spacing_wide=5;
}
if(button_spacing_high<5){
  button_spacing_high=5;
}
if(wall_thick<3){
  wall_thick=3;
}
if(button_diameter<10){
  echo("Warning: button diameter too small");
  button_diameter=10;
}
if(face_angle >80 || face_angle < 20){
  echo("Warning: face angle to extreem");
  face_angle=45;
}

//face panel

difference(){
  //main plate
  square([face_wide,face_high]);
  
  union(){
  //button cutouts
    for (x = [0:buttons_wide-1]){
      button_x=button_spacing_wide+button_diameter/2+(x*(button_diameter+button_spacing_wide));
      for (y = [0:buttons_high-1]){
        button_y=button_spacing_high+button_diameter/2+(y*(button_diameter+button_spacing_high));
        translate([button_x,button_y]){
          circle(d=button_diameter,$fn=button_diameter*4);
        }
      }
    }
  }
}

//base panel
translate([0, face_high+1]){
  difference(){
    square([face_wide,base_depth]);
    
    union(){
      for (x = [0:buttons_wide-1]){
        button_x=button_spacing_wide+button_diameter/2+(x*(button_diameter+button_spacing_wide));
        translate([button_x,button_spacing_high+button_diameter/2]){
          circle(d=button_diameter,$fn=button_diameter*4);
        }
      }
      translate([face_wide/2,base_depth-(joystick_spacing_high+joystick_diameter/2+hand_rest)]){
        circle(d=joystick_diameter,$fn=joystick_diameter*4);
        translate([-joystick_screws/2,-joystick_screws/2]){
          circle(d=2,$fn=20);
          translate([joystick_screws,0])circle(d=2,$fn=20);
          translate([0,joystick_screws])circle(d=2,$fn=20);
          translate([joystick_screws,joystick_screws])circle(d=2,$fn=20);
        }
      }
      translate([0,button_spacing_high*2+button_diameter+hand_rest]){
        rotate([0,0,45]){
          //square(face_wide,face_wide);
        }
        translate([face_wide,0]){
          rotate([0,0,45]){
            //square(face_wide,face_wide);
          }
        }
      }
    }
  }
}

//side panels
translate([face_wide+1,0]){
  difference(){
    square([face_hight+base_hight,(face_depth+base_depth)-]);
    union(){
      translate([base_hight,0]){
        square([face_hight+base_hight,base_depth]);
        translate([0,base_depth]){
          rotate([0,0,-face_angle]){
            square([face_depth*2,face_high]);
          }
        }
      }
    }
  }
  mirror(){
    translate([-((face_hight+base_hight)*2)-1,0]){
      difference(){
        square([face_hight+base_hight,face_depth+base_depth]);
        union(){
          translate([base_hight,0]){
            square([face_hight+base_hight,base_depth]);
            translate([0,base_depth]){
              rotate([0,0,-face_angle]){
                square([face_depth*2,face_high]);
              }
            }
          }
        }
      }
    }
  }
}
//back panel - cannot be mounted in current state
/*
translate([face_wide+(base_hight+face_hight)-face_wide/2,0]){
  square([face_wide,base_hight+face_hight]);
}
*/
//bottom panel
translate([face_wide+1+(face_hight+base_hight+1)*2,0]){
  square([face_wide,face_depth+base_depth]);
}
//front panel
square([face_wide,base_hight]);
