public abstract class MovingObject {
    
    // MovingObject has position and velocity
    PVector position;
    PVector velocity;
    PVector gravity = new PVector(0,0.05);
    float r, m;
    // A damping of n% slows it down when it hits the ground
    float damping;

    public void move() {
        velocity.add(gravity);
        position.add(velocity);
    }

    abstract void display();

    public void moveX(float x) {
        velocity.add(x, 0.05);
        position.add(velocity);
        // position.x += x;
    }

    public void moveY(float y) {
        velocity.add(0.05, y);
        position.add(velocity);
        // position.y += y;
    }

    public void setPosition(PVector pos) {
        position = pos;
    }

    public float getPositionX() {
        return position.x;
    }

    public float getPositionY() {
        return position.y;
    }

    public void addGravity(PVector g) {
        velocity.add(g);
    }

    public void setVelocity(PVector vec) {
        velocity = vec;
        velocity.mult(3);
    }

    public void addVelocity() {
        position.add(velocity);
    }

    public void setR(float r_) {
        r = r_;
        m = r*0.1;
    }

    public float getR() {
        return r;
    }

    public void setDamping(float n) {
        damping = n;
    }

    // Check boundaries of window
    void checkWallCollision() {
        if (position.x > width-r) {
            position.x = width-r;
            velocity.x *= -damping;
        } 
        else if (position.x < r) {
            position.x = r;
            velocity.x *= -damping;
        }
        if (position.y < 0) {
            position.y = 0+r;
            velocity.y *= -damping;
        }
        // else if (position.y < r) 
    }

    public boolean checkObjectCollision(MovingObject other) {
        // Get distances between the balls components
        PVector distanceVect = PVector.sub(other.position, position);

        // Calculate magnitude of the vector separating the balls
        float distanceVectMag = distanceVect.mag();

        // Minimum distance before they are touching
        float minDistance = r + other.r;

        if (distanceVectMag < minDistance) {
            float distanceCorrection = (minDistance-distanceVectMag)/2.0;
            PVector d = distanceVect.copy();
            PVector correctionVector = d.normalize().mult(distanceCorrection);
            other.position.add(correctionVector);
            position.sub(correctionVector);

            // get angle of distanceVect
            float theta  = distanceVect.heading();
            // precalculate trig values
            float sine = sin(theta);
            float cosine = cos(theta);

            /* bTemp will hold rotated ball positions. You 
            just need to worry about bTemp[1] position*/
            PVector[] bTemp = {
                new PVector(), new PVector()
            };

            /* this ball's position is relative to the other
            so you can use the vector between them (bVect) as the 
            reference point in the rotation expressions.
            bTemp[0].position.x and bTemp[0].position.y will initialize
            automatically to 0.0, which is what you want
            since b[1] will rotate around b[0] */
            bTemp[1].x  = cosine * distanceVect.x + sine * distanceVect.y;
            bTemp[1].y  = cosine * distanceVect.y - sine * distanceVect.x;

            // rotate Temporary velocities
            PVector[] vTemp = {
                new PVector(), new PVector()
            };

            vTemp[0].x  = cosine * velocity.x + sine * velocity.y;
            vTemp[0].y  = cosine * velocity.y - sine * velocity.x;
            vTemp[1].x  = cosine * other.velocity.x + sine * other.velocity.y;
            vTemp[1].y  = cosine * other.velocity.y - sine * other.velocity.x;

            /* Now that velocities are rotated, you can use 1D
            conservation of momentum equations to calculate 
            the final velocity along the x-axis. */
            PVector[] vFinal = {  
                new PVector(), new PVector()
            };

            // final rotated velocity for b[0]
            vFinal[0].x = ((m - other.m) * vTemp[0].x + 2 * other.m * vTemp[1].x) / (m + other.m);
            vFinal[0].y = vTemp[0].y;

            // final rotated velocity for b[0]
            vFinal[1].x = ((other.m - m) * vTemp[1].x + 2 * m * vTemp[0].x) / (m + other.m);
            vFinal[1].y = vTemp[1].y;

            // hack to avoid clumping
            bTemp[0].x += vFinal[0].x*10;
            bTemp[1].x += vFinal[1].x*10;

            /* Rotate ball positions and velocities back
            Reverse signs in trig expressions to rotate 
            in the opposite direction */
            // rotate balls
            PVector[] bFinal = { 
                new PVector(), new PVector()
            };

            bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
            bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
            bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
            bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;

            // update balls to screen position
            other.position.x = position.x + bFinal[1].x;
            other.position.y = position.y + bFinal[1].y;

            position.add(bFinal[0]);

            // update velocities
            velocity.x = cosine * vFinal[0].x - sine * vFinal[0].y;
            velocity.y = cosine * vFinal[0].y + sine * vFinal[0].x;
            other.velocity.x = cosine * vFinal[1].x - sine * vFinal[1].y;
            other.velocity.y = cosine * vFinal[1].y + sine * vFinal[1].x;
            return true;
        } else {
            return false;
        }
    }

    void checkGroundCollision(Ground groundSegment) {
        // Get difference between MovingObject and ground
        float deltaX = position.x - groundSegment.x;
        float deltaY = position.y - groundSegment.y;

        // Precalculate trig values
        float cosine = cos(groundSegment.rot);
        float sine = sin(groundSegment.rot);

        /* Rotate ground and velocity to allow 
            orthogonal collision calculations */
        float groundXTemp = cosine * deltaX + sine * deltaY;
        float groundYTemp = cosine * deltaY - sine * deltaX;
        float velocityXTemp = cosine * velocity.x + sine * velocity.y;
        float velocityYTemp = cosine * velocity.y - sine * velocity.x;

        /* Ground collision - check for surface 
            collision and also that MovingObject is within 
            left/rights bounds of ground segment */
        if (groundYTemp > -r &&
            position.x > groundSegment.x1 &&
            position.x < groundSegment.x2 ) {
            // keep MovingObject from going into ground
            groundYTemp = -r;
            // bounce and slow down MovingObject
            velocityYTemp *= -1.0;
            velocityYTemp *= damping;
        }

        // Reset ground, velocity and MovingObject
        deltaX = cosine * groundXTemp - sine * groundYTemp;
        deltaY = cosine * groundYTemp + sine * groundXTemp;
        velocity.x = cosine * velocityXTemp - sine * velocityYTemp;
        velocity.y = cosine * velocityYTemp + sine * velocityXTemp;
        position.x = groundSegment.x + deltaX;
        position.y = groundSegment.y + deltaY;
    }
}