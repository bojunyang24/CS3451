/**
Bojun Yang
Not sure if you will read this but
Project Checklist: you can search the #checklistitem to find my code that satisfies the requirement :)
#cameramotion: I move the camera to follow my character. after he falls, I pad around to get a close up of him on the ground. then the camera follows him to fly
#objectanimation: The animation for the sword and character are the same. But I animate my legs separately from the body. The wings animation is also a separate object motion.
#objectinstance: I make a world consisting of 4 repeated scenes. 1 scene consists of multiple trees. 
#lighting: I have one light towards the -x and -y direction to simulate a sun. I also have one in the z direction to illuminate the side of the objects that the camera sees. I also use ambient and specular lighting.

Notes: Animation ends when he flys off into the distance.
I spent a lot of time on making the legs run and look like actual running. 
**/

float time = 0;  // keep track of the passing of time

// animation transition times/periods
float startRunning = 0;
float stopRunning = 5;
float startFalling = 5;
float stopFalling = 11;
float toGround = 9;
float startPanning = 11;
float stopPanning = 13;
float startSadness = 13.2;
float sadZoom = 14.5;
float stopSadZoom = 17;
float growWings = 20;
float fly = 21;

// use this to keep track of which set of legs to draw to animate running
int runCycle = 0;

// colors used for legs if you want to see that they are actually making the full running cycles
boolean legcolors = false; // change to true to set one leg to blue and other to red
float b1;
float b2;
float b3;
float r1;
float r2;
float r3;

void setup() {
  size(800, 800, P3D);  // must use 3D here!
  noStroke();           // do not draw the edges of polygons
}

