void setup() {
  size(600,600);
}

void draw() {
  background(255,255,255);
  noStroke();
  fill(150,150,255);
  
  float center = width/2;
  // middle sq. 1/3 width of screen. centered
  rect(center - width/6, center - width/6, width/3, width/3);
  float s = mouseX - center;
  float t = mouseY - center;
  fill(255, (150 + width/6) % 150, (150 + width/6) % 150);
  spread(width/6, center, center, s, t);
}

void spread(float w, float centerX, float centerY, float s, float t) {
  if(w >= width/96) {
    // 4 small squares. 1/2 width of middle sq. position offset from middle sq in a diff direction
    fill(150 - (w % 150), 150 - (w % 150), 230 - (w % 150));
    rect(centerX + s - w/2, centerY + t - w/2, w, w); // follows cursor
    spread(w/2, centerX + s, centerY + t, s/2, t/2);
    fill(150 - (w % 150), 150 - (w % 150), 230 - (w % 150));
    rect(centerX - t - w/2, centerY + s - w/2, w, w); // 90 degress right
    spread(w/2, centerX - t, centerY + s, s/2, t/2);
    fill(150 - (w % 150), 150 - (w % 150), 230 - (w % 150));
    rect(centerX - s - w/2, centerY - t - w/2, w, w); // 180 degrees right cursor
    spread(w/2, centerX - s, centerY - t, s/2, t/2);
    fill(150 - (w % 150), 150 - (w % 150), 230 - (w % 150));
    rect(centerX + t - w/2, centerY - s - w/2, w, w); // 270 degrees left
    spread(w/2, centerX + t, centerY - s, s/2, t/2);
    //fill(255, 150 - (w % 150), 150 - (w % 150));
  }
}
