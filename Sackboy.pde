public class Sackboy extends Sack {

    private SackHead sackHead;
    private SackBody sackBody;
    private SackLeftArm leftArm;
    private SackRightArm rightArm;
    private SackLeftLeg leftLeg;
    private SackRightLeg rightLeg;
    private float armLength = super.getArmLength();
    private float legLength = super.getLegLength();
    private float bodyHeight = super.getBodyHeight();
    private float leftArmAngle = getLeftArmAngle();
    private float rightArmAngle = getRightArmAngle();

    public Sackboy() {
       
    }

    public Sackboy (float SACK_X, float SACK_Y) {
        super(120, 42, 30, SACK_X, SACK_Y, new JetPack(-5, 20, 50, 100));
        this.sackHead = new SackHead();
        this.sackBody = new SackBody(bodyHeight);
        this.leftArm = new SackLeftArm(armLength);
        this.rightArm = new SackRightArm(armLength);
        this.leftLeg = new SackLeftLeg(legLength);
        this.rightLeg = new SackRightLeg(legLength);
    }

    public String getName() {
        return "Sackboy";
    }
    
    public void drawHead() {
        sackHead.display();
    }

    public void drawBody() {
        sackBody.display();
    }

    public void drawLeftArm() {
        leftArm.display();
    }

    public void drawRightArm() {
        rightArm.display();
    }
    

    public void drawLeftLeg() {
        leftLeg.display();
    }

    public void drawRightLeg() {
        rightLeg.display();
    }

    public void collectSpecimen(Specimen s) {
        super.collectSpecimen(s);
    }

    public float getBodyHeight() {
        return super.getBodyHeight();
    }

    public float getArmLength() {
        return super.getArmLength();
    }

    public float getLegLength() {
        return super.getLegLength();
    }

    public float getRightArmAngle() {
        return super.getRightArmAngle();
    } 

    public float getLeftArmAngle() {
        return super.getLeftArmAngle();
    }
}
