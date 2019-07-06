public class ToggleBody extends Toggle {

    private float bodyHeight;

    public ToggleBody(float bodyHeight) {
        this.bodyHeight = bodyHeight;
    }

    public void display() {
        fill(255, 255, 0);
        beginShape();
        curveVertex(75, bodyHeight);
        curveVertex(75, 78); // arm socket
        curveVertex(15, 78);
        curveVertex(10, bodyHeight);
        curveVertex(100, bodyHeight);
        curveVertex(75, 78);
        curveVertex(40, bodyHeight);
        endShape();
        super.setBodyWidth(90);
        noFill();
    }

}
