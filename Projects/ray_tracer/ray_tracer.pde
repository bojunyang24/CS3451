// This is the starter code for the CS 3451 Ray Tracing Project.
// Bojun Yang
// I created classes to help encapsulate lights, surfaces, and shapes. 
// I have javadocs (that's what they're called right?) inside each class and extra helper function I wrote to help clarify

// orginal file text:
// The most important part of this code is the interpreter, which will help
// you parse the scene description (.cli) files.

boolean debug_flag;  // help to print information for just one pixel
float fov;
PVector background, eye, u, v, w;
float d_d, u_u, v_v; // for multiplying with u,v,w
Light[] lights = new Light[0];
Surface prev_surface;
Surface[] surfaces = new Surface[0];
Shape[] shapes = new Shape[0];
// keep list of disks and ellipsoids in case we need to remember how many shapes of each type there are
Disk[] disks = new Disk[0];
Ellipsoid[] ellipsoids = new Ellipsoid[0];

/**
  pos: (x,y,z) pos of light source
  c: (r,g,b) color of light
**/
class Light {
  PVector pos;
  PVector c;

  Light(PVector pos, PVector c) {
    this.pos = pos;
    this.c = c;
  }

  Light() {
    super();
  }
}

/**
  diffuse: (r,g,b) diffuse color of surface
  ambient: (r,g,b) ambient color of surface
  specular: (r,g,b) specular color of surface
  p: phong exponent
  k_refl: reflectance coefficient
**/
class Surface {
  PVector diffuse;
  PVector ambient;
  PVector specular;
  float p;
  float k_refl;


  Surface(PVector diffuse, PVector ambient, PVector specular, float p, float k_refl) {
    this.diffuse = diffuse;
    this.ambient = ambient;
    this.specular = specular;
    this.p = p;
    this.k_refl = k_refl;
  }

  Surface() {
    super();
  }
}

class Shape {
  /**
    surface: pointer to the surface class, describes the properties of this shape's surface
  **/
  Surface surface;
  
  Shape(Surface surface) {
    this.surface = surface;
  }

  Shape() {
    super();
  }
}

/**
  surface:
  center: (x,y,z) of center point of disk
  normal: (nx,ny,nz) normal to disk surface
  raidus:
  d: the d coefficient for this disk's plane equation
  sub-class of Shape
**/
class Disk extends Shape {
  PVector center;
  PVector normal;
  float radius;
  float d;

  Disk(PVector center, PVector normal, float radius, Surface surface) {
    super(surface);
    this.center = center;
    this.normal = normal;
    this.radius = radius;
    this.d = -(normal.x * center.x + normal.y * center.y + normal.z * center.z);
  }

  Disk() {
    super();
  }
}

/**
  surface:
  center: (x,y,z) of center point of ellipsoid
  raidii: (rx,ry,rz) semi-major radii
  sub-class of Shape
**/
// TODO: Add additional fields for implicit equation of ellipsoid
class Ellipsoid extends Shape {
  PVector center;
  // float rx, ry, rz;
  PVector radius;

  Ellipsoid(PVector center, PVector radius, Surface surface) {
    super(surface);
    this.center = center;
    this.radius = radius;
  }
}

/**
  x: source of ray
  d: unit vector of ray's direction
**/
class Ray {
  PVector x; // <x_0,y_0,z_0>
  PVector d; // <dx,dy,dz>

  Ray(PVector x, PVector d) {
    this.x = x;
    this.d = d;
  }
}

/**
  hit: whether hit or not
  t: t for parametric equation
  p: coordinates of hit
  normal: surface normal
  surface: surface info of hit
  shape: shape that was hit
**/
class Hit {
  boolean hit;
  float t;
  PVector p;
  PVector normal;
  Surface surface; // material
  Shape shape;

  Hit() {
    super();
  }

  Hit(boolean hit, float t, PVector p, PVector normal, Surface surface, Shape shape) {
    this.hit = hit;
    this.t = t;
    this.p = p; // coordinates of intersection
    this.normal = normal;
    this.surface = surface;
    this.shape = shape;
  }
}

// gets the closest t for ellisoid intersection
float getT(float a, float b, float c) {
  float det = sqrt(sq(b) - (4.0*a*c));
  if (det == 0) {
    // 1 t
    float t = -b / (2.0*a);
    return t;
  } else if (det > 0) {
    // 2 ts
    float t1 = (-b + det) / (2.0*a);
    float t2 = (-b - det) / (2.0*a);
    if (t1 < 0 && t2 > 0) {
      return t2;
    } else if (t1 > 0 && t2 < 0) {
      return t1;
    } else if (t1 > 0 && t2 > 0) {
      return t1 > t2 ? t2 : t1;
    } else {
      // println("two negative ts");
      return -1.0;
    }
  } else {
    return -1.0;
  }
}

