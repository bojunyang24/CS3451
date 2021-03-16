// Fragment shader

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXLIGHT_SHADER

// set by host code
uniform float time;

// Set in Processing
uniform sampler2D texture;

// These values come from the vertex shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;


void main() { 
  vec4 diffuse_color = texture2D(texture, vertTexCoord.xy);
  float diffuse = clamp(dot (vertNormal, vertLightDir),0.0,1.0);

  if (vertTexCoord.x < time) {
    vec2 d = textureSize(texture, 0);
    float dx = 1.0/d.x;
    float dy = 1.0/d.y;

    vec4 up = texture2D(texture, vec2(vertTexCoord.x, vertTexCoord.y - dy));
    vec4 down = texture2D(texture, vec2(vertTexCoord.x, vertTexCoord.y + dy));
    vec4 left = texture2D(texture, vec2(vertTexCoord.x - dx, vertTexCoord.y));
    vec4 right = texture2D(texture, vec2(vertTexCoord.x + dx, vertTexCoord.y));
    float r = (up.r + down.r + left.r + right.r) - (4.0 * diffuse_color.r);
    float g = (up.g + down.g + left.g + right.g) - (4.0 * diffuse_color.g);
    float b = (up.b + down.b + left.b + right.b) - (4.0 * diffuse_color.b);
    float N = (r+g+b)/1.5;
    N =(N + 0.5);
    gl_FragColor = vec4(N, N, N, 1.0);
  } else {
    gl_FragColor = vec4(diffuse * diffuse_color.rgb, 1.0);
  }

  
}