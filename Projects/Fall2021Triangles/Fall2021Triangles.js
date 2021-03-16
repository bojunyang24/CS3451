function setup() {
  createCanvas(900, 900);

}


function draw() {
  background(250, 190, 225); 
  noStroke();
  let center = width / 2;
  //let x = (width / 5) * sin(radians(30));
  //let y = (width / 5) * cos(radians(30));
  drawTriangleRecurs(center, center, (width / 5), 0, 0);
}

function drawTriangle(x1, y1, x2, y2, x3, y3, centerX, centerY, itr) {
  fill(155, 200, 130);
  beginShape();
  vertex(x1, y1);
  vertex(x2, y2);
  vertex(x3, y3);
  endShape(CLOSE);
}

function drawTriangleRecurs(centerX, centerY, radius, itr, parentRotation) {
  if (itr >= 10) {
    return;
  }
  let center = width / 2;
  let x = radius * sin(radians(30));
  let y = radius * cos(radians(30));
  let k = 1 - (mouseY / height);
  let x1 = centerX - x;
  let y1 = centerY + y;
  let x2 = centerX - x;
  let y2 = centerY - y;
  let x3 = centerX + radius;
  let y3 = centerY;
  let currentRotation = 0;
  
  if (itr > 0) {
    currentRotation = (radians((mouseX / width) * 120) + parentRotation) % radians(120);
    x1 = x1 - centerX;
    y1 = y1 - centerY;
    x2 = x2 - centerX;
    y2 = y2 - centerY;
    x3 = x3 - centerX;
    y3 = y3 - centerY;
    x1Temp = x1 * cos(currentRotation) - y1 * sin(currentRotation);
    y1Temp = x1 * sin(currentRotation) + y1 * cos(currentRotation);
    x2Temp = x2 * cos(currentRotation) - y2 * sin(currentRotation);
    y2Temp = x2 * sin(currentRotation) + y2 * cos(currentRotation);
    x3Temp = x3 * cos(currentRotation) - y3 * sin(currentRotation);
    y3Temp = x3 * sin(currentRotation) + y3 * cos(currentRotation);
    x1 = x1Temp + centerX;
    y1 = y1Temp + centerY;
    x2 = x2Temp + centerX;
    y2 = y2Temp + centerY;
    x3 = x3Temp + centerX;
    y3 = y3Temp + centerY;
  }
  
  drawTriangle(x1, y1, x2, y2, x3, y3, centerX, centerY, itr);
  itr++;
  drawTriangleRecurs(x1, y1, k * radius, itr, currentRotation);
  drawTriangleRecurs(x2, y2, k * radius, itr, currentRotation);
  drawTriangleRecurs(x3, y3, k * radius, itr, currentRotation);
}