// maps [0,1] --> [0,256]
float get_rgb(float x) {
  return x * 256;
}

// returns squared distance from x to y. no need for sqrt since all we do is compare --> saves compute time
float distance2(PVector x, PVector y) {
  return sq(x.x - y.x) + sq(x.y - y.y) + sq(x.z - y.z);
}

void setup() {
  size(500, 500);  
  noStroke();
  colorMode(RGB);
  background(0, 0, 0);
}

void reset_scene() {
  //reset the global scene variables here
  lights = new Light[0];
  surfaces = new Surface[0];
  shapes = new Shape[0];
  prev_surface = new Surface();
  d_d = 0.0;
  u_u = 0.0;
  v_v = 0.0;
  u = new PVector(0,0,0);
  v = new PVector(0,0,0);
  w = new PVector(0,0,0);
  background = new PVector(0,0,0);
  disks = new Disk[0];
  ellipsoids = new Ellipsoid[0];
}

void keyPressed() {
  reset_scene();
  switch(key) {
    case '1':  interpreter("01.cli"); break;
    case '2':  interpreter("02.cli"); break;
    case '3':  interpreter("03.cli"); break;
    case '4':  interpreter("04.cli"); break;
    case '5':  interpreter("05.cli"); break;
    case '6':  interpreter("06.cli"); break;
    case '7':  interpreter("07.cli"); break;
    case '8':  interpreter("08.cli"); break;
    case '9':  interpreter("09.cli"); break;
    case '0':  interpreter("10.cli"); break;
    case '-':  interpreter("11.cli"); break;
    case 'q':  exit(); break;
  }
}

// this routine helps parse the text in the scene description files
void interpreter(String filename) {
  
  println("Parsing '" + filename + "'");
  String str[] = loadStrings(filename);
  if (str == null) println("Error! Failed to read the cli file.");
  
  for (int i = 0; i < str.length; i++) {
    
    String[] token = splitTokens(str[i], " ");  // Get a line and parse the tokens
    
    if (token.length == 0) continue; // Skip blank lines
    
    if (token[0].equals("fov")) {
      fov = float(token[1]);
      // call routine to save the field of view
    }
    else if (token[0].equals("background")) {
      float r = float(token[1]);
      float g = float(token[2]);
      float b = float(token[3]);
      // call routine to save the background color
      background = new PVector(r,g,b);
    }
    else if (token[0].equals("eye")) {
      float x = float(token[1]);
      float y = float(token[2]);
      float z = float(token[3]);
      // call routine to save the eye position
      eye = new PVector(x,y,z);
    }
    else if (token[0].equals("uvw")) {
      float ux = float(token[1]);
      float uy = float(token[2]);
      float uz = float(token[3]);
      float vx = float(token[4]);
      float vy = float(token[5]);
      float vz = float(token[6]);
      float wx = float(token[7]);
      float wy = float(token[8]);
      float wz = float(token[9]);
      // call routine to save the camera's values for u,v,w
      u = new PVector(ux, uy, uz);
      v = new PVector(vx, vy, vz);
      w = new PVector(wx, wy, wz);
    }
    else if (token[0].equals("light")) {
      float x = float(token[1]);
      float y = float(token[2]);
      float z = float(token[3]);
      float r = float(token[4]);
      float g = float(token[5]);
      float b = float(token[6]);
      // call routine to save lighting information
      lights = (Light[]) append(lights, new Light(new PVector(x,y,z), new PVector(r,g,b)));
    }
    else if (token[0].equals("surface")) {
      float Cdr = float(token[1]);
      float Cdg = float(token[2]);
      float Cdb = float(token[3]);
      float Car = float(token[4]);
      float Cag = float(token[5]);
      float Cab = float(token[6]);
      float Csr = float(token[7]);
      float Csg = float(token[8]);
      float Csb = float(token[9]);
      float P = float(token[10]);
      float K = float(token[11]);
      // call routine to save the surface material properties
      prev_surface = new Surface(
        new PVector(Cdr,Cdg,Cdb),
        new PVector(Car,Cag,Cab),
        new PVector(Csr,Csg,Csb),
        P,
        K
      );
      surfaces = (Surface[]) append(surfaces, prev_surface);
    }    
    else if (token[0].equals("disk")) {
      float x = float(token[1]);
      float y = float(token[2]);
      float z = float(token[3]);
      float nx = float(token[4]);
      float ny = float(token[5]);
      float nz = float(token[6]);
      float radius = float(token[7]);
      // call routine to save disk here
      disks = (Disk[]) append(disks, 
        new Disk(
          new PVector(x,y,z),
          new PVector(nx,ny,nz),
          radius,
          prev_surface
        )
      );
      shapes = (Shape[]) append(shapes,
        new Disk(
          new PVector(x,y,z),
          new PVector(nx,ny,nz),
          radius,
          prev_surface
        )
      );
    }
    else if (token[0].equals("ellipsoid")) {
      float x = float(token[1]);
      float y = float(token[2]);
      float z = float(token[3]);
      float rx = float(token[4]);
      float ry = float(token[5]);
      float rz = float(token[6]);
      // call routine to save ellipsoid here
      ellipsoids = (Ellipsoid[]) append(ellipsoids,
        new Ellipsoid(
          new PVector(x,y,z),
          new PVector(rx,ry,rz),
          prev_surface
        )
      );
      shapes = (Shape[]) append(shapes,
        new Ellipsoid(
          new PVector(x,y,z),
          new PVector(rx,ry,rz),
          prev_surface
        )
      );
    }
    else if (token[0].equals("write")) {
      draw_scene();   // here is where you actually perform the ray tracing
      println("Saving image to '" + token[1] + "'");
      save(token[1]); // this saves your ray traced scene to a .png file
    }
    else if (token[0].equals("#")) {
      // comment symbol (ignore this line)
    }
    else {
      println ("cannot parse this line: " + str[i]);
    }
  }
}

