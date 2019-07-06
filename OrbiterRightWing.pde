public class OrbiterRightWing extends Orbiter {

    private float x, y;

    public OrbiterRightWing(float x, float y) {
        this.x = x;
        this.y = y;
    }

    public void display() {
        triangle(x+super.getWidth(), y+super.getHeight(), 
            x+super.getWidth(), super.getHeight()+30, super.getWidth()+x+200, 
            y+super.getHeight());
        PImage flag = loadImage("flag.png");
        pushMatrix();
        translate(x+super.getWidth(), y+super.getHeight());
        image(flag, 10, -75, 75, 50);
        popMatrix();
    }

}
