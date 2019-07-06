public class Toggle extends Sack {
    
    private ToggleHead toggleHead;
    private ToggleBody toggleBody;
    private ToggleLeftArm leftArm;
    private ToggleRightArm rightArm;
    private ToggleLeftLeg leftLeg;
    private ToggleRightLeg rightLeg;
    private float armLength = super.getArmLength();
    private float legLength = super.getLegLength();
    private float bodyHeight = super.getBodyHeight();
    private float leftArmAngle = getLeftArmAngle();
    private float rightArmAngle = getRightArmAngle();

    public Toggle() {

    }

    public Toggle (float TOGGLE_X, float TOGGLE_Y) {
        super(200, 60, 30, TOGGLE_X, TOGGLE_Y, new JetPack(-20, 80, 75, 130));
        this.toggleHead = new ToggleHead();
        this.toggleBody = new ToggleBody(bodyHeight);
        this.leftArm = new ToggleLeftArm(armLength);
        this.rightArm = new ToggleRightArm(armLength);
        this.leftLeg = new ToggleLeftLeg(legLength, bodyHeight);
        this.rightLeg = new ToggleRightLeg(legLength, bodyHeight);
    }

    public String getName() {
        return "Toggle";
    }

    // character's head is also their body
    public void drawBody() {
        toggleBody.display();
    }

    public void drawHead() {
        toggleHead.display();
    }

    public void drawRightArm() {
        rightArm.display();
    }
    
    public void drawLeftArm() {
        leftArm.display();
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

    public float getRightArmAngle() {
        return super.getRightArmAngle();
    }

    public float getLeftArmAngle() {
        return super.getLeftArmAngle();
    }

}