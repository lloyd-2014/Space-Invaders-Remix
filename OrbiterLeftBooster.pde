public class OrbiterLeftBooster extends Orbiter {

    private float x, y;

    public OrbiterLeftBooster(float x, float y) {
        this.x = x;
        this.y = y;
    }

    public void display() {
        rect(x-super.getWidth()/4, y, super.getWidth()/4, super.getHeight()+25);
        pushMatrix();
        translate(x-super.getWidth()/4, y);
        triangle(0, 0, super.getWidth()/6, -50, super.getWidth()/4, 0);
        popMatrix();
    }

}
