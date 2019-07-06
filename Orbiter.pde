/* 
*   Collision Detection for a stationary object
*   http://www.jeffreythompson.org/collision-detection/rect-rect.php 
*   
*/
public class Orbiter implements Collision {

    private float orbiterWidth = 100;
    private float orbiterHeight = 600;
    private float x; // position
    private float y; // position
    private ArrayList<Sack> passengers = new ArrayList<Sack>();
    private OrbiterBody body;
    private OrbiterLeftBooster leftBooster;
    private OrbiterRightBooster rightBooster;
    private OrbiterLeftWing leftWing;
    private OrbiterRightWing rightWing;
    private ExternalTank tank;

    public Orbiter() {
        
    }

    public Orbiter (float x, float y) {
        this.x = x;
        this.y = y;
        body = new OrbiterBody(x, y);
        leftBooster = new OrbiterLeftBooster(x, y);
        rightBooster = new OrbiterRightBooster(x, y);
        leftWing = new OrbiterLeftWing(x, y);
        rightWing = new OrbiterRightWing(x, y);
        tank = new ExternalTank(x, y);
    }

    // if Sack collides with orbiter, 
    // add Sack to passengers ArrayList and return true
    public boolean collisionDetected(Sack sack) {
        float sackWidth = sack.getBodyWidth();
        float sackHeight = sack.getBodyHeight();
        float sackPos_x = sack.getPositionX();
        float sackPos_y = sack.getPositionY();
        if (x + orbiterWidth >= sackPos_x &&
            x <= sackPos_x + sackWidth &&
            y + orbiterHeight >= sackPos_y &&
            y <= sackPos_y + sackHeight) {
                passengers.add(sack);
                return true;
        }
        return false;
    } 
    
    public ArrayList<Sack> getPassengers() {
        return passengers;
    }

    public void display() {
        color booster = color(166, 90, 13);
        fill(booster);
        tank.display();
        leftBooster.display();
        rightBooster.display();
        // displayExternalTank();
        // displayLeftBooster();
        // displayRightBooster();
        fill(245);
        body.display();
        // displayOrbiterBody();
        fill(100);
        leftWing.display();
        rightWing.display();
        // displayLeftWing();
        // displayRightWing();
    }

    public void displayOrbiterBody() {
        color c = color(193, 193, 193);
        fill(c);
        rect(x, y, 25, orbiterHeight+75);
        rect(x+25, y, 25, orbiterHeight+75);
        rect(x+50, y, 25, orbiterHeight+75);
        rect(x+75, y, 25, orbiterHeight+75);
        rect(x, y, orbiterWidth, orbiterHeight); // cockpit
        pushMatrix();
        color c2 = color(25, 29, 85);
        translate(x, y);
        rotate(radians(180));
        fill(c2);
        arc(-orbiterWidth/2, 0, orbiterWidth, 100, 0, PI);
        popMatrix();
    } 

    public void displayLeftWing() {
        triangle(x-200, y+orbiterHeight, x, orbiterHeight+30, x, y+orbiterHeight);
        PImage nasa = loadImage("nasa.png");
        pushMatrix();
        translate(x-200, y+orbiterHeight);
        image(nasa, 75, -100, 75, 75);
        popMatrix();
    }

    public void displayRightWing() {
        triangle(x+orbiterWidth, y+orbiterHeight, x+orbiterWidth, orbiterHeight+30, orbiterWidth+x+200, y+orbiterHeight);
        PImage flag = loadImage("flag.png");
        pushMatrix();
        translate(x+orbiterWidth, y+orbiterHeight);
        image(flag, 10, -75, 75, 50);
        popMatrix();
    }

    public void displayLeftBooster() {
        rect(x-orbiterWidth/4, y, orbiterWidth/4, orbiterHeight+25);
        pushMatrix();
        translate(x-orbiterWidth/4, y);
        triangle(0, 0, orbiterWidth/6, -50, orbiterWidth/4, 0);
        popMatrix();
    }
    public void displayRightBooster() {
        rect(x+orbiterWidth, y, orbiterWidth/4, orbiterHeight+25);
        pushMatrix();
        translate(x+orbiterWidth, y);
        triangle(0, 0, orbiterWidth/6, -50, orbiterWidth/4, 0);
        popMatrix();
    }

    public void displayExternalTank() {
        rect(x, y, orbiterWidth, orbiterHeight);
        pushMatrix();
        translate(x, y);
        triangle(0, 0, orbiterWidth/2, -100, orbiterWidth, 0);
        popMatrix();
    }

    public int getPassengersSize() {
        return passengers.size();
    }

    public float getX() {
        return x;
    }

    public float getY() {
        return y;
    }

    public float getWidth() {
        return orbiterWidth;
    }

    public float getHeight() {
        return orbiterHeight;
    }
       
}
