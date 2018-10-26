// Array to hold all spaceship objects
ArrayList<Spaceship> spaceships;

// global variables to hold some values, you can identify by their name
PVector groundPos;
PVector groundSize;
int enemyCount = 5;
boolean gameWon = false;
boolean gamePlay = true;
boolean gameOver = false;

//background variables
float[] sx = new float[100]; //using arrays so i dont have do repeat a hundred line for stars
float[] sy = new float[100];
float[] speed = new float[100];


// mover object which we're controlling by mouse
Mover mover;

// main method
void setup() {
  // set canvas size
  size(640, 480);
  
   stroke(255);
  strokeWeight(5);
  
  int q = 0;
  while(q < 100) {
  sx[q] = random(0, width);
  sy[q] = random(0, width);
  speed[q] =  random(1,5);
  q  = q + 1; //adding a condition to end the loop at some point to prevent the computer from getting slow
  }

  // initialize ground area, actually the big ellipse position and it's size
  groundPos = new PVector(width/2, height/2);
  groundSize = new PVector(400, 400);

  // this will initialize the game.
  initGame();
}

void initGame() {
  // turn game play mode on
  gamePlay = true;
  // initialize mover object
  mover = new Mover(new PVector(width/2, height/2));

  // init spaceships array list
  spaceships = new ArrayList<Spaceship>(); 

  // insert spaceships to the array list
  for (int i=0; i<enemyCount; i++) {
    spaceships.add(new Spaceship(new PVector(width/2+random(-100, 100), height/2+random(-100, 100)), i));
  }
}

// main looping method
void draw() {
  // draw black background
  background(0);
 drawBackground(); 
  stroke(255);
 
  // check the current mode and fire metods accordingly
  if (gamePlay) {
    gamePlay();
  } else if (gameOver) {
    gameOver();
  } else if (gameWon) {
    gameWon();
  }
}

// this method will keep firing when you're in game won mode
void gameWon() {
  // set background green
  background(0, 170, 0);
  textSize(40);
  fill(255);

  // set text align to center 
  textAlign(CENTER);

  // display You won text
  text("You Won!", width/2, height/2-50);

  // change text size higher
  textSize(20);
  text("Press R to Play Again.", width/2, height/2+50);

  // if you press any key within this game won mode, this condition will become true
  if (keyPressed) {
    // check if its R, and restart the game if true
    if (key == 'R' || key == 'r') {
      initGame();
      gameOver = false;
      gamePlay = true;
      gameWon = false;
    }
  }
}

// This is the game over method
void gameOver() {

  fill(255, 0, 0);
  stroke(255, 0, 0);
  textSize(40);
  textAlign(CENTER);
  text("GAME OVER!", width/2, height/2-50);

  fill(255);
  textSize(20);
  text("You've been knocked out!", width/2, height/2+30-50);

  textSize(30);
  text("Press R to restart.", width/2, height/2+50);

  if (keyPressed) {
    if (key == 'R' || key == 'r') {
      initGame();
      gameOver = false;
      gamePlay = true;
      gameWon = false;
    }
  }
}

// this is the method which keep calling when you are in game play mode
void gamePlay() {

  drawBackground();
  
  // this draws the safe zone
  drawGround(); 

  // draw the mover object
  mover.draw();

  // update mover object
  mover.update();

  //check if player is out of the ground, if true, then set game mode to game over
  if (!mover.isWithinGround()) {
    gamePlay = false;
    gameOver = true;
    gameWon = false;
  }

dis:
  // loop through all the spaceships 
  for (int i=0; i<spaceships.size(); i++) {

    // get one spaceship at a time
    Spaceship spaceship = spaceships.get(i);

    if (spaceship.freezeFrame+50 >= frameCount) {
      spaceship.freezeSize = false;
    }

    // draw the spaceship
    spaceship.draw();
    // update the spaceship
    spaceship.update();

    // check if the spaceship out of the ground, if so
    if (!spaceship.isWithinGround()) {

      // bounce back the spaceship into the ground
      spaceship.bounce();

      // if spaceships hit boolean is true, we remove that spaceship from the scene.
      // set hit variable to true when a spaceship collides with the player.
      if (spaceship.hit) {
        spaceships.remove(spaceship);
        break;
      }
    }

    for (int j=0; j<spaceships.size(); j++) {
      if (i != j) {
        Spaceship anotherSpaceship = spaceships.get(j);
        if (spaceship.colideWithCreatire(anotherSpaceship)) {
          spaceship.vel.x = -spaceship.vel.x*4;
          spaceship.vel.y = -spaceship.vel.y*4;
          anotherSpaceship.vel.x = -anotherSpaceship.vel.x*4;
          anotherSpaceship.vel.y = -anotherSpaceship.vel.y*4;
          
          spaceship.sizeIncreaseTimeout = frameCount;
          anotherSpaceship.sizeIncreaseTimeout = frameCount;
        }
      }
    }

    // check if the spaceship collide with the player
    if (spaceship.colideWithMover(mover)) {
      // if yes, change the velocities of the spaceship
      spaceship.vel.x += mover.vel.x;
      spaceship.vel.y += mover.vel.y;
      // set hit flag true
      spaceship.hit = true;
      spaceship.fCount = frameCount;
    }

    // get next spaceship and check if spaceships are colliding with another spaceships, if yes bounce them
    if (i < spaceships.size()-1) {
      Spaceship spaceship2 = spaceships.get(i+1);
      if (spaceship.colideWithCreatire(spaceship2)) {
        spaceship.bounce();
        //spaceship.setSize(spaceship.size+5);
        spaceship.freezeSize = true;
        spaceship.freezeFrame = frameCount;
        spaceship2.bounce();
        //spaceship2.setSize(spaceship2.size+5);
        spaceship2.freezeSize = true;
        spaceship2.freezeFrame = frameCount;
      }
    }
    
    spaceship.increaseSize();
  }

  // when spaceship array goes to 0 in size which means all the spaceships are knocked out so turn game into game won mode
  if (spaceships.size()==0) {
    gameOver = false;
    gamePlay = false;
    gameWon = true;
  }
}

//drawing the moving star background
void drawBackground() {
    background(0);
    
    int q = 0;
    while(q < 100) {
      point(sx[q], sy[q]);

    sx[q] = sx[q] - speed[q];
    if(sx[q] < 0) {
     sx[q] = width;
      }
      q = q + 1;   
  }
}

//drawing the safe zone
void drawGround() {
  noFill();
  strokeWeight(10);
  stroke(255, 100);
  ellipseMode(CENTER);
  ellipse(groundPos.x, groundPos.y, groundSize.x, groundSize.y);
}
