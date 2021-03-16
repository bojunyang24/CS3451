// Bojun Yang
// To see the random colors effect, just press the number again
// I assign the random color when each patch is read in from the txt
// so to see changing colors for each figure, just reload them.

int display_option = 1;  // 1 = four corners, 2 = nine quads, 3 = detailed polygons

float time = 0;                 // keep track of passing of time

boolean rotate_flag = true;     // automatic rotation of model?
boolean normal_flag = false;    // use smooth surface normals?  (optional)
boolean color_flag = false;     // random colors?

// object-specific translation and scaling
PVector obj_center = new PVector (0,0,0);
float obj_scale = 1.0;

Patch[] patches = new Patch[0];
float n = 1.0/10.0; // param for interpolating bezier points

class Patch {
  PVector[][] control_points;
  PVector c;
  PVector[][] bezier_control_points;

  Patch(PVector[][] control_points, PVector c) {
    this.control_points = control_points;
    this.c = c;
    this.interpolate_bezier();
  }

  void interpolate_bezier() {
    PVector[][] temp = new PVector[0][0];
    for (int i = 0; i < this.control_points.length; i++) {
      PVector p0 = this.control_points[i][0];
      PVector p1 = this.control_points[i][1];
      PVector p2 = this.control_points[i][2];
      PVector p3 = this.control_points[i][3];

      PVector[] down = new PVector[0];
      float t = 0.0;
      // had to use a little bit more than 1.0 due to suspicious rounding of floats
      while (t <= 1.001) {
        // interpolate bezier point at t
        float x = (pow(1.0-t, 3)*p0.x) + (pow(1.0-t, 2)*3*t*p1.x) + (pow(t, 2)*(1-t)*3*p2.x) + (pow(t, 3)*p3.x);
        float y = (pow(1.0-t, 3)*p0.y) + (pow(1.0-t, 2)*3*t*p1.y) + (pow(t, 2)*(1-t)*3*p2.y) + (pow(t, 3)*p3.y);
        float z = (pow(1.0-t, 3)*p0.z) + (pow(1.0-t, 2)*3*t*p1.z) + (pow(t, 2)*(1-t)*3*p2.z) + (pow(t, 3)*p3.z);
        down = (PVector[]) append(down, new PVector(x,y,z));
        t+=n;
      }
      temp = (PVector[][]) append(temp, down);
    }

    PVector[][] bezier_control_points = new PVector[0][0];
    for (int j = 0; j < temp[0].length; j++) {
      PVector p0 = temp[0][j];
      PVector p1 = temp[1][j];
      PVector p2 = temp[2][j];
      PVector p3 = temp[3][j];

      PVector[] across = new PVector[0];
      float t = 0.0;
      while (t <= 1.001) {
        float x = (pow(1.0-t, 3)*p0.x) + (pow(1.0-t, 2)*3*t*p1.x) + (pow(t, 2)*(1-t)*3*p2.x) + (pow(t, 3)*p3.x);
        float y = (pow(1.0-t, 3)*p0.y) + (pow(1.0-t, 2)*3*t*p1.y) + (pow(t, 2)*(1-t)*3*p2.y) + (pow(t, 3)*p3.y);
        float z = (pow(1.0-t, 3)*p0.z) + (pow(1.0-t, 2)*3*t*p1.z) + (pow(t, 2)*(1-t)*3*p2.z) + (pow(t, 3)*p3.z);
        across = (PVector[]) append(across, new PVector(x,y,z));
        t+=n;
      }
      bezier_control_points = (PVector[][]) append(bezier_control_points, across);
    }
    this.bezier_control_points = bezier_control_points;
  }

}

// initialize stuff
void setup() {
  size(750, 750, OPENGL);
}

