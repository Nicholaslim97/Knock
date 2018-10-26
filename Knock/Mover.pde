class Mover {
  PVector loc, vel, acc;
  int size = 30;
  int size2 = 50;
  
  // Constructor
  public Mover(PVector loc) {
    this.loc = loc;
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
  }

  // update the player's spaceship location according to mouse position
  void update() {
    PVector mouse = new PVector(0, 0);
    if (mouseX != 0 && mouseY != 0) {
      mouse = new PVector(mouseX, mouseY);
      mouse.sub(loc);
      mouse.setMag(0.5);
    }

    acc = mouse;
    vel.add(acc);
    loc.add(vel);
    vel.limit(5);
  }

  // check if the player is within the safe zone
  boolean isWithinGround() {
    if (dist(loc.x, loc.y, width/2, height/2) < groundSize.x/2-30) {
      return true;
    } else {
      return false;
    }
  }

  // draw the player
  void draw() {
    fill(255, 0, 0);
    noStroke();
    ellipse(loc.x, loc.y, size,size);
    ellipse(loc.x, loc.y, size2, size/2);
  }
}
