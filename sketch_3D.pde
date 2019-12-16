//color pallette
color black = #000000;
color white = #FFFFFF;

//variables
int bs = 100;
PImage map;
boolean up, down, right, left, space, shift, leap = true, fly = false;
int ground = -100;
int frames = 0;
float lx = 2500;
float ly = (height / 2 - bs / 2) - 100;
float lz = 2500;
PVector xzDirection = new PVector(0, -10);
PVector xyDirection = new PVector(10, 0);
PVector strafeDir   = new PVector(10, 0);
float leftRightHeadAngle = 0;
float upDownHeadAngle    = 0;
ArrayList<bullet> bullets = new ArrayList<bullet>();

//textures
PImage qblock, dT, dS, dB;

//World manipulation

float rotx = PI/4, roty = PI/4;


void setup() {
  size(1200, 1000, P3D);
  //fullScreen(P3D);
  //load textures
  qblock = loadImage("Diamond Ore.png");
  dT     = loadImage("Diamond Ore.png");
  dS     = loadImage("Diamond Ore.png");
  dB     = loadImage("Diamond Ore.png");
  textureMode(NORMAL);

  //load map
  map = loadImage("map.png");
  bullets = new ArrayList<bullet>();
}

void draw() {
  frames++;
  background(0);

  float dx = lx + xzDirection.x;
  float dy = ly + xyDirection.y;
  float dz = lz + xzDirection.y;
  camera(lx, ly, lz, dx, dy, dz, 0, 1, 0); 
  xzDirection.rotate(leftRightHeadAngle);
  xyDirection.rotate(upDownHeadAngle);
  leftRightHeadAngle = -(pmouseX - mouseX) * 0.01;
  //upDownHeadAngle = (pmouseX - mouseX) * 0.01;

  //headAngle = headAngle + 0.01;

  strafeDir = xzDirection.copy();
  strafeDir.rotate(PI/2);

  if (up) {
    lx = lx + xzDirection.x;
    lz = lz + xzDirection.y;
  }
  if (down) {
    lx = lx - xyDirection.x;
    lz = lz - xzDirection.y;
  }
  if (left) {
    lx = lx - strafeDir.x;
    lz = lz - strafeDir.y;
  }
  if (right) {
    lx = lx + strafeDir.x;
    lz = lz + strafeDir.y;
  }
  if (!fly) {
    if (space && leap) {
      for (int jump = 60; jump > 0; jump--) {
        if (jump % 5 == 0) {
          ly = ly - jump / 2;
        }
      }
      leap = false;
    }
  } else if (fly) {
    if (space) {
      ly = ly - 10;
    }
  }
  if (fly) {
    if (shift) {
      ly = ly + 10;
    }
  }
  //println(strafeDir.y);
  println(ly);
  //direction.rotate(-(pmouseX - mouseX) * 0.01);
  if (!fly) {
    if (ly == ground) {
      leap = true;
    }
    if (ly > ground) {
      ly = -100;
    }
    if (ly < ground) {
      ly += 10;
    }
  }  
  drawMap();
  drawFloor();  
  if (mousePressed) {
    bullets.add(new bullet(lx, ly, lz, xzDirection.x, xzDirection.y));
    drawBullets();
  }
}

void drawBullets() {
  for (int i = 0; i < bullets.size(); i++) {
    bullet b = bullets.get(i);        
    b.act();
    b.show();
  }
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
      texturedBox(dT, dS, dB, worldX, 0, worldZ, bs/2);
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
  //rotx = rotx + (pmouseY - mouseY) * 0.01;
  //roty = roty - (pmouseX - mouseX) * 0.01;
}

void keyPressed() {
  if (keyCode == UP    || keyCode == 'W') up    = true;
  if (keyCode == DOWN  || keyCode == 'S') down  = true;
  if (keyCode == RIGHT || keyCode == 'D') right = true;
  if (keyCode == LEFT  || keyCode == 'A') left  = true;
  if (keyCode == ' '   /*             */) space = true;
  if (keyCode == SHIFT /*             */) shift = true;
  if (keyCode == 'L'                    ) {
    if (fly) {
      fly = false;
    } else if (!fly) {
      fly = true;
    }
  }
}

void keyReleased() {
  if (keyCode == UP    || keyCode == 'W') up    = false;
  if (keyCode == DOWN  || keyCode == 'S') down  = false;
  if (keyCode == RIGHT || keyCode == 'D') right = false;
  if (keyCode == LEFT  || keyCode == 'A') left  = false;
  if (keyCode == ' '   /*             */) space = false;
  if (keyCode == SHIFT /*             */) shift = false;
}

void handleBullets() {
  for (int i = 0; i < bullets.size(); i++) {
    bullet b = bullets.get(i);
    b.show();
    b.act();
  }
}
