class Spaceship {
  // these variables are holding different properties related to a user's spaceship
  int id;
  PVector loc;
  PVector vel;
  PVector acc;
  int size = 20;
  int size2 = 40;
  public boolean hit = false;
  public int fCount = 0;
  public int freezeFrame = 0;
  public boolean freezeSize = true;
  
  public int sizeIncreaseTimeout = 0;

  // Constructor 
  public Spaceship(PVector pos, int id) {
    
    // initialize the object using given parameters for the constructor
    this.loc = pos;
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    this.id = id;
  }
  
  void increaseSize(){
    println(sizeIncreaseTimeout,frameCount);
    if(sizeIncreaseTimeout != 0 && sizeIncreaseTimeout+5000 >= frameCount){
      sizeIncreaseTimeout = 0;
      setSize(size+5);
    }
  }

  // set size of the spaceship
  void setSize(int val) {
    if (!freezeSize){
      size = val;
      freezeSize = true;
    }
  }

  // this method will bounce the spaceship, no matter where they are
  void bounce() {
    vel.x = -vel.x;
    vel.y = -vel.y;
  }

  // check if the current spaceship is within the safezone, if yes return true, else false.
  boolean isWithinGround() {
    if (dist(loc.x, loc.y, width/2, height/2) > groundSize.x/2-5) {
      return false;
    } else {
      return true;
    }
  }

  // check if current spaceship collides with the player, returns true or false accordingly.
  public boolean colideWithMover(Mover mover) {
    if (dist(mover.loc.x, mover.loc.y, this.loc.x, this.loc.y) < size/2+mover.size/2) {
      return true;
    } else {
      return false;
    }
  }

  // check if current spaceship colide with another spaceship given as a parameter
  public boolean colideWithCreatire(Spaceship spaceship) {
    if (dist(spaceship.loc.x, spaceship.loc.y, this.loc.x, this.loc.y) < size) {
      return true;
    } else {
      return false;
    }
  }


  // draw the spaceship
  public void draw() {

    if (fCount+50 == frameCount) {
      hit = false;
    }

    fill(155,255,255);
    noStroke();
    ellipse(loc.x, loc.y, size, size);
    ellipse(loc.x, loc.y, size*2, size/2);
  }

  // move the spaceship with random accelaration
  void update() {
    acc = new PVector(random(-0.5, 0.5), random(-0.5, 0.5));
    vel.add(acc);
    loc.add(vel);
    vel.limit(3);
  }
}
