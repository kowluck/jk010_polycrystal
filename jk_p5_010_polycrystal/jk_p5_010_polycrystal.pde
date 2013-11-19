// Nov 2013
// http://jiyu-kenkyu.org
// http://kow-luck.com
//
// This work is licensed under a Creative Commons 3.0 License.
// (Attribution - NonCommerical - ShareAlike)
// http://creativecommons.org/licenses/by-nc-sa/3.0/
// 
// This basically means, you are free to use it as long as you:
// 1. give http://kow-luck.com a credit
// 2. don't use it for commercial gain
// 3. share anything you create with it in the same way I have
//
// If you want to use this work as more free, or encourage me,
// please contact me via http://kow-luck.com/contact

//========================================
import processing.opengl.*;

int nodesNUM = 250;
Nodes[] nodes = new Nodes[nodesNUM];
float stepX, angleStep;
float xStart, centY, centZ;
float radius, angle, rad;
float xPos, yPos, zPos;

float[]radNoize = new float[nodesNUM];
float[]xNoize = new float[nodesNUM];
float radiusInc = 16;

float rotEyeX, rotEyeY, rotEyeZ;

//========================================
void setup() {
  size(1280, 720, OPENGL);
  frameRate(30);

  for (int i = 0; i < nodesNUM; i++) { 
    nodes[i] = new Nodes(200);
    radNoize[i] = random(-100, 100);
    xNoize[i] = random(-7, 7);
  }
  radius = height/2;

  rotEyeX = 0;
  rotEyeY = 0;
  rotEyeZ = 0;
}

//========================================
void draw() {
  background(255);
  ambientLight(150, 150, 150);
  directionalLight(250, 250, 250, 1, 1, -1);
  translate(width/2, height/2, -width/3);

  eyeRotation();

  drawMe();

  println(frameRate);
}

//=======================================
void drawMe() {
  xStart = -width*2;
  stepX = width*4/nodesNUM;
  angle = 0;
  angleStep = stepX/3;
  centY = 0;
  centZ = 0;

  pushMatrix();
  rotateX(frameCount *0.01);
  for (int i = 0; i < nodesNUM; i++) { 
    xPos = xStart + stepX*i + pow(xNoize[i], 3);
    angle += angleStep;
    rad = radians(angle);
    yPos = centY + (pow(sin(rad), 1) * (radius + radNoize[i])); 
    zPos = centZ + (cos(rad) * (radius + radNoize[i])) * 1.5; 

    pushMatrix();
    translate(xPos, yPos, zPos);
    nodes[i].display();
    popMatrix();
  }
  if (radius < -height*1.5 || radius > height*1.5) {
    radiusInc *=-1;
  }
  popMatrix();
  radius += radiusInc;
}

//========================================
void eyeRotation() {
  rotateX(radians(rotEyeX) + radians(mouseY/2));
  rotateY(radians(rotEyeX) + radians(mouseX/2));
  rotateZ(radians(rotEyeX));
  rotEyeX += 0.4;
  rotEyeY += 1.0;
  rotEyeZ += 1.4;
  if (radians(rotEyeX) + radians(mouseY) > 360) {
    rotEyeX = 0;
  }
  if (radians(rotEyeY) + radians(mouseY) > 360) {
    rotEyeY = 0;
  }
  if (radians(rotEyeZ) > 360) {
    rotEyeZ = 0;
  }
}
//======================== 
public class Nodes {

  int NUM = 8;

  float[] xPos = new float[NUM];
  float[] yPos = new float[NUM];
  float[] zPos = new float[NUM];
  float[] xMov = new float[NUM];
  float[] yMov = new float[NUM];
  float[] zMov = new float[NUM];
  float[] rotBoxX = new float[NUM];
  float[] rotBoxY = new float[NUM];
  float[] rotBoxZ = new float[NUM];

  float lineAlpha;
  float boxW, boxH, boxD;

  float bounceArea;

  //======================== 
  Nodes(int _bounceArea) {
    bounceArea = _bounceArea;

    for (int i=0; i<NUM; i++) {
      xPos[i] = random(-bounceArea/2, bounceArea/2);
      yPos[i] = random(-bounceArea/2, bounceArea/2);
      zPos[i] = random(-bounceArea/2, bounceArea/2);
      xMov[i] = random(-4, 4);
      yMov[i] = random(-2, 2);
      zMov[i] = random(-6, 6);
      rotBoxX[i] = random(0, 360);
      rotBoxY[i] = random(0, 360);
      rotBoxZ[i] = random(0, 360);
    }
  }

  //========================
  public void display() {
    colorMode(RGB, 255, 255, 255, bounceArea);
    this.drawMe();
    this.moveAndBounce();
  }

  //========================
  private void drawMe() {
    boxW = bounceArea / 4;
    boxH = bounceArea / 1.5;
    boxD = bounceArea / 30;
    sphereDetail(14);

    for (int i = 1; i < NUM; i++) {
      pushMatrix();
      translate(xPos[i], yPos[i], zPos[i]);
      rotBoxX[i] += 2;
      rotBoxY[i] += 5;
      rotBoxZ[i] += 6;
      rotateX(radians(rotBoxX[i]));
      rotateY(radians(rotBoxY[i]));
      rotateZ(radians(rotBoxZ[i]));

      if (radians(rotBoxX[i]) + radians(mouseY) > 360) {
        rotBoxX[i] = 0;
      }
      if (radians(rotBoxY[i]) + radians(mouseY) > 360) {
        rotBoxY[i] = 0;
      }
      if (radians(rotBoxZ[i]) > 360) {
        rotBoxZ[i] = 0;
      }
      noStroke();
      fill(160, 130);
      box(boxW, boxH, boxD);
      popMatrix();

      for (int j = i; j < NUM; j++) {
        lineAlpha = bounceArea - (dist(xPos[i], yPos[i], zPos[i], xPos[j], yPos[j], zPos[j]));
        strokeWeight(4);
        stroke(50, 50, 50, lineAlpha);
        line(xPos[i], yPos[i], zPos[i], xPos[j], yPos[j], zPos[j]);
      }
    }
  }

  //========================
  private void moveAndBounce() {
    for (int i = 1; i < NUM; i++) {
      xPos[i] += xMov[i];
      yPos[i] += yMov[i];
      zPos[i] += zMov[i];

      if (xPos[i] < -bounceArea/2 || xPos[i] > bounceArea/2) {
        xMov[i] *=-1;
      }
      if (yPos[i] < -bounceArea/2 || yPos[i] > bounceArea/2) {
        yMov[i] *=-1;
      }
      if (zPos[i] < -bounceArea/2 || zPos[i] > bounceArea/2) {
        zMov[i] *=-1;
      }
    }
  }
}

