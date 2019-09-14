/* 
*   Collision Detection for a stationary object
*   http://www.jeffreythompson.org/collision-detection/rect-rect.php 
*   
*/
public class Orbiter extends InteractiveBlockStructure {
    private ArrayList<Sack> passengers = new ArrayList<Sack>();
     
    public Orbiter (float x_coordinate, float y_coordinate, float orbiterWidth, float orbiterHeight) {
        super(x_coordinate, y_coordinate, orbiterWidth, orbiterHeight);
    }

    // if Sack collides with orbiter, 
    // add Sack to passengers ArrayList and return true
    public boolean sackIsInside(Sack sack) {
        return super.sackIsInside(sack);
    } 
    
    public ArrayList<Sack> getPassengers() {
        return passengers;
    }

    public void addPassenger(Sack sack) {
        passengers.add(sack);
    }

    public void display() {
        color booster = color(166, 90, 13);
        fill(booster);
        displayExternalTank();
        displayLeftBooster();
        displayRightBooster();
        fill(245);
        displayOrbiterBody();
        fill(100);
        displayLeftWing();
        displayRightWing();
    }
 
    public void displayOrbiterBody() {
        float orbiterHeight = getStructureHeight();
        float orbiterWidth = getStructureWidth();
        float x = get_x_coordinate();
        float y = get_y_coordinate();
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
        float orbiterHeight = getStructureHeight();
        float x = get_x_coordinate();
        float y = get_y_coordinate();
      
        triangle(x-200, y+orbiterHeight, x, orbiterHeight+30, x, y+orbiterHeight);
        PImage nasa = loadImage("nasa.png");
        pushMatrix();
        translate(x-200, y+orbiterHeight);
        image(nasa, 75, -100, 75, 75);
        popMatrix();
    }

    public void displayRightWing() {
        float orbiterHeight = getStructureHeight();
        float orbiterWidth = getStructureWidth();
        float x = get_x_coordinate();
        float y = get_y_coordinate();
        
        triangle(x+orbiterWidth, y+orbiterHeight, x+orbiterWidth, orbiterHeight+30, orbiterWidth+x+200, y+orbiterHeight);
        PImage flag = loadImage("flag.png");
        pushMatrix();
        translate(x+orbiterWidth, y+orbiterHeight);
        image(flag, 10, -75, 75, 50);
        popMatrix();
    }

    public void displayLeftBooster() {
        float orbiterHeight = getStructureHeight();
        float orbiterWidth = getStructureWidth();
        float x = get_x_coordinate();
        float y = get_y_coordinate();  
      
        rect(x-orbiterWidth/4, y, orbiterWidth/4, orbiterHeight+25);
        pushMatrix();
        translate(x-orbiterWidth/4, y);
        triangle(0, 0, orbiterWidth/6, -50, orbiterWidth/4, 0);
        popMatrix();
    }
    public void displayRightBooster() {
        float orbiterHeight = getStructureHeight();
        float orbiterWidth = getStructureWidth();
        float x = get_x_coordinate();
        float y = get_y_coordinate();
      
        rect(x+orbiterWidth, y, orbiterWidth/4, orbiterHeight+25);
        pushMatrix();
        translate(x+orbiterWidth, y);
        triangle(0, 0, orbiterWidth/6, -50, orbiterWidth/4, 0);
        popMatrix();
    }

    public void displayExternalTank() {
        float orbiterHeight = getStructureHeight();
        float orbiterWidth = getStructureWidth();
        float x = get_x_coordinate();
        float y = get_y_coordinate();
      
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
        return super.get_x_coordinate();
    }

    public float getY() {
        return super.get_y_coordinate();
    }

    public float getWidth() {
        return super.getStructureWidth();
    }

    public float getHeight() {
        return super.getStructureHeight();
    }
       
}