// Draw a scene with a cylinder, a box and a sphere
void draw() {
  
  resetMatrix();  // set the transformation matrix to the identity (important!)

  // background color animation sequences
  if (time > startSadness && time < fly) {
    float sad = max(255.0 - (time-startSadness)*50,170);
    background(sad,sad,sad);
  } else if (time > fly) {
    float happy = min(170.0 + (time - fly) * 50, 255);
    background(happy,happy,happy);
  } else {
    background(255, 255, 255);  // clear the screen to white
  }
  

  // set up for perspective projection
  perspective (PI * 0.333, 1.0, 0.01, 1000.0);

  // camera animation sequences #cameramotion
  if (time < stopFalling) {
    camera (0.0 + (time*10), 0.0, 85.0, 0.0 + (time*10), 0.0, -1.0, 0.0, 1.0, 0.0);
  } else if (time < stopPanning) {
    camera (0.0 + (time*10), 0.0, 85.0, (stopFalling*10) - ((time - stopFalling)*10), 0.0, -1.0, 0.0, 1.0, 0.0);
  } else if (time > stopPanning && time < sadZoom) {
    camera (0.0 + (stopPanning*10), 0.0, 85.0, (stopFalling*10) - ((stopPanning - stopFalling)*10), 0.0, -1.0, 0.0, 1.0, 0.0);
  } else if (time > sadZoom && time < stopSadZoom) {
    camera (0.0 + (stopPanning*10), 0.0, 85.0 - (time - sadZoom)*10, (stopFalling*10) - ((stopPanning - stopFalling)*10), 0.0, -1.0, 0.0, 1.0, 0.0);
  } else if (time > stopSadZoom && time < fly) {
      camera (0.0 + (stopPanning*10), 0.0, 85.0 - (stopSadZoom - sadZoom)*10, (stopFalling*10) - ((stopPanning - stopFalling)*10), 0.0, -1.0, 0.0, 1.0, 0.0);
  } else if (time > fly) {
    camera (0.0 + (stopPanning*10) + (time-fly)*8, (time - fly)*2, 85.0 - (stopSadZoom - sadZoom)*10, (stopFalling*10) - ((stopPanning - stopFalling)*10) + (time-fly)*10, 0.0, -1.0, 0.0, 1.0, 0.0);
  }
  
  // #lighting
  ambientLight (10, 10, 10);
  lightSpecular (204, 204, 204);
  directionalLight (255, 253, 224, 70, 100, -50);
  directionalLight (64, 64, 60, 0, 0, -1);

  // Scene of trees #objectinstance
  pushMatrix();
  translate(0,-5,0);
  scene(); //1
  translate(65,2,0);
  scene(); //2
  translate(65,-3,0);
  scene(); //3
  translate(65,1,0);
  scene(); //4
  popMatrix();

  // MODEL
  // Sword
  float modelScale = 0.5; // scale the model(character + sword) to be smaller
  pushMatrix();
  fill (0, 0, 0);
  ambient (50, 50, 50);
  specular (155, 155, 155);
  shininess (15.0);
  
  // moving the sword throughout the animation #objectanimation
  if (time > startRunning && time < stopRunning) {
    translate(time*10,0,0);
  } else if (time > startFalling && time < stopFalling) {
    if (time > toGround) {
      translate(time*10, (time - toGround)*5, 0);
      rotateZ((toGround - startFalling)*5.1);
    } else {
      translate(time*10,0,0);
      rotateZ((time - startFalling )*5.1);
    }
  } else if (time > stopFalling && time < stopSadZoom) {
    translate(stopFalling*10,(stopFalling - toGround)*5,0);
    rotateZ((toGround - startFalling)*5.1);
  } else if (time > stopSadZoom && time < fly) {
    translate(stopFalling*10,(stopFalling - toGround)*5,0);
    rotateZ((toGround - startFalling)*5.1);
  } else if (time > fly) {
    translate((stopFalling*10) + (time - fly)*8, ((stopFalling - toGround)*5) - (time - fly)*2, (time-fly)*0.5);
    rotateY(min(radians(55),(time-fly)*0.05));
    rotateZ(((toGround - startFalling)*5.1) - min((time - fly)*0.5, radians(25)));
  }
  scale(modelScale,modelScale,modelScale);
  sword(16, 15);
  popMatrix(); // END SWWORD

  // character model
  pushMatrix();
  // moving the character model throughout the animation #objectanimation
  if (time > startRunning && time < stopRunning) {
    translate(time*10,0,0);
  } else if (time > startFalling && time < stopFalling) {
    if (time > toGround) {
      translate(time*10, (time - toGround)*5, 0);
      rotateZ((toGround - startFalling)*5.1);
    } else {
      translate(time*10,0,0);
      rotateZ((time - startFalling )*5.1);
    }
  } else if (time > stopFalling && time < stopSadZoom) {
    translate(stopFalling*10,(stopFalling - toGround)*5,0);
    rotateZ((toGround - startFalling)*5.1);
  } else if (time > stopSadZoom && time < fly) {
    translate(stopFalling*10,(stopFalling - toGround)*5,0);
    rotateZ((toGround - startFalling)*5.1);
  } else if (time > fly) {
    translate((stopFalling*10) + (time - fly)*8, ((stopFalling - toGround)*5) - (time - fly)*2, (time-fly)*0.5);
    rotateY(min(radians(55),(time-fly)*0.05));
    rotateZ(((toGround - startFalling)*5.1) - min((time - fly)*0.5, radians(25)));
  }
  scale(modelScale,modelScale,modelScale);
  myDude(time);
  popMatrix(); // END CHARACTER
  // END MODEL

  // step forward the time
  time += 0.03;
}

// creates a lance type sword with steps-polygon as the base and length of height. it's a cone plus a cylinder for the handle
void sword(float steps, float height) {
  pushMatrix();
  translate(-5.5,-2,3);
  rotateZ(-PI/2);
  rotateY(PI/6);
  scale(1.5, 1, 2);

  // even steps only cuz I'm doing this on a plane and don't know how to find the centroid of a polygon
  // makes a cone
  if (steps%2 == 1) {
    steps += 1;
  }
  float c_x = (cos(2*PI) + cos(PI)) / 2;
  float c_y = (sin(2*PI) + sin(PI)) / 2;
  float x0, x1, y0, y1, theta;
  x0 = 0.0;
  y0 = 0.0;
  for(int i = 0; i <= steps; i++) {
    theta = 2 * PI * i / steps;
    x1 = cos(theta);
    y1 = sin(theta);
    beginShape(TRIANGLES);
    vertex(0, x0, y0);
    vertex(0, x1, y1);
    vertex(height, c_x, c_y);
    endShape();
    x0 = x1;
    y0 = y1;
  }
  sphere(1);
  pushMatrix();
  rotateZ(radians(90));
  translate(0, height/15, 0);
  cylinder(0.25, height/10.0, int(steps));
  popMatrix();
  popMatrix();
}

