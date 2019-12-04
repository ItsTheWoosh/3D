//color pallette
color black = #000000;
color white = #FFFFFF;

//variables
PImage map;
boolean up, down, right, left;
float lx = 2500, ly = height / 2, lz = 2500, headAngle = 0;
PVector direction = new PVector(0, -1);
ArrayList<bullet> bullets = new ArrayList<>();

//textures
PImage qblock, dT, dS, dB;

//World manipulation

float rotx = PI/4, roty = PI/4;
int bs = 10;

void setup() {
  size(800, 600, P3D);

  //load textures
  qblock = loadImage("Diamond Ore.png");
  dT     = loadImage("Diamond Ore.png");
  dS     = loadImage("Diamond Ore.png");
  dB     = loadImage("Diamond Ore.png");
  textureMode(NORMAL);

  //load map
  map = loadImage("map.png");
  ArrayList<bullet> bullets = new ArrayList<bullet>();
}

void draw() {
  camera(lx, ly, lz, direction.x + lx, 0, -1, 0, 1, 0);
  direction.rotate(headAngle);
  headAngle = -(pmouseX - mouseX) * 0.01;
  
  if (up)    {
    lx += direction.x;
    lz += direction.y;
  }
  if (down) {
    
    lz += 10;
  }
  if (right) lx = lx + 10;
  if (left)  lx = lx - 10;
  background(255);
  //pushMatrix();
  rotateX(rotx);
  rotateY(roty);
  drawMap();
  drawFloor();  
  drawbullets();
  bullets.add(new bullet(lx, ly, lz, direction.x, direction.y));
  //popMatrix();
}

void drawFloor() {
  int x = 0;
  int y = 0 + bs/2;
  stroke(100);
  strokeWeight(1);
  while (x < map.width * bs) {
    line(x, y, 0, x, y, map.height * bs);
    x = x + bs;
  }
  int z = 0;
  while (z < map.height*bs) {
    line(0, y, z, map.width*bs, y, z);
    z = z +bs;
  }
  noStroke();
}

void drawMap() {
  int mapX = 0, mapY = 0;
  int worldX = 0, worldZ = 0;

  while ( mapY < map.height ) {
    //read in a pixel
    color pixel = map.get(mapX, mapY);
    worldX = mapX * bs;
    worldZ = mapY * bs;
    if (pixel == black) {
      texturedBox(dT, dS, dB, worldX, height/2, worldZ, bs/2);
    }
    mapX++;
    if (mapX > map.width) {
      mapX = 0; //go back to the start of the row
      mapY++;   //go down to the next row
    }
  }
}

void texturedBox(PImage top, PImage side, PImage bottom, float x, float y, float z, float size) {
  pushMatrix();
  translate(x, y, z);
  scale(size);

  //rotateX(rotx);
  //rotateY(roty);
  beginShape(QUADS);
  noStroke();
  texture(side);

  // +Z Front Face
  vertex(-1, -1, 1, 0, 0);
  vertex( 1, -1, 1, 1, 0);
  vertex( 1, 1, 1, 1, 1);
  vertex(-1, 1, 1, 0, 1);

  // -Z Back Face
  vertex(-1, -1, -1, 0, 0);
  vertex( 1, -1, -1, 1, 0);
  vertex( 1, 1, -1, 1, 1);
  vertex(-1, 1, -1, 0, 1);

  // +X Side Face
  vertex(1, -1, 1, 0, 0);
  vertex(1, -1, -1, 1, 0);
  vertex(1, 1, -1, 1, 1);
  vertex(1, 1, 1, 0, 1);

  // -X Side Face
  vertex(-1, -1, 1, 0, 0);
  vertex(-1, -1, -1, 1, 0);
  vertex(-1, 1, -1, 1, 1);
  vertex(-1, 1, 1, 0, 1);

  endShape();
  beginShape();
  texture(bottom);
  
  // +Y Bottom Face
  vertex(-1, 1, -1, 0, 0);
  vertex( 1, 1, -1, 1, 0);
  vertex( 1, 1, 1, 1, 1);
  vertex(-1, 1, 1, 0, 1);

  endShape();
  beginShape();
  texture(top);

  // -Y Top Face
  vertex(-1, -1, -1, 0, 0);
  vertex( 1, -1, -1, 1, 0);
  vertex( 1, -1, 1, 1, 1);
  vertex(-1, -1, 1, 0, 1);

  endShape();
  popMatrix();
}

void mouseDragged() {
  rotx = rotx + (pmouseY - mouseY) * 0.01;
  roty = roty - (pmouseX - mouseX) * 0.01;
}

void keyPressed() {
  if (keyCode == UP) up = true;
  if (keyCode == DOWN) down = true;
  if (keyCode == RIGHT) right = true;
  if (keyCode == LEFT) left = true;
}

void keyReleased() {
  if (keyCode == UP) up = false;
  if (keyCode == DOWN) down = false;
  if (keyCode == RIGHT) right = false;
  if (keyCode == LEFT) left = false;
}

void handleBullets() {
  for (int i = 0; i < bullets.size(); i++) {
    bullet b = bullets.get(i);
    b.show();
    b.act();
  }
}
