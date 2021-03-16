// Matrix Commands
// Bojun Yang

void setup() {
  size (100, 100);
  mat_test();
}

// test the various matrix commands and print out the current transformation matrix
void mat_test() {

  println ("test 1");
  Init_Matrix();
  Print_Matrix();
    
  println ("test 2");
  Init_Matrix();
  Translate (3, 2, 1.5);
  Print_Matrix();

  println ("test 3");
  Init_Matrix();
  Scale (2, 3, 4);
  Print_Matrix();

  println ("test 4");
  Init_Matrix();
  RotateX (90);
  Print_Matrix();

  println ("test 5");
  Init_Matrix();
  RotateY (-15);
  Print_Matrix();

  println ("test 6");
  Init_Matrix();
  RotateZ (45);
  Print_Matrix();
  Init_Matrix();
  Print_Matrix();

  println ("test 7");
  Init_Matrix();
  Translate (1.5, 2.5, 3.5);
  Scale (2, 2, 2);
  Print_Matrix();

  println ("test 8");
  Init_Matrix();
  Scale (4, 2, 0.5);
  Translate (2, -2, 10);
  Print_Matrix();

  println ("test 9");
  Init_Matrix();
  Scale (2, 2, 2);
  Print_Matrix();
  Init_Matrix();
  Translate (3.14159, 2.71828, 1.61803);
  Print_Matrix();

  println ("test 10");
  Init_Matrix();
  Scale (2, 4, 8);
  Scale (0.5, 0.25, 0.125);
  Print_Matrix();
  Translate (15, -6.5, 42);
  Translate (-15, 6.5, -42);
  Print_Matrix();
}

void draw() {}
