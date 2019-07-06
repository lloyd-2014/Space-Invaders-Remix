public class SackLeftArm extends Sackboy {

    private float armLength;

    public SackLeftArm(float armLength) {
        this.armLength = armLength;
    }

    public void display() {
        fill(255, 255, 0);
        pushMatrix();
        translate(30, 90);
        rotate(radians(super.getLeftArmAngle()*60));
        beginShape();
        curveVertex(-10, 0);
        curveVertex(0, armLength); // shoulder
        curveVertex(-10, armLength); // shoulder
        curveVertex(-10, 0); // forearm
        curveVertex(0, 0); // forearm 
        curveVertex(0, armLength); // forearm
        curveVertex(-10, 0);
        endShape();
        popMatrix();
        noFill();
    }

}
