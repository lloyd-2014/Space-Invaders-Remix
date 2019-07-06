public class OrbiterBody extends Orbiter {

    private float x, y;

    public OrbiterBody(float x, float y) {
        this.x = x; 
        this.y = y;
    }
    
    public void display() {
        color c = color(193, 193, 193);
        fill(c);
        rect(x, y, 25, super.getHeight()+75);
        rect(x+25, y, 25, super.getHeight()+75);
        rect(x+50, y, 25, super.getHeight()+75);
        rect(x+75, y, 25, super.getHeight()+75);
        rect(x, y, super.getWidth(), super.getHeight()); // cockpit
        pushMatrix();
        color c2 = color(25, 29, 85);
        translate(x, y);
        rotate(radians(180));
        fill(c2);
        arc(-super.getWidth()/2, 0, super.getWidth(), 100, 0, PI);
        popMatrix();
    } 

}
