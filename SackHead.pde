public class SackHead extends Sackboy {

    public void display() {
        fill(255, 255, 0);
        beginShape();
        curveVertex(84, 70);
        curveVertex(70, 70);
        curveVertex(84, 60);
        curveVertex(70, 20);
        curveVertex(10, 20);
        curveVertex(6, 70);
        curveVertex(70, 70);
        curveVertex(21, 75);
        endShape();
        fill(0, 0, 0);
        ellipse(60, 35, 10, 10); // right eye
        ellipse(20, 35, 10, 10); // left eye
    }

}
