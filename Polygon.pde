// A polygon
class Polygon extends Particle {

  // We need to keep track of a Body and a width and height
 

  // Constructor
  Polygon(float x, float y) {
    // Add the box to the box2d world
    makeBody(new Vec2(x, y));
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

  // Drawing the box
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
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
    //println(vertices.length);
    // For every vertex, convert to pixel vector
    for (int i = 0; i < ps.getVertexCount(); i++) {
      Vec2 v = box2d.vectorWorldToPixels(ps.getVertex(i));
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    popMatrix();
  }

  // This function adds the rectangle to the box2d world
  void makeBody(Vec2 center) {
    
    float r1 = random(5, 25);
    float r2 = random(5, 25);
    float r3 = random(5, 25);
    float r4 = random(5, 25);

    Vec2[] vertices = new Vec2[4];
    vertices[0] = box2d.vectorPixelsToWorld(new Vec2(-r1, r2));
    vertices[1] = box2d.vectorPixelsToWorld(new Vec2(r2, r3));
    vertices[2] = box2d.vectorPixelsToWorld(new Vec2(-r3, -r4));
    vertices[3] = box2d.vectorPixelsToWorld(new Vec2(r4, -r1));
   

    // Define a polygon (this is what we use for a rectangle)
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