// Draw the scene
void draw() {
  
  resetMatrix();  // set the transformation matrix to the identity

  background (100, 100, 230);  // clear the screen to sky blue
  
  // set up for perspective projection
  perspective (PI * 0.333, 1.0, 0.01, 1000.0);
  
  // place the camera in the scene
  camera (0.0, 0.0, 5.0, 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);
    
  // create an ambient light source
  ambientLight (102, 102, 102);
  
  // create two directional light sources
  lightSpecular (204, 204, 204);
  directionalLight (102, 102, 102, -0.7, -0.7, -1);
  directionalLight (152, 152, 152, 0, 0, -1);
  
  pushMatrix();

  // set the material color
  fill (200, 200, 200);
  ambient (200, 200, 200);
  specular(0, 0, 0);
  shininess(1.0);
  noStroke();
  
  // rotate based on time
  rotate (time, 0.0, 1.0, 0.0);
  
  translate (0.0, 0.8, 0.0);
  rotate (PI * 0.5, 1.0, 0.0, 0.0);

  // translate and scale on a per-object basis
  scale (obj_scale);
  translate (-obj_center.x, -obj_center.y, -obj_center.z);
  strokeWeight (1.0 / obj_scale);  // make sure lines don't change thickness
  
  // THIS IS WHERE YOU SHOULD DRAW THE PATCHES
  

  switch (display_option) {
    case 1:
      // println("Four Corners");
      noFill();
      stroke(255);
      for (int i = 0; i < patches.length; i++) {
        beginShape();
        vertex(patches[i].control_points[0][0].x, patches[i].control_points[0][0].y, patches[i].control_points[0][0].z);
        vertex(patches[i].control_points[3][0].x, patches[i].control_points[3][0].y, patches[i].control_points[3][0].z);
        vertex(patches[i].control_points[3][3].x, patches[i].control_points[3][3].y, patches[i].control_points[3][3].z);
        vertex(patches[i].control_points[0][3].x, patches[i].control_points[0][3].y, patches[i].control_points[0][3].z);
        endShape(CLOSE);
      }
      break;
    case 2:
      // println("Nine Quads");
      noFill();
      stroke(255);
      for (int i = 0; i < patches.length; i++) {
        for (int j = 0; j < patches[i].control_points.length - 1; j++) {
          for (int k = 0; k < patches[i].control_points[j].length - 1; k++) {
            beginShape();
            vertex(patches[i].control_points[j][k].x, patches[i].control_points[j][k].y, patches[i].control_points[j][k].z);
            vertex(patches[i].control_points[j+1][k].x, patches[i].control_points[j+1][k].y, patches[i].control_points[j+1][k].z);
            vertex(patches[i].control_points[j+1][k+1].x, patches[i].control_points[j+1][k+1].y, patches[i].control_points[j+1][k+1].z);
            vertex(patches[i].control_points[j][k+1].x, patches[i].control_points[j][k+1].y, patches[i].control_points[j][k+1].z);
            endShape(CLOSE);
          }
        }
      }
      break;
    case 3:
      // println("Detailed Polygons");
      if (!color_flag) {
        fill(255,255,255);
      }
      // stroke(255);
      for (int i = 0; i < patches.length; i++) {
        if (color_flag) {
          fill(patches[i].c.x, patches[i].c.y, patches[i].c.z);
        }
        for (int j = 0; j < patches[i].bezier_control_points.length - 1; j++) {
          for (int k = 0; k < patches[i].bezier_control_points[j].length - 1; k++) {
            beginShape();
            vertex(patches[i].bezier_control_points[j][k].x, patches[i].bezier_control_points[j][k].y, patches[i].bezier_control_points[j][k].z);
            vertex(patches[i].bezier_control_points[j+1][k].x, patches[i].bezier_control_points[j+1][k].y, patches[i].bezier_control_points[j+1][k].z);
            vertex(patches[i].bezier_control_points[j+1][k+1].x, patches[i].bezier_control_points[j+1][k+1].y, patches[i].bezier_control_points[j+1][k+1].z);
            vertex(patches[i].bezier_control_points[j][k+1].x, patches[i].bezier_control_points[j][k+1].y, patches[i].bezier_control_points[j][k+1].z);
            endShape(CLOSE);
          }
        }
      }
      break;
    default:
      // println("Default Square");
      beginShape();
      // normal (0.0, 0.0, 1.0);
      vertex (-1.0, -1.0, 0.0);
      vertex ( 1.0, -1.0, 0.0);
      vertex ( 1.0,  1.0, 0.0);
      vertex (-1.0,  1.0, 0.0);
      endShape(CLOSE);
      break;
  }



  popMatrix();
 
  // maybe step forward in time (for object rotation)
  if (rotate_flag )
    time += 0.02;
}

// handle keystroke inputs
void keyPressed() {
  if (key == '1') {
    set_obj_center_and_scale (1, 1.5, 1.5, 0);
    read_patches ("simple.txt", 0);
  }
  else if (key == '2') {
    set_obj_center_and_scale (1.5, 0, 0, -0.75);
    read_patches ("sphere.txt", 1);
  }
  else if (key == '3') {
    set_obj_center_and_scale (0.6, 0, 0, 0);
    read_patches ("teapot.txt", 2);
  }
  else if (key == '4') {
    set_obj_center_and_scale (0.15, 10.0, 7.0, 4.0);
    read_patches ("gumbo.txt", 3);
  }
  else if (key == 'a') {
    // set the display of each patch to an outline of one quad
    display_option = 1;
  }
  else if (key == 's') {
    // set the display of each patch to outlines of nine quads
    display_option = 2;
  }
  else if (key == 'd') {
    // set the display of each patch to be a detailed set of filled polygons (10 x 10 or more)
    display_option = 3;
  }
  else if (key == 'r') {
    // toggle random color here
    color_flag = !color_flag;
  }
  else if (key == 'n') {
    // toggle surface normals (optional)
    normal_flag = !normal_flag;
  }
  else if (key == ' ') {
    // rotate the model?
    rotate_flag = !rotate_flag;
  }
  else if (key == 'q' || key == 'Q') {
    exit();
  }
}

// adjust the size and position of an object when it is drawn
void set_obj_center_and_scale (float sc, float x, float y, float z)
{
  obj_scale = sc;
  obj_center = new PVector (x, y, z);
}

// Read Bezier patches from a text file
//
// You should modify this routine to store all of the patch data
// into your data structure instead of printing it to the screen.
void read_patches (String filename, int f)
{
  int i,j,k;
  String[] words;
    
  String lines[] = loadStrings(filename);
  
  words = split (lines[0], " ");
  int num_patches = int(words[0]);
  println ("number of patches = " + num_patches);
  
  // which line of the file are we reading?
  int count = 1;
  patches = new Patch[0];
  // read in the patches
  for (i = 0; i < num_patches; i++) {
    // println ();
    // println ("patch number " + i + ":");
    count += 1;  // skip over the lines that say "3 3"
    PVector[][] control_points = new PVector[4][4];
    for (j = 0; j < 4; j++) {
      for (k = 0; k < 4; k++) {
        words = split (lines[count], " ");
        count += 1;
        float x = float(words[0]);
        float y = float(words[1]);
        float z = float(words[2]);
        control_points[j][k] = new PVector(x,y,z); // control_points[0-3] is the 4 bezier curves
        // println (" control point " + j + " " + k + " " + x + " " + y + " " + z);
      }
    }
    patches = (Patch[]) append(patches, new Patch(control_points, new PVector(random(0,256),random(0,256),random(0,256))));
  }
  // println(patches.length);
}
