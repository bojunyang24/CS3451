// Bojun Yang
// I tried to model the Flying Sentry from Hollow Knight...
// It didn't turn out well because I had trouble creating complex shapes to model the horns and shoulder/body

float time = 0;  // keep track of the passing of time

void setup() {
  size(800, 800, P3D);  // must use 3D here!
  noStroke();           // do not draw the edges of polygons
}

// Draw a scene with a cylinder, a box and a sphere
void draw() {
  
  resetMatrix();  // set the transformation matrix to the identity (important!)

  background(255, 255, 255);  // clear the screen to white

  // set up for perspective projection
  perspective (PI * 0.333, 1.0, 0.01, 1000.0);

  // place the camera in the scene
  camera (0.0, 0.0, 85.0, 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);
  
  // create an ambient light source
  ambientLight (102, 102, 102);

  // create two directional light sources
  lightSpecular (204, 204, 204);
  directionalLight (102, 102, 102, -0.7, -0.7, -1);
  directionalLight (152, 152, 152, 0, 0, -1);

  // Draw the sword

  pushMatrix();

  fill (0, 0, 0);
  ambient (50, 50, 50);
  specular (155, 155, 155);
  shininess (15.0);

  scale(1, 1, 3);
  rotate(time,0,1,0);
  rotateX(radians(90));
  rotateY(radians(90));
  translate(0.5, 8.5, 0.75); // (y,x,z)
  sword(16, 15);

  popMatrix();

  // Draw the eyes

  pushMatrix();

  fill (255, 165, 0);
  ambient (50, 50, 50);
  specular (155, 155, 155);
  shininess (15.0);

  rotate(time,0,1,0);
  rotateY(radians(90));
  translate(2, -16, 3);
  eye();

  popMatrix();

  pushMatrix();

  fill (255, 165, 0);
  ambient (50, 50, 50);
  specular (155, 155, 155);
  shininess (15.0);

  rotate(time,0,1,0);
  rotateY(radians(90));
  translate(-2, -16, 3);
  eye();

  popMatrix();

  // Draw the body

  pushMatrix();

  fill (128, 159, 209);
  ambient (50, 50, 50);
  specular (155, 155, 155);
  shininess (15.0);

  rotate(time,0,1,0);
  scale(0.8, 0.9, 1);
  body();

  popMatrix();

  // Draw the shoulder guards

  pushMatrix();

  fill (7, 25, 54);
  ambient (50, 50, 50);
  specular (155, 155, 155);
  shininess (15.0);

  rotate(time,0,1,0);
  rotateX(radians(90));
  rotateY(radians(180));
  translate(0, 0, -10);
  shoulder();

  popMatrix();

  // Draw the head

  pushMatrix();

  fill (7, 25, 54);
  ambient (50, 50, 50);
  specular (155, 155, 155);
  shininess (15.0);

  head();

  popMatrix();

  // Draw the arms and legs

  pushMatrix();

  fill (0, 0, 0);
  ambient (50, 50, 50);
  specular (155, 155, 155);
  shininess (100);
  rotate(time,0,1,0);

  pushMatrix();
  rotateX(radians(45));
  translate(0, -3, 10); // (z,x,y)
  scale(1.2, 1.2, 1.5);
  arm();
  popMatrix();

  pushMatrix();
  rotateX(radians(0));
  translate(0, -5, 9); // (z,y,x)
  scale(1.2, 1.2, 1.5);
  arm();
  popMatrix();

  pushMatrix();
  rotateX(radians(-45));
  translate(0, -3, -10); // (z,x,y)
  scale(1.2, 1.2, 1.5);
  arm();
  popMatrix();

  pushMatrix();
  rotateX(radians(0));
  translate(0, -5, -9); // (z,y,x)
  scale(1.2, 1.2, 1.5);
  arm();
  popMatrix();

  pushMatrix();
  rotateX(radians(-45));
  translate(0, -3, -10); // (z,x,y)
  scale(1.2, 1.2, 1.5);
  arm();
  popMatrix();

  // legs

  pushMatrix();
  rotateZ(radians(-10));
  translate(0, 5, 2);
  scale(1.2, 1.2, 1.5);
  arm();
  popMatrix();

  pushMatrix();
  rotateZ(radians(-10));
  translate(0, 5, -2);
  scale(1.2, 1.2, 1.5);
  arm();
  popMatrix();

  pushMatrix();
  rotateZ(radians(10));
  translate(3.5, 10, 2);
  scale(1.2, 1.2, 1.5);
  arm();
  popMatrix();

  pushMatrix();
  rotateZ(radians(10));
  translate(3.5, 10, -2);
  scale(1.2, 1.2, 1.5);
  arm();
  popMatrix();

  popMatrix();

  // step forward the time
  time += 0.03;
}

void arm() {
  pushMatrix();
  translate(0, 0, 0);
  cylinder(0.5, 5, 10);
  popMatrix();

  pushMatrix();
  translate(0, 0, 0);
  sphere(0.45);
  popMatrix();

  pushMatrix();
  translate(0, 5, 0);
  sphere(0.45);
  popMatrix();
}

void head() {
  scale(4,4,4);
  translate(0, -4, 0);
  sphere(1);
}

