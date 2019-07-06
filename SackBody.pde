public class SackBody extends Sackboy {

    private float bodyHeight;

    public SackBody(float bodyHeight) {
        this.bodyHeight = bodyHeight;
    }

    public void display() {
        fill(255, 255, 0);
        beginShape();
        curveVertex(55, bodyHeight);
        curveVertex(55, 78); // arm socket
        curveVertex(32, 78);
        curveVertex(30, bodyHeight);
        curveVertex(60, bodyHeight);
        curveVertex(55, 78);
        curveVertex(40, bodyHeight);
        endShape();
    }

}
