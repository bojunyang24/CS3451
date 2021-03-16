// Bojun Yang
// Dummy routines for OpenGL commands.
// These are for you to write!
// You should incorporate your transformation matrix routines from part A of this project.
float[][] m = new float[][] {{1,0,0,0},
                {0,1,0,0},
                {0,0,1,0},
                {0,0,0,1}};
ArrayList<float[]> v_list = new ArrayList<float[]>();
Boolean draw = false;
Boolean projection = true; // true is ortho false is persp
// init ortho and persp initial values
float l = -100.0;
float r = 100.0;
float b = -100.0;
float t = 100.0;
float n = -10.0;
float f = 40.0;
float fov = 60.0;
float near = 1.0;
float far = 100.0;

void Init_Matrix()
{
  m = new float[][] {
    {1,0,0,0},
    {0,1,0,0},
    {0,0,1,0},
    {0,0,0,1}};
}

void Translate(float x, float y, float z)
{
  float[][] t = new float[][] {
    {1,0,0,x},
    {0,1,0,y},
    {0,0,1,z},
    {0,0,0,1}};
  m = multiply(m, t);
}

void Scale(float x, float y, float z)
{
  float[][] s = new float[][] {
    {x,0,0,0},
    {0,y,0,0},
    {0,0,z,0},
    {0,0,0,1}};
  m = multiply(m, s);
}

void RotateX(float theta)
{
  float theta_rad = radians(theta);
  float[][] r = new float[][] {
    {1,0,0,0},
    {0,cos(theta_rad),-sin(theta_rad),0},
    {0,sin(theta_rad),cos(theta_rad),0},
    {0,0,0,1}};
  m = multiply(m, r);
}

void RotateY(float theta)
{
  float theta_rad = radians(theta);
  float[][] r = new float[][] {
    {cos(theta_rad),0,sin(theta_rad),0},
    {0,1,0,0},
    {-sin(theta_rad),0,cos(theta_rad),0},
    {0,0,0,1}};
  m = multiply(m, r);
}

void RotateZ(float theta)
{
  float theta_rad = radians(theta);
  float[][] r = new float[][] {
    {cos(theta_rad),-sin(theta_rad),0,0},
    {sin(theta_rad),cos(theta_rad),0,0},
    {0,0,1,0},
    {0,0,0,1}};
  m = multiply(m, r);
}

// multiplies two 4x4 matrices
float[][] multiply(float[][] m1, float[][] m2) {
  float[][] m_out = new float[][] {{0,0,0,0},
                {0,0,0,0},
                {0,0,0,0},
                {0,0,0,0}};
  for (int r = 0; r < 4; r++) {
    for (int c = 0; c < 4; c++) {
      m_out[r][c] = 0;
      for (int k = 0; k < 4; k++) {
        m_out[r][c] += m1[r][k] * m2[k][c];
      }
    }
  }
  return m_out;
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

void Perspective(float fov, float near, float far)
{
  this.fov = fov;
  this.near = near;
  this.far = far;
  projection = false;
}

void Ortho(float l, float r, float b, float t, float n, float f)
{
  this.l = l;
  this.r = r;
  this.b = b;
  this.t = t;
  this.n = n;
  this.f = f;
  projection = true;;
}

void BeginShape()
{
  v_list = new ArrayList<float[]>();
  draw = true;
}

void Vertex(float x, float y, float z)
{
  if (draw) {
    // apply transformation matrix to vertex
    float v_new[] = Transform(x, y, z);
    if (projection) {
      // ortho
      v_new[0] = (v_new[0] - this.l) * width / (this.r - this.l);
      v_new[1] = (v_new[1] - this.t) * height / (this.b - this.t);
      v_new[2] = 0;
    } else {
      // persp
      float k = tan(radians(fov) / 2);
      float abs_z = abs(v_new[2]);
      float x_prime = v_new[0] / abs_z;
      float y_prime = v_new[1] / abs_z;
      v_new[0] = (x_prime + k) * (width / (2 * k));
      v_new[1] = (y_prime - k) * (height / (-2 * k));
    }
    v_list.add(v_new);
    // if there's an even number of vertices, draw the most recent two vertex line
    if (v_list.size() % 2 == 0) {
      float[] p1 = v_list.get(v_list.size() - 2);
      line(p1[0], p1[1], v_new[0], v_new[1]);
    }
  }
}

float[] Transform(float x, float y, float z) {
  float a1 = m[0][0];
  float a2 = m[0][1];
  float a3 = m[0][2];
  float a4 = m[0][3];
  float b1 = m[1][0];
  float b2 = m[1][1];
  float b3 = m[1][2];
  float b4 = m[1][3];
  float c1 = m[2][0];
  float c2 = m[2][1];
  float c3 = m[2][2];
  float c4 = m[2][3];
  //float d1 = m[3][0];
  //float d2 = m[3][1];
  //float d3 = m[3][2];
  //float d4 = m[3][3];
  float[] v_new = {(a1*x + a2*y + a3*z + a4),(b1*x + b2*y + b3*z + b4),(c1*x + c2*y + c3*z + c4)};
  return v_new;
}

void EndShape()
{
  draw = false;
}

void print_v(float[] v) {
  String vprint = "";
  vprint += "[" + v[0] + ", ";
  vprint += v[1] + ", ";
  vprint += v[2] + "]\n";
  println(vprint);
}

void print_v_list() {
  String vprint = "";
  for (float[] v: v_list) {
    vprint += "[" + v[0] + ", ";
    vprint += v[1] + ", ";
    vprint += v[2] + "]\n";
  }
  print(vprint);
}
