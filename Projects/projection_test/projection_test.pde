// Bojun Yang
// CS 3451 Homework
// main program file

void setup() {
  size(500, 500);
  background (255, 255, 255);
}

void draw() {
  // unused in this program because we just want to draw based on keyboard input
}

/******************************************************************************
When key is pressed, call one of these drawing test cases.
******************************************************************************/

void keyPressed() {
  
  stroke (0, 0, 0);
  background (255, 255, 255);
   //<>//
  if (key == '1') { ortho_test(); }
  if (key == '2') { ortho_test_scale(); }
  if (key == '3') { ortho_test_rotate(); }
  if (key == '4') { face_test(); }
  if (key == '5') { faces(); }
  if (key == '6') { ortho_cube(); }
  if (key == '7') { ortho_cube2(); }
  if (key == '8') { perspective_cube(); }
  if (key == '9') { persp_multi_cube(); }
  if (key == '0') { persp_initials(); }
}

/******************************************************************************
Print where the mouse was clicked, maybe useful for debugging.
******************************************************************************/

void mousePressed() {
  if (mouseButton == LEFT) { 
    println("you clicked on pixel ("+mouseX+", "+mouseY+")");
  }
}

/******************************************************************************
Test square drawing.
******************************************************************************/

void ortho_test()
{
  float nnear = -10.0;
  float ffar = 40.0;

  Init_Matrix();
  Ortho (-100.0, 100.0, -100.0, 100.0, nnear, ffar);
  square();
}

/******************************************************************************
Test square drawing with non-uniform scaling.
******************************************************************************/

void ortho_test_scale()
{
  float nnear = -10.0;
  float ffar = 40.0;

  Init_Matrix();
  Ortho (-100.0, 100.0, -100.0, 100.0, nnear, ffar);
  Scale (1.0, 0.5, 1.0);
  square();
}

/******************************************************************************
Test square drawing with rotation.
******************************************************************************/

void ortho_test_rotate()
{
  float nnear = -10.0;
  float ffar = 40.0;

  Init_Matrix();
  Ortho (-100.0, 100.0, -100.0, 100.0, nnear, ffar);
  RotateZ (20);
  square();
}

/******************************************************************************
Draw a square.
******************************************************************************/

void square()
{
  BeginShape();
  
  Vertex (-50.0, -50.0, 0.0);
  Vertex (-50.0,  50.0, 0.0);

  Vertex (-50.0, 50.0, 0.0);
  Vertex ( 50.0, 50.0, 0.0);

  Vertex (50.0, 50.0, 0.0);
  Vertex (50.0, -50.0, 0.0);

  Vertex (50.0, -50.0, 0.0);
  Vertex (-50.0, -50.0, 0.0);

  EndShape();
}

/******************************************************************************
Draw a cube.
******************************************************************************/

void cube()
{
  BeginShape();

  /* top square */

  Vertex (-1.0, -1.0,  1.0);
  Vertex (-1.0,  1.0,  1.0);

  Vertex (-1.0,  1.0,  1.0);
  Vertex ( 1.0,  1.0,  1.0);

  Vertex ( 1.0,  1.0,  1.0);
  Vertex ( 1.0, -1.0,  1.0);

  Vertex ( 1.0, -1.0,  1.0);
  Vertex (-1.0, -1.0,  1.0);

  /* bottom square */

  Vertex (-1.0, -1.0, -1.0);
  Vertex (-1.0,  1.0, -1.0);

  Vertex (-1.0,  1.0, -1.0);
  Vertex ( 1.0,  1.0, -1.0);

  Vertex ( 1.0,  1.0, -1.0);
  Vertex ( 1.0, -1.0, -1.0);

  Vertex ( 1.0, -1.0, -1.0);
  Vertex (-1.0, -1.0, -1.0);

  /* connect top to bottom */

  Vertex (-1.0, -1.0, -1.0);
  Vertex (-1.0, -1.0,  1.0);

  Vertex (-1.0,  1.0, -1.0);
  Vertex (-1.0,  1.0,  1.0);

  Vertex ( 1.0,  1.0, -1.0);
  Vertex ( 1.0,  1.0,  1.0);

  Vertex ( 1.0, -1.0, -1.0);
  Vertex ( 1.0, -1.0,  1.0);

  EndShape();
}

/******************************************************************************
Orthographic cube.
******************************************************************************/

void ortho_cube()
{
  Init_Matrix();
    
  Ortho (-2.0, 2.0, -2.0, 2.0, 0.0, 10000.0);

  Init_Matrix();
  Translate (0.0, 0.0, -4.0);
  RotateY (17.0);
  cube();
}

/******************************************************************************
Orthographic cube rotated.
******************************************************************************/

void ortho_cube2()
{
  Init_Matrix();
    
  Ortho (-2.0, 2.0, -2.0, 2.0, 0.0, 10000.0);

  Init_Matrix();
  Translate (0.0, 0.0, -4.0);
  RotateZ (5.0);
  RotateX (25.0);
  RotateY (20.0);
  cube();
}

