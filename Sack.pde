public abstract class Sack extends MovingObject {

    private float bodyWidth;
    private float bodyHeight;
    private float armLength;
    private float legLength;
    private float SACK_X;
    private float SACK_Y;
    private float midPoint;
    private float rightArmAngle;
    private float leftArmAngle;
    private ArrayList<Specimen> specimens = new ArrayList<Specimen>();
    private int greenSpecimenCount = 0;
    private int blueSpecimenCount = 0;
    private int redSpecimenCount = 0;
    private boolean isAlive;
    private boolean isSafe;
    private JetPack jetPack;
    private int healthPoints;

    public Sack() {

    }

    protected Sack (float bodyHeight, float armLength, float legLength, float SACK_X, float SACK_Y, JetPack jetPack) {
        this.bodyHeight = bodyHeight;
        this.bodyWidth = 30;
        this.armLength = armLength;
        this.legLength = legLength;
        this.SACK_X = SACK_X;
        this.SACK_Y = SACK_Y;
        super.setPosition(new PVector(SACK_X, SACK_Y));
        super.setVelocity(new PVector(0.5, 0));
        super.setR(bodyHeight/2+legLength/2);
        super.setDamping(0.2);
        isAlive = true;
        this.jetPack = jetPack;
        this.healthPoints = 3;
    }

    public void display() {
        pushMatrix();
        translate(position.x, position.y);
        scale(0.5);
        drawSack();
        popMatrix();
    }

    private void drawSack() {
        mouseMoved();
        jetPack.display();
        drawBody();
        drawHead();
        drawLeftArm();
        drawRightArm();
        drawLeftLeg();
        drawRightLeg(); 
    }

    abstract void drawBody();
    abstract void drawHead();
    abstract void drawRightArm();
    abstract void drawLeftArm();
    abstract void drawLeftLeg();
    abstract void drawRightLeg();
    abstract String getName();

    public void collectSpecimen(Specimen s) {
        specimens.add(s);
        incrementSpecimenTypeCount(s);
    } 
    
    private void incrementSpecimenTypeCount(Specimen s) {
        if (s.type == "green") ++greenSpecimenCount;
        if (s.type == "blue") ++blueSpecimenCount;
        if (s.type == "red") ++redSpecimenCount;
    }
    
    public int getGreenSpecimenCount() { return greenSpecimenCount; }
    public int getBlueSpecimenCount() { return blueSpecimenCount; }
    public int getRedSpecimenCount() { return redSpecimenCount; }
    
    public ArrayList<Specimen> mySpecimens() {
        return specimens;
    }

    public void move() {
        super.move();
    }


    public void checkWallCollision() {
        super.checkWallCollision();
    }


    public void checkGroundCollision(Ground groundSegment) {
        super.checkGroundCollision(groundSegment);
    }

    private void mouseMoved() {
        int RIGHT_PIVOT_X = 59;
        int LEFT_PIVOT_X = 30;
        int PIVOT_Y = 90;
        float mx = mouseX - SACK_X;
        float my = mouseY - SACK_Y;
        leftArmAngle = -atan2(my - PIVOT_Y, mx - LEFT_PIVOT_X) + HALF_PI;
        rightArmAngle = atan2(my - PIVOT_Y, mx - RIGHT_PIVOT_X) - HALF_PI;
    }

    public void moveX(float x) {
        super.moveX(x);
    }

    public void moveY(float y) {
        super.moveY(y);
    }

    public float getBodyHeight() {
        return bodyHeight;
    }

    public float getBodyWidth() {
        return bodyWidth;
    }

    public void setBodyWidth(int bodyWidth) {
        this.bodyWidth = bodyWidth;
    }

    public float getArmLength() {
        return armLength;
    }

    public float getLegLength() {
        return legLength;
    }

    public float getSACK_X() {
        return SACK_X;
    }

    public void setSACK_X(float x) {
        SACK_X = x;
    }

    public float getSACK_Y() {
        return SACK_Y;
    }

    public void setSACK_Y(float y) {
        SACK_Y = y;
    }

    public float getPositionX() {
        return super.getPositionX();
    }

    public float getPositionY() {
        return super.getPositionY();
    }

    public float getMidPoint() {
        return midPoint;
    }

    public float getRightArmAngle() {
        mouseMoved();
        return rightArmAngle;
    }

    public float getLeftArmAngle() {
        mouseMoved();
        return leftArmAngle;
    }

    public void setJetPack(JetPack jp) {
        jetPack = jp;
    }  

    public void turnOnJetPack() {
        jetPack.turnOn();
    }

    public int getHP() {
        return healthPoints;
    }

    public void decreaseHP() {
        if (!isSafe) {
            --healthPoints;
        }
    }

    public boolean isAlive() {
        if (healthPoints == 0) 
            return false;
        else 
            return true;
    } 

    public void inBaseCamp(boolean safe) {
        if (safe) 
            isSafe = true;
        else 
            isSafe = false; 
    }

}
