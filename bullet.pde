class bullet {
  
  float x, y, z, vx, vz;
  
  bullet(float x, float y, float z, float vx, float vz){
    x = this.x;
    y = this.y;
    z = this.z;
    vx = this.vx;
    vz = this.vz;
  }
  
  void show() {
    pushMatrix();
    translate(x, y, z);
    fill(#104F9B);
    sphere(10);
    popMatrix();
  }
  
  void act() {
    x += vx;
    z += vz;
  }
}