/******************************************************************************
Perspective cube.
******************************************************************************/

void perspective_cube()
{
  Init_Matrix();
  Perspective (60.0, 1.0, 100.0);

  Init_Matrix();
  Translate (0.0, 0.0, -4.0);
  cube();
}

/******************************************************************************
Draw multiple cubes in perspective.
******************************************************************************/

void persp_multi_cube()
{
  Init_Matrix();
  
  Perspective (60.0, 1.0, 100.0);

  // draw several cubes in three lines along the axes
  for (float delta = -12; delta <= 12; delta += 3) {
    
    Init_Matrix();
    Translate (0.0, 0.0, -20.0);
    RotateZ(5);
    RotateX(25);
    RotateY(20);
    Translate(delta, 0, 0);
    cube();
    
    Init_Matrix();
    Translate (0.0, 0.0, -20.0);
    RotateZ(5);
    RotateX(25);
    RotateY(20);
    Translate(0, delta, 0);
    cube();
    
    Init_Matrix();
    Translate (0.0, 0.0, -20.0);
    RotateZ(5);
    RotateX(25);
    RotateY(20);
    Translate(0, 0, delta);
    cube();
  }

}

/******************************************************************************
Draw a circle of unit radius.
******************************************************************************/

void circle()
{
  int i;
  float theta;
  float x0,y0,x1,y1;
  float steps = 60;

  BeginShape();

  x0 = 1.0;
  y0 = 0.0;
  for (i = 0; i <= steps; i++) {
    theta = 2 * 3.1415926535 * i / steps;
    x1 = cos (theta);
    y1 = sin (theta);
    Vertex (x0, y0, 0.0);
    Vertex (x1, y1, 0.0);
    x0 = x1;
    y0 = y1;
  }

  EndShape();
}

/******************************************************************************
Draw a face.
******************************************************************************/
void face(float sc, float theta, float dx, float dy)
{
  /* head */

  Init_Matrix();
  
  Translate (dx, dy, 1.0);
  Translate (0.5, 0.5, 0.0);
  RotateZ (theta);
  Scale (sc, sc, 1.0);
  Translate (-0.5, -0.5, 0.0);
  
  Translate (0.5, 0.5, 0.0);
  Scale (0.4, 0.4, 1.0);
  circle();

  /* right eye */

  Init_Matrix();
  
  Translate (dx, dy, 1.0);
  Translate (0.5, 0.5, 0.0);
  RotateZ (theta);
  Scale (sc, sc, 1.0);
  Translate (-0.5, -0.5, 0.0);
  
  Translate (0.7, 0.7, 0.0);
  Scale (0.1, 0.1, 1.0);
  circle();

  /* left eye */

  Init_Matrix();
  
  Translate (dx, dy, 1.0);
  Translate (0.5, 0.5, 0.0);
  RotateZ (theta);
  Scale (sc, sc, 1.0);
  Translate (-0.5, -0.5, 0.0);
  
  Translate (0.3, 0.7, 0.0);
  Scale (0.1, 0.1, 1.0);
  circle();

  /* nose */

  Init_Matrix();
  
  Translate (dx, dy, 1.0);
  Translate (0.5, 0.5, 0.0);
  RotateZ (theta);
  Scale (sc, sc, 1.0);
  Translate (-0.5, -0.5, 0.0);
  
  Translate (0.5, 0.5, 0.0);
  Scale (0.07, 0.07, 1.0);
  circle();

  /* mouth */

  Init_Matrix();
  
  Translate (dx, dy, 1.0);
  Translate (0.5, 0.5, 0.0);
  RotateZ (theta);
  Scale (sc, sc, 1.0);
  Translate (-0.5, -0.5, 0.0);
  
  Translate (0.5, 0.25, 0.0);
  Scale (0.2, 0.1, 1.0);
  circle();
}

/******************************************************************************
Test the matrix stack by drawing a face.
******************************************************************************/

void face_test()
{
  float nnear = -10.0;
  float ffar = 100000.0;

  Init_Matrix ();

  Ortho (0.0, 1.0, 0.0, 1.0, nnear, ffar);

  face (1, 0, 0, 0);
}

/******************************************************************************
Draw four faces.
******************************************************************************/

void faces()
{
  float nnear = -10.0;
  float ffar = 100000.0;

  Init_Matrix ();

  Ortho (0.0, 1.0, 0.0, 1.0, nnear, ffar);

  Init_Matrix();
  face (0.5, 0, 0.25, -0.25);

  Init_Matrix();
  face (0.5, 0, -0.25, -0.25);

  Init_Matrix();
  face (0.5, 0, 0.25, 0.25);

  Init_Matrix();
  face (0.5, 30, -0.25, 0.25);
}
