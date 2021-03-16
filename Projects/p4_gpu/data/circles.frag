// Fragment shader

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_LIGHT_SHADER

// These values come from the vertex shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

void main() {
  float x = vertTexCoord.s * 2 - 1;
  float y = vertTexCoord.t * 2 - 1;

  // x = x + 0.75*cos(3.14);
  // y = y + 0.75*sin(3.14);
  // if (pow(x,2) + pow(y,2) <= pow(0.125,2)) {
  //   gl_FragColor = vec4(0.2, 0.4, 1.0, vertTexCoord.s);
  // } else {
  //   gl_FragColor = vec4(1.0, 0.0, 0.0, 1);
  // }

  bool hit = false;
  float theta = 3.14;
  float opacity = 1.0;
  for (int i = 0; i < 8; i ++) {
    float cx = x + 0.75*cos((theta/4)*i);
    float cy = y + 0.75*sin((theta/4)*i);
    if (pow(cx,2) + pow(cy,2) <= pow(0.2,2)) {
      gl_FragColor = vec4(0.4, 0.25, 0.7, (opacity - ((1/9.0) * i)));
      hit = true;
    }
  }
  if (!hit) {
    gl_FragColor = vec4(0.8, 1.0, 0.0, 0);
  }
  
  // if (pow(x,2) + pow(y,2) <= 1) {
  //   gl_FragColor = vec4(0.2, 0.4, 1.0, vertTexCoord.s);
  // } else {
  //   gl_FragColor = vec4(0.2, 0.4, 1.0, 0);
  // }
  // gl_FragColor = vec4(0.4, 0.25, 0.7, vertTexCoord.s);
}

