public class BaseCamp implements Collision {

    private float x, y;
    private float baseWidth, baseHeight;
    private color colour;

    public BaseCamp (float x, float y) {
        this.x = x;
        this.y = y;
        this.baseWidth = 400;
        this.baseHeight = 300;
        this.colour = color(169, 229, 236);
    }

    public void display() {
        fill(colour);
        rect(x, y, baseWidth, baseHeight); 
        pushMatrix();
        translate(x, y);
        rotate(radians(180));
        fill(25, 29, 85);
        arc(-baseWidth/2, 0, baseWidth, 150, 0, PI);
        fill(216, 202, 191);
        popMatrix();
        rect(x*2, y, baseWidth/2, baseHeight);
        noFill();
    }

    public boolean collisionDetected(Sack sack) {
        float sackWidth = sack.getBodyWidth();
        float sackHeight = sack.getBodyHeight();
        float sackPos_x = sack.getPositionX();
        float sackPos_y = sack.getPositionY();
        if (x + baseWidth >= sackPos_x &&
            x <= sackPos_x + sackWidth &&
            y + baseHeight >= sackPos_y &&
            y <= sackPos_y + sackHeight) {
                colour = color(74, 201, 78);
                return true;
        } else {
            colour = color(169, 229, 236);
            return false;
        }
    } 

}