// Creates one scene of trees #objectinstance
void scene() {
  pushMatrix();
  translate(-20,0,45);
  rotateY(radians(10));
  tree();
  popMatrix();
  
  pushMatrix();
  translate(-10,-2,-50);
  rotateY(radians(30));
  tree();
  popMatrix();

  pushMatrix();
  translate(10,2,-25);
  rotateY(radians(20));
  tree();
  popMatrix();

  pushMatrix();
  translate(4,1,15);
  rotateY(radians(10));
  tree();
  popMatrix();

  pushMatrix();
  translate(35,-1,-35);
  rotateY(radians(40));
  tree();
  popMatrix();

  pushMatrix();
  translate(45,0,-25);
  rotateY(radians(40));
  tree();
  popMatrix();

  // pushMatrix();
  // translate(15,-4,-8);
  // rotateY(radians(50));
  // tree();
  // popMatrix();

  // pushMatrix();
  // translate(35,-6,-12);
  // rotateY(radians(60));
  // tree();
  // popMatrix();
}

// creates one tree #objectinstance
void tree() {
  pushMatrix();
  fill(74, 41, 7);
  ambient (74, 41, 7);
  shininess (15.0);
  cylinder(3, 12, 15);
  popMatrix();
  pushMatrix();
  ambient (174, 80, 30);
  shininess (20.0);

  pushMatrix();
  fill(97, 227, 79);
  translate(-2.5,-3,0);
  sphere(7);
  popMatrix();

  pushMatrix();
  fill(140, 227, 85);
  translate(0,-5,2);
  sphere(4);
  popMatrix();

  pushMatrix();
  fill(100, 200, 95);
  translate(2,-3,0);
  sphere(5);
  popMatrix();

  pushMatrix();
  fill(97, 227, 79);
  translate(-4,-4,0);
  sphere(6);
  popMatrix();

  popMatrix();
}

/**
Character:
2 arms (2 limbs each)
2 legs (2 limbs each)
shoulder (2 shoulderpads each)
wings (2 shoulderpads...just bigger)
face (2 eyes)
body (1 cylinder, 2 spheres, 3 stripes)
**/
void myDude(float time) {
  pushMatrix();
  head();
  popMatrix();

  // draw body
  pushMatrix();
  fill (128, 159, 209);
  ambient (50, 50, 50);
  specular (155, 155, 155);
  shininess (50.0);

  body();
  popMatrix();

  // Draw the shoulders
  pushMatrix();
  fill (7, 25, 54);
  ambient (50, 50, 50);
  specular (155, 155, 155);
  shininess (15.0);

  shoulder();
  popMatrix();

  // Draw arms and legs
  pushMatrix();
  fill (0, 0, 0);
  ambient (50, 50, 50);
  specular (155, 155, 155);
  shininess (100);

  arms();
  legs(time);
  popMatrix();

  // WINGS
  pushMatrix();
    fill (196, 255, 199);
    ambient (50, 50, 50);
    specular (155, 155, 155);
    shininess (15);
    wings(time);
  popMatrix();
}

void head() {
  // Draw the head

  pushMatrix();

  fill (7, 25, 54);
  ambient (50, 50, 50);
  specular (155, 155, 155);
  shininess (15.0);

  pushMatrix();
  scale(4,4,4);
  translate(0, -4, 0);
  sphere(1);
  popMatrix();

  popMatrix();

  // Draw the eyes

  pushMatrix();

  fill (255, 165, 0);
  ambient (50, 50, 50);
  specular (155, 155, 155);
  shininess (15.0);

  rotateY(radians(90));
  translate(2, -16, 3);
  eye();

  popMatrix();

  pushMatrix();

  fill (255, 165, 0);
  ambient (50, 50, 50);
  specular (155, 155, 155);
  shininess (15.0);

  rotateY(radians(90));
  translate(-2, -16, 3);
  eye();

  popMatrix();
}