Hit shootRay(Ray ray) {
  Hit hitinfo = new Hit();
  hitinfo.hit = false;
  hitinfo.t = -1.0;
  float t = -1.0;
  for (int i = 0; i < shapes.length; i++) {
    if (shapes[i] instanceof Disk) {
      Disk curr_shape = (Disk) shapes[i];
      // calculate if ray intersects the disk
      float parallel = PVector.dot(curr_shape.normal, ray.d);
      if (parallel != 0.0) {
        t = PVector.dot(curr_shape.normal, PVector.sub(curr_shape.center, ray.x)) / parallel;
      } else {
        // println("eye direction is parallel to plane");
      }
      PVector intersection = PVector.add(ray.x, PVector.mult(ray.d, t)); // I = X + t*dX
      float d2c = distance2(intersection, curr_shape.center);
      // hit if distance^2 is less than radius^2
      // *** closest_d2 is the distance between intersection and eye !!
      if (t > 0 && d2c <= sq(curr_shape.radius)) {
        if (!hitinfo.hit) {
          hitinfo.hit = true;
          hitinfo.shape = curr_shape;
          hitinfo.p = intersection;
          hitinfo.t = t;
          hitinfo.surface = curr_shape.surface;
          hitinfo.normal = curr_shape.normal;
        } else if (distance2(intersection, ray.x) < distance2(hitinfo.p, ray.x)) {
          hitinfo.shape = curr_shape;
          hitinfo.p = intersection;
          hitinfo.t = t;
          hitinfo.surface = curr_shape.surface;
          hitinfo.normal = curr_shape.normal;
        }
      } else {
        // println("not on this disk");
      }
    } else if (shapes[i] instanceof Ellipsoid) {
      Ellipsoid curr_shape = (Ellipsoid) shapes[i];
      // calc if ray hits ellipsoid
      PVector xyz0 = PVector.sub(ray.x, curr_shape.center);
      float a = (sq(ray.d.x) / sq(curr_shape.radius.x)) + (sq(ray.d.y) / sq(curr_shape.radius.y)) + (sq(ray.d.z) / sq(curr_shape.radius.z));
      float b = 2 * (((xyz0.x * ray.d.x) / sq(curr_shape.radius.x)) + ((xyz0.y * ray.d.y) / sq(curr_shape.radius.y)) + ((xyz0.z * ray.d.z) / sq(curr_shape.radius.z)));
      float c = (sq(xyz0.x) / sq(curr_shape.radius.x)) + (sq(xyz0.y) / sq(curr_shape.radius.y)) + (sq(xyz0.z) / sq(curr_shape.radius.z)) - 1;
      t = getT(a,b,c);
      if (t < 0) {
        // no hit
      } else {
        PVector intersection = PVector.add(ray.x, PVector.mult(ray.d, t));
        if (!hitinfo.hit) {
          hitinfo.hit = true;
          hitinfo.shape = curr_shape;
          hitinfo.p = intersection;
          hitinfo.t = t;
          hitinfo.surface = curr_shape.surface;
          PVector sphere_normal = PVector.sub(hitinfo.p, curr_shape.center);
          hitinfo.normal = new PVector(sphere_normal.x / sq(curr_shape.radius.x), sphere_normal.y / sq(curr_shape.radius.y), sphere_normal.z / sq(curr_shape.radius.z));
        } else if (distance2(intersection, ray.x) < distance2(hitinfo.p, ray.x)) {
          hitinfo.shape = curr_shape;
          hitinfo.p = intersection;
          hitinfo.t = t;
          hitinfo.surface = curr_shape.surface;
          PVector sphere_normal = PVector.sub(hitinfo.p, curr_shape.center);
          hitinfo.normal = new PVector(sphere_normal.x / sq(curr_shape.radius.x), sphere_normal.y / sq(curr_shape.radius.y), sphere_normal.z / sq(curr_shape.radius.z));
        } else {
          // println("ellipsoid not hit)
        }
      }
    }
  }
  return hitinfo;
}

