public class ToggleRightArm extends Toggle {

    private float armLength;

    public ToggleRightArm(float armLength) {
        this.armLength = armLength;
    }

    public void display() {
        fill(255, 255, 0);
        pushMatrix();
        translate(96, 140);
        rotate(radians(super.getRightArmAngle()*60));
        fill(255);
        beginShape();
        curveVertex(0, 0);
        curveVertex(20, armLength); // shoulder
        curveVertex(0, armLength); // shoulder
        curveVertex(0, 0); // forearm
        curveVertex(10, 0); // forearm 
        curveVertex(20, armLength); // forearm
        curveVertex(0, 0);
        endShape();
        popMatrix();
    }

}
