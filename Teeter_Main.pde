// Teeter
// Casey Bloomquist
// www.caseybloomquist.com

// Teeter is a motion controlled video game. 
// The goal of the game is to keep the Teeter level while being barraged by falling particles.
// This was my first video game, so the code is a little bit cumbersome.
// Comments welcome!


//Import libraries
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import com.leapmotion.leap.CircleGesture;
import com.leapmotion.leap.KeyTapGesture;
import com.leapmotion.leap.ScreenTapGesture;
import com.leapmotion.leap.SwipeGesture;
import com.leapmotion.leap.Gesture.State;
import com.leapmotion.leap.Gesture.Type;
import com.leapmotion.leap.Hand;
import com.onformative.leap.LeapMotionP5;

// LEAP Setup
LeapMotionP5 leap;

// A reference to the box2d world
Box2DProcessing box2d;

// An object to describe a Teeter
Teeter teeter;
// and one for the menu
MenuTeeter menuTeeter;


// An ArrayList of particles that will fall on the surface
ArrayList<Particle> particles;
ArrayList<Particle> menuParticles;
// hands
ArrayList<Hand> handList;
PVector leftHand;
PVector rightHand;

//color control of background
color cA, cB;
int colorTimer = 0;
int colorSize = 2000;
color c0 = color(50, 150, 220);
color c1 = color(0, 0, 150);
color c2 = color(0, 150, 0);
color c3 = color(150, 0, 150);
color c4 = color(250, 250, 100);
color c5 = color(150, 0, 0);
float inter;

//timers/counters
float t = 0;
int timer = 0;
int score = 0;
int tutCounter = 0;
int levelSize = 1000;
int level = 1;

boolean pause = false; 
boolean play = false;
boolean gameOver = false;
boolean restart = false;
boolean pokeRestart = false;
boolean tutHand = false;
boolean tutor = false;
boolean tutPlay = false;


// Menu constants
int PLAYING = 0;
int MAIN_MENU = 1;
int TUTORIAL = 2;
int GAME_OVER = 3;

int gameState;

void setup() {
  size(1280, 720);
  c1 = color(150, 0, 0);
  c2 = color(0, 0, 150);

  // Initialize Leap
  leap = new LeapMotionP5(this);
  enableGesture();
  // Initialize box2d, create world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();

  // Make the Teeter at an x,y location
  menuTeeter = new MenuTeeter(width/2 -250, height/2 -40, 400);
  // Create an empty list of particles
  menuParticles = new ArrayList<Particle>();
  gameInit();
  

}

void gameInit() {
  gameState = MAIN_MENU;
}





