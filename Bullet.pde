class Bullet {
  
  float x, y, z, vx, vz;
  
  Bullet(float x, float y, float z, float vx, float vz){
    x = this.x;
    y = this.y;
    z = this.z;
    vx = this.vx;
    vz = this.vz;
  }
  
  void show() {
    pushMatrix();
    translate(x, y, z);
    fill(white);
    sphere(100);
    popMatrix();
  }
  
  void act() {
    x += vx;
    z += vz;
  }
}
