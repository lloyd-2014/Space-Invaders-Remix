public class SackRightLeg extends Sackboy {

    private float legLength;

    public SackRightLeg(float legLength) {
        this.legLength = legLength;
    }

    public void display() {
        fill(255, 255, 0);        
        pushMatrix();
        translate(54, 125);
        // rotate(radians(-rightArmAngle*45));
        beginShape();
        curveVertex(0, 0);
        curveVertex(20, legLength); // shoulder
        curveVertex(0, legLength); // shoulder
        curveVertex(0, 0); // forearm
        curveVertex(10, 0); // forearm 
        curveVertex(20, legLength); // forearm
        curveVertex(0, 0);
        endShape();
        popMatrix();
        noFill();
    }

}
