
class MenuTeeter {

  // Our object is two boxes and one joint
  // Consider making the fixed box much smaller and not drawing it
  RevoluteJoint joint;
  Box box1;
  Box box2;

  MenuTeeter(float x, float y, float w) {

    // Initialize locations of two boxes
    box1 = new Box(x, y-20, w, 20, false); 
    box2 = new Box(x, y, 10, 40, true); 

    // Define joint as between two bodies
    RevoluteJointDef rjd = new RevoluteJointDef();

    rjd.initialize(box1.body, box2.body, box1.body.getWorldCenter());

    // Turning on a motor (optional)
    
    rjd.motorSpeed = 0;
    rjd.maxMotorTorque = 0; // how powerful?
    rjd.enableMotor = true;      // is it on?
  
    rjd.enableLimit = true;      // limit angle
    rjd.lowerAngle = -PI/9;
    rjd.upperAngle = PI/20;
  
  

      // Create the joint
    joint = (RevoluteJoint) box2d.world.createJoint(rjd);
  }

  
  void killBoxes() {
    box1.killBody();
    box2.killBody();
  }

  void display() {
    box2.display();
    box1.display();
  }
}
