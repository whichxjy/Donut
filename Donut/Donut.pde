CollisionSystem collisionSystem;

void setup() {
    fullScreen();
    /***************************************
     *     Initialize Collision System     *
     ***************************************/
    ArrayList<HardSphere> hardSpheres = new ArrayList<HardSphere>();
    int num = 10;   // The number of hard spheres
    for (int i = 0; i < num; i++) {
        float positionX = (i + 2) * (width / (num + 3));
        float positionY = (i + 2) * (height / (num + 3));
        PVector position = new PVector(positionX, positionY);
        PVector direction = (new PVector(randomGaussian(), randomGaussian())).normalize();
        PVector velocity = PVector.mult(direction, randomGaussian() * 1.5);
        float radius = 20;
        float mass = 50;
        hardSpheres.add(new HardSphere(position, velocity, radius, mass));
    }
    int limit = 99999;
    collisionSystem = new CollisionSystem(hardSpheres, limit);
}

void draw() {
    collisionSystem.run();
}