void body() {
  pushMatrix();
  scale(0.8, 0.9, 1);
  pushMatrix();
  scale(6,6,4.5);
  sphere(1);
  popMatrix();

  pushMatrix();
  scale(1, 3, 4.5/6);
  translate(0, -3, 0);
  cylinder(6, 3, 50);
  popMatrix();

  pushMatrix();
  translate(0, -9, 0);
  scale(6,6,4.5);
  sphere(1);
  popMatrix();

  pushMatrix();
  fill(0,0,0);
  translate(0, 0, 0);
  scale(1, 0.1, 4.5/6);
  cylinder(6, 3, 50);
  popMatrix();

  pushMatrix();
  fill(0,0,0);
  translate(0, -2, 0);
  scale(1, 0.1, 4.5/6);
  cylinder(6, 3, 50);
  popMatrix();

  pushMatrix();
  fill(0,0,0);
  translate(0, -5, 0);
  scale(1, 0.1, 4.5/6);
  cylinder(6, 3, 50);
  popMatrix();
  
  pushMatrix();
  fill(0,0,0);
  translate(0, -9, 0);
  scale(1, 0.1, 4.5/6);
  cylinder(6, 3, 50);
  popMatrix();
  popMatrix();
}

void shoulder() {
  pushMatrix();
  rotateX(radians(90));
  rotateY(radians(180));
  translate(0, 0, -10);

  pushMatrix();
  translate(0, 6, 0);
  rotateX(radians(20));
  shoulderPad();
  popMatrix();

  pushMatrix();
  translate(0, 0, -1);
  scale(5,5,1);
  sphere(1);
  popMatrix();

  pushMatrix();
  translate(0, -6, 0);
  rotateZ(radians(180));
  rotateX(radians(20));
  shoulderPad();
  popMatrix();  

  popMatrix();
}

