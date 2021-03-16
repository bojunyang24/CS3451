// Matrix Stack Library

// You should modify the routines listed below to complete the assignment.
// Feel free to define any classes, global variables and helper routines that you need.
// Bojun Yang

// initialize transformation matrix m
float[][] m;

void Init_Matrix()
{
  m = new float[][] {{1,0,0,0},
                {0,1,0,0},
                {0,0,1,0},
                {0,0,0,1}};
}

void Translate(float x, float y, float z)
{
  m[0][3] += x*m[0][0];
  m[1][3] += y*m[1][1];
  m[2][3] += z*m[2][2];
}

void Scale(float x, float y, float z)
{
  m[0][0] *= x;
  m[1][1] *= y;
  m[2][2] *= z;
}

// for rotation: multiply by cos/sin for values on the diagonal to ensure scaling works with rotation and vice versa

void RotateX(float theta)
{
  float theta_rad = radians(theta);
  m[1][1] *= cos(theta_rad);
  m[1][2] = -sin(theta_rad);
  m[2][1] = sin(theta_rad);
  m[2][2] *= cos(theta_rad);
}

void RotateY(float theta)
{
  float theta_rad = radians(theta);
  m[0][0] *= cos(theta_rad);
  m[0][2] = sin(theta_rad);
  m[2][0] = -sin(theta_rad);
  m[2][2] *= cos(theta_rad);
}

void RotateZ(float theta)
{
  float theta_rad = radians(theta);
  m[0][0] *= cos(theta_rad);
  m[0][1] = -sin(theta_rad);
  m[1][0] = sin(theta_rad);
  m[1][1] *= cos(theta_rad);
}

void Print_Matrix()
{
  String m_str = "";
  for(int r = 0; r < m.length; r++) {
    m_str += "[";
    for(int c = 0; c < m[0].length; c++) {
      m_str += m[r][c] + ((c==m[0].length - 1) ? "" : ", ");
    }
    m_str += "]\n";
  }
  m_str += "\n";
  print(m_str);
}
