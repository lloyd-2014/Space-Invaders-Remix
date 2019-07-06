public class SackLeftLeg extends Sackboy {

    private float legLength;

    public SackLeftLeg(float legLength) {
        this.legLength = legLength;
    } 

    public void display() {
        fill(255, 255, 0);        
        pushMatrix();
        translate(33, 125);
        // rotate(radians(-leftArmAngle*55));
        beginShape();
        curveVertex(-10, 0);
        curveVertex(0, legLength); // shoulder
        curveVertex(-20, legLength); // shoulder
        curveVertex(-10, 0); // forearm
        curveVertex(0, 0); // forearm 
        curveVertex(0, legLength); // forearm
        curveVertex(-10, 0);
        endShape();
        popMatrix();
        noFill();
    }

}
