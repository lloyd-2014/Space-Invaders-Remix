public class Tesla extends MovingObject {

    public Tesla (float x, float y, float r) {
        PVector p = new PVector(x, y);
        PVector v = new PVector(.5, 0);
        super.setPosition(new PVector(x, y));
        super.setVelocity(new PVector(.5, 0));
        super.setR(r);
        super.setDamping(0.8);
    }

    public void move() {
        super.move();
    }

    public void display() {
        // Draw Rock
        fill(100);
        PImage tesla = loadImage("tesla.png");
        image(tesla, super.getPositionX(), super.getPositionY(), super.getR()*2, super.getR()*2);
    }
    
    // Check boundaries of window
    public void checkWallCollision() {
        super.checkWallCollision();
    }

    public void checkGroundCollision(Ground groundSegment) {
        super.checkGroundCollision(groundSegment);
    }

}
