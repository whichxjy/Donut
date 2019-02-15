public class Event implements Comparable<Event> {
    private final int time;                 // time that event is scheduled to occur
    private final HardSphere roleA, roleB;  // hard spheres involved in event, possibly null
    private final int countA, countB;       // collision counts at event creation

    public Event (int time, HardSphere roleA, HardSphere roleB) {
        this.time = time;
        this.roleA = roleA;
        this.roleB = roleB;
        this.countA = (roleA != null) ? roleA.getCount() : -1;
        this.countB = (roleB != null) ? roleB.getCount() : -1;
    }

    public int compareTo(Event that) {
        return Integer.compare(this.time, that.time);
    }

    public boolean isValid() {
        if (roleA != null && roleA.getCount() != countA) {
            return false;
        } else if (roleB != null && roleB.getCount() != countB) {
            return false;
        } else {
            return true;
        }
    }

    public void occur() {
        if (roleA != null & roleB != null) {
            // particle-particle collision
            roleA.bounceOff(roleB);
        } else if (roleA != null && roleB == null) {
            // particle-vertical_wall collision
            roleA.bounceOffVerticalWall();
        } else if (roleA == null && roleB != null) {
            // particle-horizontal_wall collision
            roleB.bounceOffHorizontalWall();
        }
    }

    public void highlight() {
        if (roleA != null) {
            roleA.setHighlight(true);
        }

        if (roleB != null) {
            roleB.setHighlight(true);
        }
    }

    public void removeHighlight() {
        if (roleA != null) {
            roleA.setHighlight(false);
        }

        if (roleB != null) {
            roleB.setHighlight(false);
        }
    }

    public HardSphere getRoleA() {
        return this.roleA;
    }

    public HardSphere getRoleB() {
        return this.roleB;
    }

    public int getTime() {
        return this.time;
    }

}