void legs(float time) {
  if (legcolors) {
    float b1 = 46;
    float b2 = 77;
    float b3 = 255;
    float r1 = 255;
    float r2 = 38;
    float r3 = 132;
  } else {
    float b1 = 0;
    float b2 = 0;
    float b3 = 0;
    float r1 = 0;
    float r2 = 0;
    float r3 = 0;
  }
  if (time > startRunning && time <stopRunning) {
    //RUNCYCLES #objectanimation
    //  0=extrema, 1=thedown 2, 3=pass, 4=thehigh, 5,
    //  6=extrema', 7=thedown' 8, 9=pass', 10=thehigh', 11,
    
    switch (runCycle) {
      case 0:
      case 1:
        pushMatrix();
        fill(b1,b2,b3); //blue
        translate(0, 7.5, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(5));
        limb();
        popMatrix();

        pushMatrix();
        fill(b1,b2,b3); //blue
        translate(-3, 9.5, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(120));
        limb();
        popMatrix();

        pushMatrix();
        fill(r1,r2,r3); //red
        translate(0, 7.5, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-20));
        limb();
        popMatrix();

        pushMatrix();
        fill(r1,r2,r3); //red
        translate(0.5, 12.5, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(10));
        limb();
        popMatrix();
        runCycle++;
        break;
      case 2:
      case 3:
        pushMatrix();
        fill(b1,b2,b3); //blue
        translate(0, 7.5, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-20));
        limb();
        popMatrix();

        pushMatrix();
        fill(b1,b2,b3); //blue
        translate(-1.5, 9.5, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(120));
        limb();
        popMatrix();

        pushMatrix();
        fill(r1,r2,r3); //red
        translate(0, 7.5, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-5));
        limb();
        popMatrix();

        pushMatrix();
        fill(r1,r2,r3); //red
        translate(0, 12.5, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(10));
        limb();
        popMatrix();
        runCycle++;
        break;
      case 4:
      case 5:
        pushMatrix();
        fill(b1,b2,b3); //blue
        translate(2, 7.5, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-45));
        limb();
        popMatrix();

        pushMatrix();
        fill(b1,b2,b3); //blue
        translate(0.5, 9.5, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(85));
        limb();
        popMatrix();

        pushMatrix();
        fill(r1,r2,r3); //red
        translate(0, 7.5, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(5));
        limb();
        popMatrix();

        pushMatrix();
        fill(r1,r2,r3); //red
        translate(-1, 12.5, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(20));
        limb();
        popMatrix();
        runCycle++;
        break;
      case 6:
      case 7:
        pushMatrix();
        fill(b1,b2,b3); //blue
        translate(3, 6.25, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-75));
        limb();
        popMatrix();

        pushMatrix();
        fill(b1,b2,b3); //blue
        translate(3.5, 10, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(40));
        limb();
        popMatrix();

        pushMatrix();
        fill(r1,r2,r3); //red
        translate(0, 7.5, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(15));
        limb();
        popMatrix();

        pushMatrix();
        fill(r1,r2,r3); //red
        translate(-2, 12.5, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(25));
        limb();
        popMatrix();
        runCycle++;
        break;
      case 8:
      case 9:
        pushMatrix();
        fill(b1,b2,b3); //blue
        translate(3, 6.25, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-72));
        limb();
        popMatrix();

        pushMatrix();
        fill(b1,b2,b3); //blue
        translate(6, 11, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(3));
        limb();
        popMatrix();

        pushMatrix();
        fill(r1,r2,r3); //red
        translate(0, 7.5, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(35));
        limb();
        popMatrix();

        pushMatrix();
        fill(r1,r2,r3); //red
        translate(-4.5, 12, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(65));
        limb();
        popMatrix();
        runCycle++;
        break;
      case 10:
      case 11:
        pushMatrix();
        fill(b1,b2,b3); //blue
        translate(3, 6.25, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-65));
        limb();
        popMatrix();

        pushMatrix();
        fill(b1,b2,b3); //blue
        translate(6.5, 11, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-10));
        limb();
        popMatrix();

        pushMatrix();
        fill(r1,r2,r3); //red
        translate(0, 7.5, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(30));
        limb();
        popMatrix();

        pushMatrix();
        fill(r1,r2,r3); //red
        translate(-5, 10, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(105));
        limb();
        popMatrix();
        runCycle++;
        break;
      case 12:
      case 13:
        pushMatrix();
        fill(b1,b2,b3); //blue
        translate(0, 7.5, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-20));
        limb();
        popMatrix();

        pushMatrix();
        fill(b1,b2,b3); //blue
        translate(0.5, 12.5, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(10));
        limb();
        popMatrix();

        pushMatrix();
        fill(r1,r2,r3); //red
        translate(0, 7.5, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(5));
        limb();
        popMatrix();

        pushMatrix();
        fill(r1,r2,r3); //red
        translate(-3, 9.5, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(120));
        limb();
        popMatrix();
        runCycle++;
        break;
      case 14:
      case 15:
        pushMatrix();
        fill(b1,b2,b3); //blue
        translate(0, 7.5, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-5));
        limb();
        popMatrix();

        pushMatrix();
        fill(b1,b2,b3); //blue
        translate(0, 12.5, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(10));
        limb();
        popMatrix();

        pushMatrix();
        fill(r1,r2,r3); //red
        translate(0, 7.5, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-20));
        limb();
        popMatrix();

        pushMatrix();
        fill(r1,r2,r3); //red
        translate(-1.5, 9.5, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(120));
        limb();
        popMatrix();
        runCycle++;
        break;
      case 16:
      case 17:
        pushMatrix();
        fill(b1,b2,b3); //blue
        translate(0, 7.5, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(5));
        limb();
        popMatrix();

        pushMatrix();
        fill(b1,b2,b3); //blue
        translate(-1, 12.5, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(20));
        limb();
        popMatrix();

        pushMatrix();
        fill(r1,r2,r3); //red
        translate(2, 7.5, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-45));
        limb();
        popMatrix();

        pushMatrix();
        fill(r1,r2,r3); //red
        translate(0.5, 9.5, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(85));
        limb();
        popMatrix();
        runCycle++;
        break;
      case 18:
      case 19:
        pushMatrix();
        fill(b1,b2,b3); //blue
        translate(0, 7.5, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(15));
        limb();
        popMatrix();

        pushMatrix();
        fill(b1,b2,b3); //blue
        translate(-2, 12.5, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(25));
        limb();
        popMatrix();

        pushMatrix();
        fill(r1,r2,r3); //red
        translate(3, 6.25, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-75));
        limb();
        popMatrix();

        pushMatrix();
        fill(r1,r2,r3); //red
        translate(3.5, 10, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(40));
        limb();
        popMatrix();
        runCycle++;
        break;
      case 20:
      case 21:
        pushMatrix();
        fill(b1,b2,b3); //blue
        translate(0, 7.5, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(35));
        limb();
        popMatrix();

        pushMatrix();
        fill(b1,b2,b3); //blue
        translate(-4.5, 12, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(65));
        limb();
        popMatrix();

        pushMatrix();
        fill(r1,r2,r3); //red
        translate(3, 6.25, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-72));
        limb();
        popMatrix();

        pushMatrix();
        fill(r1,r2,r3); //red
        translate(6, 11, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(3));
        limb();
        popMatrix();
        runCycle++;
        break;
      case 22:
      case 23:
        pushMatrix();
        fill(b1,b2,b3); //blue
        translate(0, 7.5, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(30));
        limb();
        popMatrix();

        pushMatrix();
        fill(b1,b2,b3); //blue
        translate(-5, 10, 2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(105));
        limb();
        popMatrix();

        pushMatrix();
        fill(r1,r2,r3); //red
        translate(3, 6.25, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-65));
        limb();
        popMatrix();

        pushMatrix();
        fill(r1,r2,r3); //red
        translate(6.5, 11, -2);
        scale(1.2, 1.2, 1.5);
        rotateZ(radians(-10));
        limb();
        popMatrix();
        runCycle++;
        break;
      default:
        if (runCycle == 24) {
          runCycle = 0;
        } else {
          runCycle++;
        }
        break;  
    }
  } else {
    // neutral standing position
    pushMatrix();
    fill(b1,b2,b3);
    translate(0.5, 7.5, 2);
    scale(1.2, 1.2, 1.5);
    rotateZ(radians(-10));
    limb();
    popMatrix();

    pushMatrix();
    fill(b1,b2,b3);
    translate(0.5, 12.5, 2);
    scale(1.2, 1.2, 1.5);
    rotateZ(radians(10));
    limb();
    popMatrix();

    pushMatrix();
    fill(r1,r2,r3);
    translate(0.5, 7.5, -2);
    scale(1.2, 1.2, 1.5);
    rotateZ(radians(-10));
    limb();
    popMatrix();

    pushMatrix();
    fill(r1,r2,r3);
    translate(0.5, 12.5, -2);
    scale(1.2, 1.2, 1.5);
    rotateZ(radians(10));
    limb();
    popMatrix();
  }
}

