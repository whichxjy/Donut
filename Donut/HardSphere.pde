public class HardSphere {
    private PVector position;
    private PVector velocity;
    private float radius;
    private float mass;
    private int count;  // number of collisions so far
    private boolean highlight;

    private static final int INFINITY = Integer.MAX_VALUE;

    public HardSphere(PVector position, PVector velocity, float radius, float mass) {
        this.position = position;
        this.velocity = velocity;
        this.radius = radius;
        this.mass = mass;
        this.highlight = false;
    }

    public void display() {
        noStroke();
        if (highlight) {
            fill(10, 20, 30);
        } else {
            fill(138, 176, 216);
        }
        circle(position.x, position.y, 2 * radius);
    }

    public void move() {
        position.add(velocity);
    }

    public int timeToHit(HardSphere that) {
        if (this == that) {
            return INFINITY;
        }

        PVector dr = PVector.sub(this.position, that.position); // Delta position
        PVector dv = PVector.sub(this.velocity, that.velocity); // Delta velocity
        float dvdr = PVector.dot(dv, dr);

        if (dvdr >= 0) {
            return INFINITY;
        }

        float dvdv = PVector.dot(dv, dv);

        if (dvdv == 0) {
            return INFINITY;
        }

        float drdr = PVector.dot(dr, dr);
        float sigma = this.radius + that.radius;
        float d = (dvdr * dvdr) - dvdv * (drdr - sigma * sigma);

        if (d < 0) {
            return INFINITY;
        }

        return round(-(dvdr + sqrt(d)) / dvdv);
    }

    public int timeToHitHorizontalWall() {
        if (velocity.y > 0) {
            return round((height - position.y - radius) / velocity.y);
        } else if (velocity.y < 0) {
            return round((radius - position.y) / velocity.y);
        } else {
            return INFINITY;
        }
    }

    public int timeToHitVerticalWall() {
        if (velocity.x > 0) {
            return round((width - position.x - radius) / velocity.x);
        } else if (velocity.x < 0) {
            return round((radius - position.x) / velocity.x);
        } else {
            return INFINITY;
        }
    }

    public void bounceOff(HardSphere that) {
        PVector dr = PVector.sub(that.position, this.position); // Delta position
        PVector dv = PVector.sub(that.velocity, this.velocity); // Delta velocity
        float dvdr = PVector.dot(dv, dr);
        float dist = this.radius + that.radius;

        // magnitude of normal force
        float magnitude = (2 * this.mass * that.mass * dvdr) / ((this.mass + that.mass) * dist);

        // normal force
        PVector normalForce = dr.mult(magnitude).div(dist);

        // update velocities according to normal force
        this.velocity.add(PVector.div(normalForce, this.mass));
        that.velocity.sub(PVector.div(normalForce, that.mass));

        // update collision counts
        this.count++;
        that.count++;
    }

    public void bounceOffHorizontalWall() {
        velocity.y = -velocity.y;
        count++;
    }

    public void bounceOffVerticalWall() {
        velocity.x = -velocity.x;
        count++;
    }

    public int getCount() {
        return this.count;
    }

    public void setHighlight(boolean highlight) {
        this.highlight = highlight;
    }
    
}
