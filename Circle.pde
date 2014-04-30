class Circle extends Particle {
  
  float r;
  
  Circle(float x, float y, float r_) {
    r = r_;
    // This function puts the particle in the Box2d world
    makeBody(new Vec2(x, y), r);
    body.setUserData(this);
  }
  
  
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x, pos.y);

    rotate(-a);
    //fill(50, 150, 150);
    fill(255);
    stroke(0);
    strokeWeight(2);
    ellipse(0, 0, r*2, r*2);
    // Let's add a line so we can see the rotation
    //line(0, 0, r, 0);
    popMatrix();
  }

  // Here's our function that adds the particle to the Box2D world
  void makeBody(Vec2 center,  float r) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position.set(box2d.coordPixelsToWorld(center));
    bd.type = BodyType.DYNAMIC;

    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;

    fd.density = 2.0;
    fd.friction = 0.5;
    fd.restitution = 0.5; // Restitution is bounciness

    body.createFixture(fd);

    // Give it a random initial velocity (and angular velocity)
    //body.setLinearVelocity(new Vec2(random(-10f,10f),random(5f,10f)));
    body.setAngularVelocity(random(-10, 10));
  }
}
