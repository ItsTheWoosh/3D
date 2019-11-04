PImage qBlock;
float rotx = PI / 4, roty = PI / 4;

void setup() {
  size (800, 600, P3D);
 qBlock = loadImage("Diamond Ore.png");
 textureMode(NORMAL);
}

void draw() {
  noStroke();
  background(255);
  pushMatrix();
  translate(width / 2, height / 2);
  rotateX(rotx);
  rotateY(roty);
  scale(100);
  texturedBox(qBlock);
  popMatrix();
}

void texturedBox(PImage tex) {
  beginShape(QUADS);
  texture(tex);
  //1. Front Face
  vertex(-1, -1, 1, 0, 0);
  vertex( 1, -1, 1, 1, 0);
  vertex( 1,  1, 1, 1, 1);
  vertex(-1,  1, 1, 0, 1);
  
  //2. Back Face
  vertex(-1, -1, -1, 1, 0); //0, 0 to two
  vertex( 1, -1, -1, 0, 0); //0, 1 to three
  vertex( 1,  1, -1, 0, 1); //1, 1 to four
  vertex(-1,  1, -1, 1, 1); //1, 0 to one
  
  //3. Top Face
  vertex( 1, -1, -1, 0, 1);
  vertex(-1, -1, -1, 1, 1);
  vertex(-1, -1,  1, 1, 0);
  vertex( 1, -1,  1, 0, 0);
   
  //4. Right Face
  vertex(1, -1, 1, 0, 1);
  vertex(1, -1, -1, 1, 1);
  vertex(1, 1, -1, 1, 0);
  vertex(1, 1, 1, 0, 0);


  endShape(QUADS);
}

void mouseDragged() {
  rotx += (pmouseY - mouseY) * 0.01;
  roty -= (pmouseX - mouseX) * 0.01;
  }
