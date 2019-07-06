public class ToggleLeftArm extends Toggle {

    private float armLength;

    public ToggleLeftArm(float armLength) {
        this.armLength = armLength;
    }

    public void display() {
        fill(255, 255, 0);
        pushMatrix();
        translate(5, 140);
        rotate(radians(super.getLeftArmAngle()*60));
        fill(255);
        beginShape();
        curveVertex(-10, 0);
        curveVertex(0, armLength); // shoulder
        curveVertex(-20, armLength); // shoulder
        curveVertex(-10, 0); // forearm
        curveVertex(0, 0); // forearm 
        curveVertex(0, armLength); // forearm
        curveVertex(-10, 0);
        endShape();
        popMatrix();
        noFill();
    }

}
