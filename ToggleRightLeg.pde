public class ToggleRightLeg extends Toggle {

    private float legLength;
    private float bodyHeight;

    public ToggleRightLeg(float legLength, float bodyHeight) {
        this.legLength = legLength;
        this.bodyHeight = bodyHeight;
    }

    public void display() {
        fill(255, 255, 0);
        pushMatrix();
        translate(80, bodyHeight+8);
        // rotate(radians(super.getRightArmAngle()*45));
        fill(255);
        beginShape();
        curveVertex(0, 0);
        curveVertex(15, legLength); // shoulder
        curveVertex(0, legLength); // shoulder
        curveVertex(0, 0); // forearm
        curveVertex(15, 0); // forearm 
        curveVertex(15, legLength); // forearm
        curveVertex(0, 0);
        endShape();
        popMatrix();
        noFill();
    }

}