void arms() {
  pushMatrix();
  rotateX(radians(45));
  translate(0, -0.5, 10); // (z,x,y)
  scale(1.2, 1.2, 1.5);
  limb();
  popMatrix();

  pushMatrix();
  rotateX(radians(0));
  translate(0, -2.5, 9); // (z,y,x)
  scale(1.2, 1.2, 1.5);
  limb();
  popMatrix();

  pushMatrix();
  rotateX(radians(-45));
  translate(0, -0.5, -10); // (z,x,y)
  scale(1.2, 1.2, 1.5);
  limb();
  popMatrix();

  pushMatrix();
  rotateX(radians(0));
  translate(0, -2.5, -9); // (z,y,x)
  scale(1.2, 1.2, 1.5);
  limb();
  popMatrix();

  pushMatrix();
  rotateX(radians(-45));
  translate(0, -0.5, -10); // (z,x,y)
  scale(1.2, 1.2, 1.5);
  limb();
  popMatrix();
}

void limb() {
  pushMatrix();
  translate(0, -2.5, 0);
  cylinder(0.5, 5, 10);
  popMatrix();

  pushMatrix();
  translate(0, -2.5, 0);
  sphere(0.45);
  popMatrix();

  pushMatrix();
  translate(0, 2.5, 0);
  sphere(0.45);
  popMatrix();
}

