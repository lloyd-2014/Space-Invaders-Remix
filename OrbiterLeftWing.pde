public class OrbiterLeftWing extends Orbiter {

    private float x, y;

    public OrbiterLeftWing(float x, float y) {
        this.x = x;
        this.y = y;
    }

    public void display() {
        triangle(x-200, y+super.getHeight(), x, super.getHeight()+30, 
            x, y+super.getHeight());
        PImage nasa = loadImage("nasa.png");
        pushMatrix();
        translate(x-200, y+super.getHeight());
        image(nasa, 75, -100, 75, 75);
        popMatrix();
    }

}
