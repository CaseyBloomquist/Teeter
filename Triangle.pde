// A triangle
class Triangle extends Particle {

  // We need to keep track of a Body and a width and height
 

  // Constructor
  Triangle(float x, float y) {
    // Add the box to the box2d world
    makeBody(new Vec2(x, y));
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  boolean done() {
    // find position on screen
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // check if off bottom
    if (pos.y > height) {
      killBody();
      return true;
    }
    return false;
  }

  // Drawing the box
  void display() {
    // get screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get rotation angle
    float a = body.getAngle();

    Fixture f = body.getFixtureList();
    PolygonShape ps = (PolygonShape) f.getShape();


    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(255);
    stroke(0);
    strokeWeight(2);
    beginShape();
    
    for (int i = 0; i < ps.getVertexCount(); i++) {
      Vec2 v = box2d.vectorWorldToPixels(ps.getVertex(i));
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    popMatrix();
  }

  //add to the particle to the world
  void makeBody(Vec2 center) {
    
    float r1 = random(10, 25);
    float r2 = random(10, 25);
    float r3 = random(10, 25);

    Vec2[] vertices = new Vec2[3];
    vertices[0] = box2d.vectorPixelsToWorld(new Vec2(-r1, r2));
    vertices[1] = box2d.vectorPixelsToWorld(new Vec2(r2, r3));
    vertices[2] = box2d.vectorPixelsToWorld(new Vec2(-r3, -r1));
   

    // Define the triangle
    PolygonShape ps = new PolygonShape();
    ps.set(vertices, vertices.length);

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = ps;

    fd.density = 2.0;
    fd.friction = 0.3;
    fd.restitution = 0.5; // Restitution is bounciness

    body.createFixture(fd);
    
    

    // Give it some initial random velocity
    //body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 5)));
    body.setAngularVelocity(random(-5, 5));
  }
}

