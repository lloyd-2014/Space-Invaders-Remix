public class Rock extends MovingObject {

  public Rock(float x, float y, float r) {
    PVector p = new PVector(x, y);
    PVector v = new PVector(.5, 0);
    super.setPosition(new PVector(x, y));
    super.setVelocity(new PVector(.5, 0));
    super.setR(r);
    super.setDamping(1);
  }

  public void move() {
    super.move();
  }

  public void display() {
    // Draw Rock
    fill(100);
    PImage alien = loadImage("alien2.png");
    image(alien, super.getPositionX(), super.getPositionY(), super.getR()*2, super.getR()*2);
    // ellipse(super.getPositionX(), super.getPositionY(), super.getR()*2, super.getR()*2);
  }
  
  // Check boundaries of window
  public void checkWallCollision() {
    super.checkWallCollision();
  }

  public void checkGroundCollision(Ground groundSegment) {
      super.checkGroundCollision(groundSegment);
  }      
}