public class JetPack {

    private float x, y;
    private float packWidth, packHeight;

    public JetPack (float x, float y, float packWidth, float packHeight) {
        this.x = x;
        this.y = y;
        this.packWidth = packWidth;
        this.packHeight = packHeight;
    }

    public void display() {
        fill(100);
        rect(x, y, packWidth, packHeight);
        drawTopOfTank(x, y);
        fill(100);
        rect(x+packWidth, y, packWidth, packHeight);
        drawTopOfTank(x+packWidth, y);
        pushMatrix();
        translate(x, y);
        rect(packWidth/3, packHeight, 10, 10);
        popMatrix();
        pushMatrix();
        translate(x+packWidth, y);
        rect(packWidth/3, packHeight, 10, 10);
        popMatrix();
        turnOn();
        noFill();
    }

    private void drawTopOfTank(float x1, float y1) {
        fill(232, 15, 15);
        pushMatrix();
        translate(x1, y1);
        rotate(radians(180));
        arc(-packWidth/2, 0, packWidth, 30, 0, PI);
        popMatrix();
        noFill();
    }

    public void turnOn() {
        PImage jetFlame = loadImage("jetFlame.png");
        pushMatrix();
        translate(x, y);
        translate(packWidth/3, packHeight);
        image(jetFlame, -3, 8, 15, 130);
        popMatrix();
        pushMatrix();
        translate(x+packWidth, y);
        translate(packWidth/3, packHeight);
        image(jetFlame, -3, 8, 15, 130);
        popMatrix();
    }

}
