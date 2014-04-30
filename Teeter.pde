
class Teeter {

  // Our object is two boxes and one joint
  // second box not drawn
  RevoluteJoint joint;
  Box box1;
  Box box2;

  Teeter(float x, float y, float w) {

    // Initialize locations of two boxes
    box1 = new Box(x, y-20, w, 20, false); 
    box2 = new Box(x, y, 10, 40, true); 

    // Define joint as between two bodies
    RevoluteJointDef rjd = new RevoluteJointDef();

    rjd.initialize(box1.body, box2.body, box1.body.getWorldCenter());

    // enable motor
    rjd.motorSpeed = 0;
    rjd.maxMotorTorque = 9000000; 
    rjd.enableMotor = true;      
  
    // set angle limits
    rjd.enableLimit = true;      
    rjd.lowerAngle = -PI/3;
    rjd.upperAngle = PI/3;
    
  

      // Create the joint
    joint = (RevoluteJoint) box2d.world.createJoint(rjd);
  }

  // Motor Clockwise
  void motorCW(float hD) {
    joint.setMotorSpeed(PI);
    joint.setMaxMotorTorque(hD);
  }
  
   // Motor CounterClockwise
  void motorCCW(float hD) {
    joint.setMotorSpeed(-PI);
    joint.setMaxMotorTorque(hD);
  }
  
  void noMotor() {
    joint.enableMotor(false);
  }
  
  void stopMotor() {
    joint.setMotorSpeed(0);
    joint.setMaxMotorTorque(1000000);
  }
  
  float getAngle() {
    float angle = joint.getJointAngle();
    return angle;
  }

  boolean motorOn() {
    return joint.isMotorEnabled();
  }
  
  void killBoxes() {
    box1.killBody();
    box2.killBody();
  }

  void display() {
    box1.display();
  }
}
