public class Specimen extends MovingObject {

    private color colour; // denotes specimen
    private String type;

    public Specimen (float x, float y, float r, color colour, String type) {
        PVector p = new PVector(x, y);
        PVector v = new PVector(.5, 0);
        super.setPosition(new PVector(x, y));
        super.setVelocity(new PVector(.5, 0));
        super.setR(r);
        super.setDamping(0.8);
        this.colour = colour;
        this.type = type;
    }


    public int getColour() {
        return colour;
    }

    public String getType() {
        return type;
    }
    
    public void move() {
        super.move();
    }

    public void display() {
        // Draw Rock
        fill(colour);
        rect(super.getPositionX(), super.getPositionY(), super.getR()*2, super.getR()*2);
    }

    // Check boundaries of window
    public void checkWallCollision() {
        super.checkWallCollision();
    }

    public void checkGroundCollision(Ground groundSegment) {
        super.checkGroundCollision(groundSegment);
  }   

}
