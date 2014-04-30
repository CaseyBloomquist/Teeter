class Particle {
  
  //track Body, other features in subclasses
  Body body;
  
  Particle() {
  }
  
    // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }
    
  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height) {
      killBody();
      return true;
    }
    return false;
  } 
  
  void display() {
  }
} 
