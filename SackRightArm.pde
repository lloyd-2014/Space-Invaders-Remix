public class SackRightArm extends Sackboy {
    
    private float armLength;

    public SackRightArm(float armLength) {
        this.armLength = armLength;
    }

    public void display() {
        fill(255, 255, 0);
        pushMatrix();
        translate(59, 90);
        rotate(radians(super.getRightArmAngle()*60));
        beginShape();
        curveVertex(0, 0);
        curveVertex(10, armLength); // shoulder
        curveVertex(0, armLength); // shoulder
        curveVertex(0, 0); // forearm
        curveVertex(10, 0); // forearm 
        curveVertex(10, armLength); // forearm
        curveVertex(0, 0);
        endShape();
        popMatrix();
        noFill();
    }

}