// draws wings and makes them vibrate like a hummingbird wings #objectanimation
void wings(float time) {
  if (time > growWings && time < fly) {
    pushMatrix();
    translate(-6,1,0);
    scale(2,2,2);
    pushMatrix();
    translate(0,-5,-5);
    rotateX(radians(45));
    rotateZ(radians(-30));
    rotateY(radians(90));
    shoulderPad();
    popMatrix();
    pushMatrix();
    translate(0,-5,5);
    rotateX(radians(-45));
    rotateZ(radians(-30));
    rotateY(radians(90));
    shoulderPad();
    popMatrix();
    popMatrix();
  } else if (time > fly) {
    // if I rotate the angle of the wings within a range of angles, the animation happens fast enough to visualize flapping of hummingbirdlike wings
    pushMatrix();
    translate(-6,1,0);
    scale(2,2,2);
    pushMatrix();
    translate(0,-5,-5);
    rotateX(radians(45));
    rotateZ(radians(random(-38, -22)));
    rotateY(radians(90));
    shoulderPad();
    popMatrix();
    pushMatrix();
    translate(0,-5,5);
    rotateX(radians(-45));
    rotateZ(radians(random(-38,-22)));
    rotateY(radians(90));
    shoulderPad();
    popMatrix();
    popMatrix();
  }
}

void shoulderPad() {
  pushMatrix();
  rotateZ(radians(-35));
  translate(-1.5, 0, 0);
  scale(2, 5, 1);
  sphere(1);
  popMatrix();

  pushMatrix();
  rotateZ(radians(35));
  translate(1.5, 0, 0);
  scale(2, 5, 1);
  sphere(1);
  popMatrix();

  pushMatrix();
  scale(2, 4, 1);
  sphere(1);
  popMatrix();
}

void eye() {
  pushMatrix();
  scale(1, 1.5, 0.75);
  sphere(1);
  popMatrix();
}

// Draw a cylinder of a given radius, height and number of sides.
// The base is on the y=0 plane, and it extends vertically in the y direction.
void cylinder (float radius, float height, int sides) {
  int i,ii;
  float []c = new float[sides];
  float []s = new float[sides];

  for (i = 0; i < sides; i++) {
    float theta = TWO_PI * i / (float) sides;
    c[i] = cos(theta);
    s[i] = sin(theta);
  }
  
  // bottom end cap
  
  normal (0.0, -1.0, 0.0);
  for (i = 0; i < sides; i++) {
    ii = (i+1) % sides;
    beginShape(TRIANGLES);
    vertex (c[ii] * radius, 0.0, s[ii] * radius);
    vertex (c[i] * radius, 0.0, s[i] * radius);
    vertex (0.0, 0.0, 0.0);
    endShape();
  }
  
  // top end cap

  normal (0.0, 1.0, 0.0);
  for (i = 0; i < sides; i++) {
    ii = (i+1) % sides;
    beginShape(TRIANGLES);
    vertex (c[ii] * radius, height, s[ii] * radius);
    vertex (c[i] * radius, height, s[i] * radius);
    vertex (0.0, height, 0.0);
    endShape();
  }
  
  // main body of cylinder
  for (i = 0; i < sides; i++) {
    ii = (i+1) % sides;
    beginShape();
    normal (c[i], 0.0, s[i]);
    vertex (c[i] * radius, 0.0, s[i] * radius);
    vertex (c[i] * radius, height, s[i] * radius);
    normal (c[ii], 0.0, s[ii]);
    vertex (c[ii] * radius, height, s[ii] * radius);
    vertex (c[ii] * radius, 0.0, s[ii] * radius);
    endShape(CLOSE);
  }
}