void wings() {
  pushMatrix();
  beginShape();
  vertex(0, 0, 0);
  bezierVertex(10, -5, 0, 10, -6, 0, 0, 10, 0);
  // bezierVertex(8, 10, 0, 8.5, -1, 0, 0, 0, 0);
  endShape();
  popMatrix();
}

void shoulder() {
  pushMatrix();
  translate(0, 6, 0);
  rotateX(radians(20));
  shoulderPad();
  popMatrix();

  pushMatrix();
  translate(0, 0, -1);
  scale(5,5,1);
  sphere(1);
  popMatrix();

  pushMatrix();
  translate(0, -6, 0);
  rotateZ(radians(180));
  rotateX(radians(20));
  shoulderPad();
  popMatrix();  
}

void shoulderPad() {
  pushMatrix();
  rotateZ(radians(-35));
  translate(-1.5, 0, 0);
  scale(2, 5, 1);
  sphere(1);
  popMatrix();

  pushMatrix();
  rotateZ(radians(35));
  translate(1.5, 0, 0);
  scale(2, 5, 1);
  sphere(1);
  popMatrix();

  pushMatrix();
  // translate(0, 0, 0);
  // rotateZ(radians(35));
  scale(2, 4, 1);
  sphere(1);
  popMatrix();
}

void body() {
  pushMatrix();
  scale(6,6,4.5);
  sphere(1);
  popMatrix();

  pushMatrix();
  scale(1, 3, 4.5/6);
  translate(0, -3, 0);
  cylinder(6, 3, 50);
  popMatrix();

  pushMatrix();
  translate(0, -9, 0);
  scale(6,6,4.5);
  sphere(1);
  popMatrix();

  pushMatrix();
  fill(0,0,0);
  translate(0, 0, 0);
  scale(1, 0.1, 4.5/6);
  cylinder(6, 3, 50);
  popMatrix();

  pushMatrix();
  fill(0,0,0);
  translate(0, -2, 0);
  scale(1, 0.1, 4.5/6);
  cylinder(6, 3, 50);
  popMatrix();

  pushMatrix();
  fill(0,0,0);
  translate(0, -5, 0);
  scale(1, 0.1, 4.5/6);
  cylinder(6, 3, 50);
  popMatrix();
  
  pushMatrix();
  fill(0,0,0);
  translate(0, -9, 0);
  scale(1, 0.1, 4.5/6);
  cylinder(6, 3, 50);
  popMatrix();
}

void eye() {
  pushMatrix();
  scale(1, 1.5, 0.75);
  sphere(1);
  popMatrix();
}

// creates a lance type sword with steps-polygon as the base and length of heigh
void sword(float steps, float height) {
  // even steps only cuz I'm doing this on a plane and don't know how to find the centroid of a polygon
  // makes a cone
  if (steps%2 == 1) {
    steps += 1;
  }
  float c_x = (cos(2*PI) + cos(PI)) / 2;
  float c_y = (sin(2*PI) + sin(PI)) / 2;
  float x0, x1, y0, y1, theta;
  x0 = 0.0;
  y0 = 0.0;
  for(int i = 0; i <= steps; i++) {
    theta = 2 * PI * i / steps;
    x1 = cos(theta);
    y1 = sin(theta);
    beginShape(TRIANGLES);
    vertex(x0, y0, 0.0);
    vertex(x1, y1, 0.0);
    vertex(c_x, c_y, height);
    endShape();
    x0 = x1;
    y0 = y1;
  }
  sphere(1);
  pushMatrix();
  rotateX(radians(90));
  translate(0, -height/10, 0);
  cylinder(0.25, height/10.0, int(steps));
  popMatrix();
}

// Draw a cylinder of a given radius, height and number of sides.
// The base is on the y=0 plane, and it extends vertically in the y direction.
void cylinder (float radius, float height, int sides) {
  int i,ii;
  float []c = new float[sides];
  float []s = new float[sides];

  for (i = 0; i < sides; i++) {
    float theta = TWO_PI * i / (float) sides;
    c[i] = cos(theta);
    s[i] = sin(theta);
  }
  
  // bottom end cap
  
  normal (0.0, -1.0, 0.0);
  for (i = 0; i < sides; i++) {
    ii = (i+1) % sides;
    beginShape(TRIANGLES);
    vertex (c[ii] * radius, 0.0, s[ii] * radius);
    vertex (c[i] * radius, 0.0, s[i] * radius);
    vertex (0.0, 0.0, 0.0);
    endShape();
  }
  
  // top end cap

  normal (0.0, 1.0, 0.0);
  for (i = 0; i < sides; i++) {
    ii = (i+1) % sides;
    beginShape(TRIANGLES);
    vertex (c[ii] * radius, height, s[ii] * radius);
    vertex (c[i] * radius, height, s[i] * radius);
    vertex (0.0, height, 0.0);
    endShape();
  }
  
  // main body of cylinder
  for (i = 0; i < sides; i++) {
    ii = (i+1) % sides;
    beginShape();
    normal (c[i], 0.0, s[i]);
    vertex (c[i] * radius, 0.0, s[i] * radius);
    vertex (c[i] * radius, height, s[i] * radius);
    normal (c[ii], 0.0, s[ii]);
    vertex (c[ii] * radius, height, s[ii] * radius);
    vertex (c[ii] * radius, 0.0, s[ii] * radius);
    endShape(CLOSE);
  }
}
