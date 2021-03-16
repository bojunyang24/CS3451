/******************************************************************************
Bojun Yang => BY
Draw your initials here in perspective.
******************************************************************************/

void persp_initials()
{
  float s = 1.2;
  Perspective(90.0, 1.0, 100.0);
  Init_Matrix();
  Translate(-2.0, 0.0, -10.0);
  Scale(s,s,s);
  RotateX(-60);
  // RotateY(20);
  B();
  Init_Matrix();
  Translate(-2.0, 0.0, -10.0);
  Scale(s,s,s);
  RotateX(-60);
  // RotateY(20);
  Y();
}

void B() {
  BeginShape();
  Vertex (-1.0, -3.0,  1.0);
  Vertex (-1.0,  2.0,  1.0);

  Vertex (-1.0,  2.0,  1.0);
  Vertex ( 0.0,  2.0,  1.0);

  Vertex ( 0.0,  2.0,  1.0);
  Vertex ( 1.0,  1.0,  1.0);

  Vertex ( 1.0,  1.0,  1.0);
  Vertex ( 1.0,  0.5,  1.0);

  Vertex ( 1.0,  0.5,  1.0);
  Vertex ( 0.0,  -0.5,  1.0);

  Vertex ( 0.0,  -0.5,  1.0);
  Vertex ( -1.0,  -0.5,  1.0);

  Vertex ( 0.0,  -0.5,  1.0);
  Vertex ( 1.0,  -1.5,  1.0);
  
  Vertex ( 1.0,  -1.5,  1.0);
  Vertex ( 1.0,  -2.0,  1.0);
  
  Vertex ( 1.0,  -2.0,  1.0);
  Vertex ( 0.0,  -3.0,  1.0);

  Vertex ( 0.0,  -3.0,  1.0);
  Vertex ( -1.0,  -3.0,  1.0);
  EndShape();
}

void Y() {
  float s_y = 1.0;
  BeginShape();
  Vertex ( 1.0,  -1.0 + s_y,  1.0);
  Vertex ( 1.0,  -2.5 + s_y,  1.0);
  
  Vertex ( 1.0,  -2.5 + s_y,  1.0);
  Vertex ( 2.0,  -3.5 + s_y,  1.0);

  Vertex ( 2.0,  -3.5 + s_y,  1.0);
  Vertex ( 3.0,  -2.5 + s_y,  1.0);

  Vertex ( 3.0,  -1.0 + s_y,  1.0);
  Vertex ( 3.0,  -2.5 + s_y,  1.0);

  Vertex ( 2.0,  -3.5 + s_y,  1.0);
  Vertex ( 2.0,  -5.5 + s_y,  1.0);

  EndShape();
}
