public class ExternalTank extends Orbiter {

    private float x, y;

    public ExternalTank(float x, float y) {
        this.x = x;
        this.y = y;
    }

    public void display() {
        rect(x, y, super.getWidth(), super.getHeight());
        pushMatrix();
        translate(x, y);
        triangle(0, 0, super.getWidth()/2, -100, super.getWidth(), 0);
        popMatrix();
    }

}
