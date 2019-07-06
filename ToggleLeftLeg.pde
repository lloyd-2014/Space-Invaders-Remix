public class ToggleLeftLeg extends Toggle {

    private float legLength;
    private float bodyHeight;

    public ToggleLeftLeg(float legLength, float bodyHeight) {
        this.legLength = legLength;
        this.bodyHeight = bodyHeight;
    }

    public void display() {
        fill(255, 255, 0);
        pushMatrix();
        translate(33, bodyHeight+8);
        // rotate(radians(super.getLeftArmAngle()*55));
        fill(255);
        beginShape();
        curveVertex(-15, 0);
        curveVertex(0, legLength); // shoulder
        curveVertex(-15, legLength); // shoulder
        curveVertex(-15, 0); // forearm
        curveVertex(0, 0); // forearm 
        curveVertex(0, legLength); // forearm
        curveVertex(-15, 0);
        endShape();
        popMatrix();
        noFill();
    }

}
