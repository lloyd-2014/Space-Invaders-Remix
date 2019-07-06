public class OrbiterRightBooster extends Orbiter {

    private float x, y;

    public OrbiterRightBooster(float x, float y) {
        this.x = x;
        this.y = y;
    }

    public void display() {
        rect(x+super.getWidth(), y, super.getWidth()/4, super.getHeight()+25);
        pushMatrix();
        translate(x+super.getWidth(), y);
        triangle(0, 0, super.getWidth()/6, -50, super.getWidth()/4, 0);
        popMatrix();
    }

}
