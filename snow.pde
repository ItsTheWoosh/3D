class snow {
  int x;
  int y;
  int z;
  float size;
  int hp = 1;
  
  
  snow () {
    x = (int)random(0, 799);
    y = -1000;
    z = (int)random(0, 599);
  }
  
  void show() {
    pushMatrix();
    translate(x, y, z);
    fill(#000000);
    rect(x, z, 10, 10);
    popMatrix();
  }
}
