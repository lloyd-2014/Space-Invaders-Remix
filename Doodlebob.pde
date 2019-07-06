// public class Doodlebob extends Sack {
    
//     public Doodlebob (float DOODLE_X, float DOODLE_Y) {
//         super(140, 50, 35, DOODLE_X, DOODLE_Y, new JetPack(175, 0, 75, 130));
//     }

//     public void hello() {
//         println("I'm ready I'm ready");
//     }

//     public void drawBody() {
//         // draw pants
//         // pants are 1/5 of body height
//         rect(DOODLE_X, DOODLE_Y, 105, super.getBodyHeight()*0.2);
//         // draw top of tie
//         pushMatrix();
//         translate(DOODLE_X, 55);
//         triangle(50, 46, 55, 55, 60, 46);
//         popMatrix();
//         // draw bottom of tie
//         pushMatrix();
//         translate(DOODLE_X, 55);
//         beginShape();
//         vertex(55, 55);
//         vertex(50, 63);
//         vertex(55, 70);
//         vertex(60, 63);
//         vertex(55, 55);
//         endShape();
//         popMatrix();
//         super.setBodyWidth(30);
//     }

//     public void drawHead() {
//         fill(255, 255, 0);
//         // draw the body above the pants i.e where the face is
//         float faceHeight = super.getBodyHeight() - super.getBodyHeight() * 0.20;
//         float headPosition = DOODLE_Y-super.getBodyHeight()*0.60;
//         rect(DOODLE_X, headPosition, 105, faceHeight);
//         // draw face
//         drawEyes();
//         drawMouth();
//         drawEyes();
//         drawNose();
//     }

//     private void drawEyes() {
//         pushMatrix();
//         translate(DOODLE_X, DOODLE_Y);
//         ellipse(25, -53, 25, 30); // left eye
//         ellipse(30, -50, 5, 5); // left pupil
//         ellipse(78, -53, 35, 40); // right eye
//         ellipse(70, -63, 8, 8); // right pupil
//         popMatrix();
//         drawLeftEyeLashes();
//         drawRightEyeLashes();
//     }

//     private void drawLeftEyeLashes() {
//         // right eye lash
//         pushMatrix();
//         translate(DOODLE_X, DOODLE_Y);
//         translate(5, -65);  
//         rotate(radians(55));
//         line(0, -10, 8, -10); 
//         popMatrix();
//         // middle eye lash
//         pushMatrix();
//         translate(DOODLE_X, DOODLE_Y);
//         translate(5, -65); // reset position
//         rotate(radians(90));
//         line(-8, -18, 0, -18); 
//         translate(DOODLE_X, DOODLE_Y);
//         popMatrix();  
//         // left eye left eye lash      
//         pushMatrix();
//         translate(DOODLE_X, DOODLE_Y);
//         translate(5, -65); // reset position
//         rotate(radians(55));
//         line(0, -5, 8, -5); 
//         popMatrix();
//     }

//     private void drawRightEyeLashes() {
//         // left eye lash
//         pushMatrix(); 
//         translate(DOODLE_X, DOODLE_Y);
//         translate(65, -80);
//         rotate(radians(70));
//         line(5, 0, 10, 0);
//         popMatrix();
//         // middle eye lash
//         pushMatrix();
//         translate(DOODLE_X, DOODLE_Y);
//         translate(65, -80);
//         rotate(radians(90));
//         line(2, -12, 9, -12);
//         popMatrix();
//         // right eye lash
//         pushMatrix();
//         translate(DOODLE_X, DOODLE_Y);
//         translate(65, -80);
//         rotate(radians(100));
//         line(-1, -20, 5, -20);
//         popMatrix();
//     }

//     private void drawMouth() {
//         pushMatrix();
//         translate(DOODLE_X, DOODLE_Y);
//         line(14, -20, 90, -20); // mouth
//         rect(25, -20, 20, 12); // left tooth
//         rect(58, -20, 20, 12); // right tooth
//         popMatrix();
//     }

//     private void drawNose() {
//         pushMatrix();
//         translate(DOODLE_X, DOODLE_Y);
//         ellipse(52, -40, 10, 10); // nose
//         popMatrix();
//     }

//     public void drawRightArm() {
//         fill(255, 255, 0);
//         pushMatrix();
//         translate(DOODLE_X, DOODLE_Y);
//         translate(105, -35);
//         rotate(radians(super.getRightArmAngle()*60));
//         beginShape();
//         curveVertex(0, 10);
//         curveVertex(15, super.getArmLength());
//         curveVertex(0, 0);
//         curveVertex(0, 0);
//         curveVertex(10, 10);
//         endShape();
//         // draw fingers
//         pushMatrix();
//         translate(40, super.getArmLength());
//         rotate(radians(45));
//         ellipse(-8, 15, 25, 5); // index finger
//         rotate(radians(40));
//         ellipse(5, 25, 20, 5); // middle finger
//         rotate(radians(35));
//         ellipse(18, 23, 15, 5); // pinky
//         popMatrix();
//         popMatrix();
//     }
    
//     public void drawLeftArm() {
//         fill(255, 255, 0);
//         pushMatrix();
//         translate(DOODLE_X, DOODLE_Y);
//         translate(0, -35);
//         rotate(radians(super.getLeftArmAngle()*60));
//         beginShape();
//         curveVertex(-10, 10);
//         curveVertex(-20, super.getArmLength());
//         curveVertex(0, 0);
//         curveVertex(0, 0);
//         curveVertex(-10, 10);
//         endShape();
//         pushMatrix();
//         translate(0, 0);
//         rotate(radians(-45));
//         arc(-45, 22, 10, 10, 0, PI); // index finger
//         rotate(radians(-40)); 
//         arc(-40, -10, 10, 12, 0, PI); // middle finger
//         arc(-32, -8, 5, 12, 0, PI); // pinky
//         popMatrix();
//         popMatrix();
//     }

//     public void drawLeftLeg() {
//         fill(255, 255, 0);
//         pushMatrix();
//         translate(DOODLE_X, DOODLE_Y);
//         translate(25, 30);
//         rotate(radians(90));
//         line(0, 0, super.getLegLength(), 0);
//         rotate(radians(90));
//         line(0, -super.getLegLength(), 10, -super.getLegLength());
//         popMatrix();
//     }

//     public void drawRightLeg() {
//         fill(255, 255, 0);
//         pushMatrix();
//         translate(DOODLE_X, DOODLE_Y);
//         translate(75, 30);
//         rotate(radians(90));
//         line(0, 0, super.getLegLength(), 0);
//         rotate(radians(90));
//         line(0, -super.getLegLength(), -10, -super.getLegLength());
//         popMatrix();
//     }

//     public void collectSpecimen(Specimen s) {
//         super.collectSpecimen(s);
//     }

// }