void draw() {
  switch(gameState) {
  case 0: //PLAYING
    if (!gameOver) {
      // Control Background Color - continuous loop
      int cTimer = int(colorTimer/levelSize)+1;
      if (cTimer == 1) {
        inter = map(colorTimer, 0, levelSize, 0, 1);
        cA = c0;
        cB = c1;
      } 
      else if (cTimer == 2) {
        cA = c1;
        cB = c2;
        inter = map(colorTimer, levelSize, 2*levelSize, 0, 1);
      } 
      else if (cTimer == 3) {
        cA = c2;
        cB = c3;
        inter = map(colorTimer, 2*levelSize, 3*levelSize, 0, 1);
      }
      else if (cTimer == 4 ) {
        cA = c3;
        cB = c4;
        inter = map(colorTimer, 3*levelSize, 4*levelSize, 0, 1);
      }
      else if (cTimer == 5) {
        cA = c4;
        cB = c5;
        inter = map(colorTimer, 4*levelSize, 5*levelSize, 0, 1);
      }  
      else if (cTimer == 6) {
        cA = c5;
        cB = c0;
        inter = map(colorTimer, 5*levelSize, 6*levelSize, 0, 1);
      } 
      else if (colorTimer >= 6*levelSize) {
        colorTimer = 0;
      }
      colorTimer++;
      color c = lerpColor(cA, cB, inter);
      background(c);
      //

      // set level number
      level = int(timer/levelSize)+1;


      //get hands
      handList = leap.getHandList();

      // Need two hands or pauses
      if (handList.size() != 2) {
        box2d.step(0, 0, 0); 
        fill(102, 150);
        rect(0, 0, 2*width, 2*height);
        fill(255);
        textSize(40);
        text("Two Hands to Play!", width/2 - 200, 200);
      } 

      // with two hands
      else if (handList.size() == 2) {
        PVector hand1 = leap.getPosition(leap.getHand(0));
        PVector hand2 = leap.getPosition(leap.getHand(1));

        float sz = random(5, 20);
        float w = random(10, 40);
        float h = random(10, 40);
        float n = noise(t);
        float x = map(n, 0, 1, width/2 - 400, width/2 + 400);
        float x2 = map(n, 0, 1, width/2 + 400, width/2 - 250);
        
        //Define Levels
        if (level == 1) {
          if (random(1) < 0.1) {
            particles.add(new Circle(x, -20, sz));
          }
        } 
        else if (level == 2) {
          if (random(1) < 0.08) {
            particles.add(new Square(x, -20, w, h));
          }
        } 
        else if (level == 3) {
          if (random(1) < 0.07) {
            particles.add(new Triangle(x, -20));
          }
        } 
        else if (level == 4) {
          if (random(1) < 0.03) {
            particles.add(new Polygon(x, -20));
          }
        } 
        if (level == 5) {
          if (random(1) < 0.05) {
            particles.add(new Circle(x, -20, sz));
          }
        } 
        else if (level == 6) {
          if (random(1) < 0.04) {
            if (random(1) < 0.5) {
              particles.add(new Circle(x, -20, sz));
            } 
            else {
              particles.add(new Square(x, -20, w, h));
            }
          }
        } 
        else if (level == 7) {
          if (random(1) < 0.1) {
            float r = random(1);
            if (r < 0.33) {
              particles.add(new Circle(x, -20, sz));
            } 
            else if (r > 0.33 && r < 0.66) {
              particles.add(new Square(x, -20, w, h));
            } 
            else if (r > 0.66) {
              particles.add(new Triangle(x, -20));
            }
          }
        } 
        else if (level == 8) {
          if (random(1) < 0.05) {
            float r = random(1);
            if (r < 0.25) {
              particles.add(new Circle(x, -20, sz));
            } 
            else if (r > 0.25 && r < 0.5) {
              particles.add(new Square(x, -20, w, h));
            } 
            else if (r > 0.5 && r < 0.75) {
              particles.add(new Triangle(x, -20));
            } 
            else if (r > 0.75) {
              particles.add(new Polygon(x, -20));
            }
          }
        } 
        
        else if (level == 9) {
          if (random(1) < 0.07) {
            float r = random(1);
            if (r < 0.1) {
              particles.add(new Circle(x, -20, sz));
            } 
            else if (r > 0.1 && r < 0.4) {
              particles.add(new Square(x, -20, w, h));
            } 
            else if (r > 0.4 && r < 0.5) {
              particles.add(new Triangle(x, -20));
            } 
            else if (r > 0.5) {
              particles.add(new Polygon(x, -20));
            }
          }
        } 
        
        else if (level == 10) {
          if (random(1) < 0.03) {
            float r = random(1);
            if (r < 0.5) {
              particles.add(new Circle(x, -20, sz));
            } 
            else if (r > 0.5 && r < 0.6) {
              particles.add(new Square(x, -20, w, h));
            } 
            else if (r > 0.6 && r < 0.9) {
              particles.add(new Triangle(x, -20));
            } 
            else if (r > 0.9) {
              particles.add(new Polygon(x, -20));
            }
          }
        } 

        else if (level > 10) {
          float freq = random(0.03, 0.2);
          if (random(1) < freq) {
            float r = random(1);
            if (r < 0.25) {
              particles.add(new Circle(x, -20, sz));
            }
            else if (r > 0.25 && r < 0.5) {
              particles.add(new Square(x, -20, w, h));
            }
            else if (r > 0.5 && r < 0.75) {
              particles.add(new Triangle(x, -20));
            }
            else if (r > 0.75 && r < 1) {
              particles.add(new Polygon(x, -20));
            }
          }
        }

        t +=0.1;


        // Look at all particles
        for (int i = particles.size()-1; i >= 0; i--) {
          Particle p = particles.get(i);
          p.display();

          if (p.done()) {
            particles.remove(i);
          }
        }

        // assign left/right hands
        if (hand1.x < hand2.x) {
          leftHand = hand1.get();
          rightHand = hand2.get();
        } 
        else if (hand1.x > hand2.x) {
          leftHand = hand2.get();
          rightHand = hand1.get();
        }
        // Draw hand indicators
        noStroke();
        fill(255, 0, 0);
        ellipse(leftHand.x, leftHand.y, 20, 20);
        fill(0, 255, 0);
        ellipse(rightHand.x, rightHand.y, 20, 20);
        
        //Provide torque to motor based on relative hand positions
        float handDiffV = abs(leftHand.y - rightHand.y);
        handDiffV = map(handDiffV, 0, 250, 0, 10000);
        float handDiffH = abs(leftHand.x - rightHand.x);
        handDiffH = map(handDiffH, 300, 2000, 1, 5);
        float hD = handDiffV * handDiffH;
        if (timer < 50) {
          teeter.stopMotor();
        } 
        else {
          if (leftHand.y > rightHand.y) {
            teeter.motorCCW(hD);
          } 
          else if (leftHand.y < rightHand.y) {
            teeter.motorCW(hD);
          }
        }
        box2d.step();
        timer++;// timer iterated in pause if statement

        //Angle stuff
        float angle = teeter.getAngle();
        if (abs(angle) < 0.15) {
          fill(255);
          textSize(30);
          text("2X", width/2, height-150);
          score +=2;
        } 
        else {
          score++;
        }
        
        // Close to limit warning
        if (abs(angle) > 0.7) {
          fill(255);
          textSize(30);
          text("!!!", width/2, height-150);
          
        } 
        
        //Game Over Scenario
        if (abs(angle) > 0.9) {
          gameOver = true;
          level = 0;
          timer = 0;
        }
      } 
      // Draw the teeter
      teeter.display();
    } 

    if (gameOver) {
      background(c0);
      teeter.noMotor();

      float sz = random(5, 20);
      float w = random(10, 40);
      float h = random(10, 40);
      float n = noise(t);
      float x = map(n, 0, 1, width/2 - 400, width/2 + 400);
      float r = random(1);
      if (random(1) < 0.1) {
        if (r < 0.25) {
          particles.add(new Circle(x, -20, sz));
        }
        else if (r > 0.25 && r < 0.5) {
          particles.add(new Square(x, -20, w, h));
        }
        else if (r > 0.5 && r < 0.75) {
          particles.add(new Triangle(x, -20));
        }
        else if (r > 0.75 && r < 1) {
          particles.add(new Polygon(x, -20));
        }
      }
      t += 0.1;

      // Look at all particles
      for (int i = particles.size()-1; i >= 0; i--) {
        Particle p = particles.get(i);
        p.display();

        if (p.done()) {
          particles.remove(i);
        }
      }

      box2d.step();
      
      teeter.display();
      fill(100, 200);
      rect(0, 0, 2*width, 2*height);
      fill(255);
      textSize(40);
      text("Game Over", width/2 -115, 150);

      timer++;
      if (timer > 100) {
        text("Poke to Play Again!", width/2 - 175, 220);
        pokeRestart = true;

        if (restart) {

          //remove teeters/particles and add new
          teeter.killBoxes();
          for (int i = particles.size()-1; i >= 0; i--) {
            Particle p = particles.get(i);
            p.killBody();
          }
          particles.clear();
          particles = new ArrayList<Particle>();
          teeter = new Teeter(width/2, 500, 451);
          timer = 0;
          colorTimer = 0;
          score = 0;
          gameOver = false;
          restart = false;
          pokeRestart = false;
        }
      }
    } 

    textSize(20);
    text("Score: " + score, 50, 50);
    text("Level: " + level, 50, 80);



    break;


  case 1 : //MAIN_MENU
    background(50, 150, 220);
 
    if (!play && !tutor) {
      if (random(1) < 0.2) {
        float sz = random(2, 20);
        float w = random(10, 40);
        float h = random(10, 40);
        float n = noise(t);
        //float x = map(n, 0, 1, 0, width);
        float x = random(0, width);
        float r = random(1);
        if (r < 0.25) {
          menuParticles.add(new Circle(x, -20, sz));
        } 
        else if (r >0.25 && r < 0.5) {
          menuParticles.add(new Square(width-x, -20, w, h)) ;
        } 
        else if (r > 0.5 && r < 0.75) {
          menuParticles.add(new Triangle(x, -20));
        } 
        else if (r > 0.75 && r < 1) {
          menuParticles.add(new Polygon(x, -20));
        }
        t +=0.1;
      }
      for (int i = menuParticles.size()-1; i >= 0; i--) {
        Particle m = menuParticles.get(i);
        m.display();

        if (m.done()) {
          menuParticles.remove(i);
        }
      }

      box2d.step();
      fill(255);
      textSize(200);
      text("leeter", width/2-280, height/2+100); 
      menuTeeter.display();
      textSize(30);
      fill(255, (t)*(10*t)-150);
      text("Poke to Play", width/2-90, height-150);
      text("Swipe for Tutorial", width/2-125, height -100);
      text("ESC to Quit", width/2 - 80, height-50);
    } 
    else if (play) {
      menuTeeter.killBoxes();
      for (int i = menuParticles.size()-1; i >= 0; i--) {
        Particle m = menuParticles.get(i);
        m.killBody();
      }
      menuParticles.clear();
      particles = new ArrayList<Particle>();
      teeter = new Teeter(width/2, 500, 451);
      gameState = PLAYING;
    } 
    else if (tutor) {
      menuTeeter.killBoxes();
      for (int i = menuParticles.size()-1; i >= 0; i--) {
        Particle m = menuParticles.get(i);
        m.killBody();
      }
      menuParticles.clear();
      particles = new ArrayList<Particle>();
      teeter = new Teeter(width/2, 500, 451);
      gameState = TUTORIAL;
    }
    break;

  case 2:                 //TUTORIAL

    if (!play) {
      background(100);

      handList = leap.getHandList();
      //need to get left/right most hand
      if (handList.size() < 2 && !tutHand) {
        textSize(30);
        text("Use two hands!", width/2 - 120, 200);
      } 
      if (handList.size() > 1) {
        tutHand = true;
      }

      if (tutHand) {

        tutCounter +=1;
        if (tutCounter < 1000) {
          if (handList.size() > 1) {

            PVector hand1 = leap.getPosition(leap.getHand(0));
            PVector hand2 = leap.getPosition(leap.getHand(1));
            if (hand1.x < hand2.x) {
              leftHand = hand1.get();
              rightHand = hand2.get();
            } 
            else if (hand1.x > hand2.x) {
              leftHand = hand2.get();
              rightHand = hand1.get();
            }
            noStroke();
            fill(255, 0, 0);
            ellipse(leftHand.x, leftHand.y, 20, 20);
            fill(0, 255, 0);
            ellipse(rightHand.x, rightHand.y, 20, 20);
            float handDiffV = leftHand.y - rightHand.y;
            handDiffV = map(handDiffV, 0, 250, 0, 10000);
            float handDiffH = leftHand.x - rightHand.x;
            handDiffH = map(handDiffH, 300, 2000, 1, 5);
            float hD = handDiffV * handDiffH;
            float tutHD = map(hD, 1000, 30000, 0, 200);

            fill(255, 0, 0);
            rectMode(CORNERS);
            rect(width/2+200, 480, width/2+220, 480 + tutHD);
            rect(width/2-200, 480, width/2-220, 480 - tutHD);
          }
          textSize(30);
          fill(255);

          if (tutCounter < 500) {
            text("Direction of torque is determined by higher hand", width/4-20, 140);
            text("Left hand higher = clockwise", width/4+58, 200);
            text("Right hand higher = counter-clockwise", width/4+38, 240);
          } 
          else {
            text("Torque strength is controlled by vertical", width/4+30, 140); 
            text("and horizontal distance between hands", width/5+95, 180);
          }
        } 
        else if (tutCounter > 1000) {
          if (handList.size() > 1) {
            PVector hand1 = leap.getPosition(leap.getHand(0));
            PVector hand2 = leap.getPosition(leap.getHand(1));
            if (hand1.x < hand2.x) {
              leftHand = hand1.get();
              rightHand = hand2.get();
            } 
            else if (hand1.x > hand2.x) {
              leftHand = hand2.get();
              rightHand = hand1.get();
            }
            noStroke();
            fill(255, 0, 0);
            ellipse(leftHand.x, leftHand.y, 20, 20);
            fill(0, 255, 0);
            ellipse(rightHand.x, rightHand.y, 20, 20);
            float handDiffV = abs(leftHand.y - rightHand.y);
            handDiffV = map(handDiffV, 0, 250, 0, 10000);
            float handDiffH = abs(leftHand.x - rightHand.x);
            handDiffH = map(handDiffH, 300, 2000, 1, 5);
            float hD = handDiffV * handDiffH;
            if (leftHand.y > rightHand.y) {
              teeter.motorCCW(hD);
            } 
            else if (leftHand.y < rightHand.y) {
              teeter.motorCW(hD);
            }
          }
          textSize(40);
          fill(255);
          text("Try to Keep the Teeter Level! ", width/4+60, 140); 
          if (tutCounter > 1500) {
            text("Poke to Play!", width/4+200, height-100);
            tutPlay = true;
          }
          box2d.step();
        }
      }
      teeter.display();
    }

    else if (play) {
      teeter.killBoxes();
      particles = new ArrayList<Particle>();
      teeter = new Teeter(width/2, 500, 451);
      gameState = PLAYING;
    } 
    break;

  case 3:
    background(204);
    textSize(40);
    text("Game Over!", width/2, height/2);
    break;
  }
}