PVector colorPixel(Hit hit, Ray ray, int depth) {
  if (hit.hit) {
    PVector c = hit.surface.diffuse;
    float r = 0;
    float g = 0;
    float b = 0;
    PVector reflection_ray = new PVector(0,0,0);
    PVector reflection_color = new PVector(0,0,0);
    // reflection color
    if (depth > 0 && hit.surface.k_refl > 0) {
      reflection_ray = PVector.sub(PVector.mult(hit.normal.normalize(), (2 * PVector.dot(hit.normal.normalize(), PVector.mult(ray.d, -1)))), PVector.mult(ray.d, -1));
      PVector offset = PVector.mult(reflection_ray.normalize(), 0.0001);
      Ray reflection_ray_obj = new Ray(PVector.add(hit.p, offset), reflection_ray.normalize());
      Hit reflection_hit = shootRay(reflection_ray_obj);
      reflection_color = PVector.mult(colorPixel(reflection_hit, reflection_ray_obj, depth - 1), hit.surface.k_refl);
    }
    // lights loop
    for (int l = 0; l < lights.length; l++) {
      PVector offset = PVector.mult(PVector.sub(lights[l].pos, hit.p).normalize(), 0.0001);
      Ray shadow_ray = new Ray(PVector.add(hit.p, offset), (PVector.sub(lights[l].pos, hit.p)).normalize());
      Hit shadow_hit = shootRay(shadow_ray);
      // shadow rays
      if (shadow_hit.hit && distance2(PVector.add(hit.p, offset), lights[l].pos) > distance2(PVector.add(hit.p, offset), shadow_hit.p)) {
      } else {
        float nl = max(0, PVector.dot(hit.normal.normalize(), PVector.sub(lights[l].pos, hit.p).normalize()));
        PVector h = PVector.add(PVector.sub(ray.x, hit.p).normalize(), PVector.sub(lights[l].pos, hit.p).normalize());
        PVector c_specular = PVector.mult(hit.surface.specular, max(0, pow(PVector.dot(h.normalize(), hit.normal.normalize()), hit.surface.p)));
        PVector c_diffuse = PVector.mult(hit.surface.diffuse, nl);
        r += lights[l].c.x * (c_diffuse.x + c_specular.x);
        g += lights[l].c.y * (c_diffuse.y + c_specular.y);
        b += lights[l].c.z * (c_diffuse.z + c_specular.z);
      }
    }
    // ambient
    r += hit.surface.ambient.x * hit.surface.diffuse.x;
    g += hit.surface.ambient.y * hit.surface.diffuse.y;
    b += hit.surface.ambient.z * hit.surface.diffuse.z;
    r += reflection_color.x;
    g += reflection_color.y;
    b += reflection_color.z;
    return new PVector(r,g,b);
  } else {
    return background;
  }
}

// This is where you should place your code for creating the eye rays and tracing them.
void draw_scene() {
  PVector curr_color = new PVector(0,0,0); // initiallize variable to hold color of each pixel
  for(int y = 0; y < height; y++) {
    for(int x = 0; x < width; x++) {
      
      // maybe turn on a debug flag for a particular pixel (so you can print ray information)
      if (x == 344 && y == 223)
        debug_flag = true;
      else
        debug_flag = false;

      // calculate vars for calculating d and create Ray object
      d_d = 1.0 / (tan(radians(fov / 2.0)));
      u_u = -1 + (2.0*x / (float) width);
      v_v = -1 + (2.0*y / (float) height);
      PVector d = PVector.sub(
        PVector.sub(
          PVector.mult(u, u_u),
          PVector.mult(v, v_v)
        ),
        PVector.mult(w, d_d)
      );
      Ray eye_ray = new Ray(eye, d);

      Hit hit = shootRay(eye_ray);
      curr_color = colorPixel(hit, eye_ray, 10);
      //set the pixel color
      fill (get_rgb(curr_color.x), get_rgb(curr_color.y), get_rgb(curr_color.z));   // you should put the pixel color here, converting from [0,1] to [0,255]
      rect (x, y, 1, 1);   // make a tiny rectangle to fill the pixel
    }
  }
}

void draw() {
  // nothing should be put here for this project
}

// use this routine to find the coordinates of a particular pixel (for debugging)
void mousePressed()
{
  println ("Mouse pressed at location: " + mouseX + " " + mouseY);
}
