public class BaseCamp extends InteractiveBlockStructure {
    private color colour;

    public BaseCamp (float x_coordinate, float y_coordinate, float baseWidth, float baseHeight, color colour) {
        super(x_coordinate, y_coordinate, baseWidth, baseHeight);
        this.colour = colour;
    }

    public void display() {
        float x = get_x_coordinate();
        float y = get_y_coordinate();
        float baseWidth = getStructureWidth();
        float baseHeight = getStructureHeight();
        
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

    public boolean sackIsInside(Sack sack) {
        return super.sackIsInside(sack);
    } 
    
    public color getColor() {
      return colour;
    }
    
    public void setColour(color colour) {
        this.colour = colour;
    }
}