public void screenTapGestureRecognized(ScreenTapGesture gesture) {
  if (gesture.state() == State.STATE_STOP) {
    if (gameState == MAIN_MENU) {
      if (play) {
        play = false;
      } 
      else if (!play) {
        play = true;
      }
    }
    if (gameState == TUTORIAL) {
      if (play) {
        play = false;
      } 
      else if (!play && tutPlay ) {
        play = true;
      }
    }
    if (gameState == PLAYING && gameOver && pokeRestart) {
      if (!restart) {
        restart = true;
      }
    }
  }
  else if (gesture.state() == State.STATE_START) {
  } 
  else if (gesture.state() == State.STATE_UPDATE) {
  }
}

public void swipeGestureRecognized(SwipeGesture gesture) {
  if (gesture.state() == State.STATE_STOP) {
    if (gameState == MAIN_MENU) {
      if (tutor) {
        tutor = false;
      } 
      else if (!tutor) {
        tutor = true;
      }
    }
  }
  else if (gesture.state() == State.STATE_START) {
  } 
  else if (gesture.state() == State.STATE_UPDATE) {
  }
}

void enableGesture() {
  leap.enableGesture(Type.TYPE_SCREEN_TAP);
  leap.enableGesture(Type.TYPE_SWIPE);
}

public void stop() {
  leap.stop();
}

