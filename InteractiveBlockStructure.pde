/**
*   Abstract class representing rectangular structures which trigger event when a sack goes "inside" it
*/
public abstract class InteractiveBlockStructure {
	private float x_coordinate;
	private float y_coordinate;
	private float structureWidth;
	private float structureHeight;
	
	public InteractiveBlockStructure() {}
	
	public InteractiveBlockStructure(float x_coordinate, float y_coordinate, float structureWidth, float structureHeight) {
		this.x_coordinate = x_coordinate;
		this.y_coordinate = y_coordinate;
		this.structureWidth = structureWidth;
		this.structureHeight = structureHeight;
	}
  
	public boolean sackIsInside(Sack sack) {
		float sackWidth = sack.getBodyWidth();
		float sackHeight = sack.getBodyHeight();
		float sackPos_x = sack.getPositionX();
		float sackPos_y = sack.getPositionY();
		boolean isInside = false;

		if (x_coordinate + structureWidth >= sackPos_x &&
			x_coordinate <= sackPos_x + sackWidth &&
			y_coordinate + structureHeight >= sackPos_y &&
			y_coordinate <= sackPos_y + sackHeight) {
				isInside = true;
		} 
		else {
			isInside = false;
		}

		return isInside;
	}
	
	public float get_x_coordinate() {
		return x_coordinate;
	}
	
	public float get_y_coordinate() {
	  	return y_coordinate;
	}
	
	public float getStructureWidth() {
	  	return structureWidth;
	}
 
	public float getStructureHeight() {
	  return structureHeight;
	}
	
	public void setStructureHeight(float structureHeight) {
		this.structureHeight = structureHeight;
	}
	
	public void setStructureWidth(float structureWidth) {
		this.structureWidth = structureWidth; 
	}
	
	public void set_x_coordinate(float x_coordinate) {
		this.x_coordinate = x_coordinate;
	}
	
	public void set_y_coordinate(float y_coordinate) {
	  	this.y_coordinate = y_coordinate; 
	}
}
