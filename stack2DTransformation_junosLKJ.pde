float START_X;
float START_Y;
Sackboy sackboy;
Rock rock;
Toggle toggle;
Orbiter orbiter;
BaseCamp baseCamp;
int segments = 40;
Ground[] ground = new Ground[segments];
ArrayList<MovingObject> objects = new ArrayList<MovingObject>();
ArrayList<Sack> astronauts = new ArrayList<Sack>();
ArrayList<Sack> graveyard = new ArrayList<Sack>();
Menu menu;
int alienSpawnTime = millis();
int specimenSpawnTime = millis();
int alienFrequency;
boolean sackboyIsDead = false;
boolean toggleIsDead = false;
int hp;
int alienCount;
String message;
int redCount;
int greenCount;
int blueCount;
Specimen currentSpec;

JetPack jp;

void setup() {
    START_X = width/6;
    START_Y = height;
    // size(1024, 800);
    // frameRate(15);
    fullScreen();
    menu = new Menu(width, height);
    // frameRate(15);
    objects.add(new Tesla(1400, 0, 100));
    sackboy = new Sackboy(START_X, START_Y);
    toggle = new Toggle(START_X, START_Y);
    orbiter = new Orbiter(width-200, height-650, 100, 600);
    baseCamp = new BaseCamp(100, height-300, 400, 300, color(169, 229, 236));
    astronauts.add(sackboy);
    PFont font = loadFont("Consolas-48.vlw");
    textFont(font, 32);
    // astronauts.add(toggle);
    float[] peakHeights = new float[segments+1];
    for (int i = 0; i < peakHeights.length; i++) {
        peakHeights[i] = random(height-40, height-30);
    }
    float segs = segments;
    for (int i = 0; i < segments; i++) {
        ground[i] = new Ground(width/segs*i, peakHeights[i], width/segs*(i+1), peakHeights[i+1]); 
    }
}

void draw() {
    PImage earth = loadImage("earthRise.jpg");
    background(0);
    image(earth, width/2, height/2);
    baseCamp.display();
    orbiter.display();
    if (!menu.startGame()) {
        menu.display();
    } else { // start game
        alienFrequency = menu.getAlienFrequency();        
        spawnAlien();
        spawnSpecimin();
        displayStatistics();
        // display Astronauts and objects e.g. aliens and moon specimens
        for (int inc = 0; inc < astronauts.size(); inc++) {
            Sack sack = astronauts.get(inc);
            keyPressed(sack);
            sack.move();
            sack.display();
            sack.checkWallCollision();
            hp = sack.getHP();
            if (orbiter.sackIsInside(sack)) {
                orbiter.addPassenger(sack);
                message = "You enter the orbiter";
                astronauts.remove(sack);
                if (sack instanceof Sackboy) {
                    astronauts.add(toggle);
                }
            } 
            if (baseCamp.sackIsInside(sack)) {
                //sack.inBaseCamp(true);
                baseCamp.setColour(color(74, 201, 78));
                message = "You cannot be hurt in the base camp.";
                // println("You cannot be hurt in the base camp.");
            } else {
                sack.inBaseCamp(false);
                baseCamp.setColour(color(169, 229, 236));
            }
            for (int i=0; i<segments; i++) {
                sack.checkGroundCollision(ground[i]);
                // sackboy.checkGroundCollision(ground[i]);
            }
            // display aliens, specimens, and Tesla
            for (int i = 0; i < objects.size(); i++) {
                Specimen temp;
                objects.get(i).move();
                objects.get(i).display();
                objects.get(i).checkWallCollision();
                for (int j = 0; j < segments; j++) {
                    objects.get(i).checkGroundCollision(ground[j]);
                }
                for (int k = 0; k < objects.size(); k++) {
                    if (objects.get(k) != objects.get(i)) {
                        objects.get(i).checkObjectCollision(objects.get(k));
                        if (objects.get(k).checkObjectCollision(sack)) {
                            if (objects.get(k) instanceof Rock) {
                                sack.decreaseHP();
                                message = "You've been hit.";
                                // println("You've been hit.");
                                if (!sack.isAlive()) {
                                    message = "You have died!";
                                    // println("You have died!");
                                    graveyard.add(sack);
                                    astronauts.remove(sack);
                                    if (sack instanceof Sackboy) sackboyIsDead = true;
                                    if (sack instanceof Toggle) toggleIsDead = true;
                                    if (sackboyIsDead && !toggleIsDead) {
                                        astronauts.add(toggle); // if sackboy dies but toggle is alive
                                        message = "Toggle has exited the base camp.";
                                    }
                                }
                            }
                            if (objects.get(k) instanceof Specimen) {
                                message = "You collected the specimen.";
                                sack.collectSpecimen((Specimen)objects.get(k));
                                currentSpec = (Specimen)objects.get(k); 
                                objects.remove(objects.get(k));
                            }
                        }
                    }
                    else continue;
                }
            }    
        }
    }
    fill(127);    
    beginShape();
    for (int i=0; i<segments; i++){
        vertex(ground[i].x1, ground[i].y1);
        vertex(ground[i].x2, ground[i].y2);
    }
    vertex(ground[segments-1].x2, height);
    vertex(ground[0].x1, height);
    endShape(CLOSE);
    if (astronauts.size() == 0) gameOver();
}   

void keyPressed(Sack sack) {
    if (keyPressed) {
        if (key == 'd' || key == 'D') {
            sack.moveX(1);
            sack.move();
        }
        if (key == 'a' || key == 'A') {
            sack.moveX(-1);
            sack.move();
        }
        if (key == 'w' || key == 'W') {
            sack.moveY(-1);
            sack.move();
        }
        if (key == 's' || key == 'S') {
            sack.moveY(1);
            sack.move();
        }
            // useful if sack gets stuck 
        if (key == 'k' || key == 'K') {
            if (astronauts.size() > 0) {
                graveyard.add(astronauts.get(0));
                astronauts.remove(0);
            }
        }
    } 
}

void gameOver() {
    textSize(100);
    iterateGraveyard();
    if (astronauts.size() == 0 && (!toggleIsDead || !sackboyIsDead)) {
        iterateOrbiter();
        textSize(50);
        fill(127);        
        text("You survived the Alien horde.", width/3, height/2);    
        displayStatistics();
    }
}

void iterateGraveyard() {
    int sackboyGreen = 0; 
    int sackboyBlue = 0; 
    int sackboyRed = 0;
    int toggleGreen = 0; 
    int toggleBlue = 0; 
    int toggleRed = 0;
    if (graveyard.size() == 2) {
        fill(127);        
        text("GAME OVER", width/3, height/2);
        noFill();
    }
    if (graveyard.size() > 0) {
        displayStatistics();
        for (Sack sack : graveyard) {
            textSize(24);
            ArrayList<Specimen> specs = sack.mySpecimens();
            for (Specimen s : specs) {
                if (sack instanceof Sackboy) {
                    if (s.getType() == "green") sackboyGreen++;
                    if (s.getType() == "blue") sackboyBlue++;
                    if (s.getType() == "red") sackboyRed++;
                } 
                else if (sack instanceof Toggle) {
                    if (s.getType() == "green") toggleGreen++;
                    if (s.getType() == "blue") toggleBlue++;
                    if (s.getType() == "red") toggleRed++;
                }
            }
            if (sack instanceof Sackboy) {
                text(sack.getName()+"\n", width/3, height/4);
                fill(255, 0, 0);
                text("Red: "+sackboyRed+"\n", width/3, height/4+30);
                noFill();
                fill(0,0,255);
                text("Blue: "+sackboyBlue+"\n", width/3, height/4+60);
                noFill();
                fill(0,255,0);
                text("Green: "+sackboyGreen+"\n", width/3, height/4+90);                
                noFill();
            } 
            if (sack instanceof Toggle) {
                fill(255);
                text(sack.getName()+"\n", width/3+300, height/4);
                noFill();
                fill(255,0,0);
                text("Red: "+toggleRed+"\n", width/3+300, height/4+30);
                noFill();
                fill(0,0,255);
                text("Blue: "+toggleBlue+"\n", width/3+300, height/4+60);
                noFill();
                fill(0,255,0);
                text("Green: "+toggleGreen+"\n", width/3+300, height/4+90); 
                noFill();
            }
        }
    } 
}

void iterateOrbiter() {
    int sackboyGreen = 0; 
    int sackboyBlue = 0; 
    int sackboyRed = 0;
    int toggleGreen = 0; 
    int toggleBlue = 0; 
    int toggleRed = 0;
    ArrayList<Sack> ship = orbiter.getPassengers();
    for (Sack sack : ship) {
        ArrayList<Specimen> specs = sack.mySpecimens();
        for (Specimen s : specs) {
            if (sack instanceof Sackboy) {
                if (s.getType() == "green") sackboyGreen++;
                if (s.getType() == "blue") sackboyBlue++;
                if (s.getType() == "red") sackboyRed++;
            } 
            else if (sack instanceof Toggle) {
                if (s.getType() == "green") toggleGreen++;
                if (s.getType() == "blue") toggleBlue++;
                if (s.getType() == "red") toggleRed++;
            }
        }
        textSize(24);
        if (sack instanceof Sackboy) {
            text(sack.getName()+"\n", width/3, height/4);
            fill(255, 0, 0);
            text("Red: "+sackboyRed+"\n", width/3, height/4+30);
            noFill();
            fill(0,0,255);
            text("Blue: "+sackboyBlue+"\n", width/3, height/4+60);
            noFill();
            fill(0,255,0);
            text("Green: "+sackboyGreen+"\n", width/3, height/4+90);                
            noFill();
        } 
        if (sack instanceof Toggle) {
            fill(255);
            text(sack.getName()+"\n", width/3+300, height/4);
            noFill();
            fill(255,0,0);
            text("Red: "+toggleRed+"\n", width/3+300, height/4+30);
            noFill();
            fill(0,0,255);
            text("Blue: "+toggleBlue+"\n", width/3+300, height/4+60);
            noFill();
            fill(0,255,0);
            text("Green: "+toggleGreen+"\n", width/3+300, height/4+90); 
            noFill();
        }
    }
}


// https://forum.processing.org/one/topic/how-to-perform-an-action-every-x-seconds-time-delays.html
void spawnAlien() {
    if (millis() > alienSpawnTime + alienFrequency) {
        objects.add(new Rock(width/2, 0, 25));
        alienSpawnTime = millis();
        alienCount++;
    }  
}

// spawns a random specimen
void spawnSpecimin() {
    float max = 10;
    float min = 0;
    float num = (random(min, max));
    if (millis() > specimenSpawnTime + 1000) {
        // green specimens are common
        if ((num >= 0) && (num <= 5)) { 
            objects.add(new Specimen(width/2, 0, 10, color(0, 255, 0), "green"));
        }
        // green specimens appear from time to time
        if ((num > 5) && (num <= 8)) {
            objects.add(new Specimen(width/2, 0, 10, color(0, 0, 255), "blue"));
        }
        // red specimens are rare
        if ((num > 8) && (num <= 10)) {
            objects.add(new Specimen(width/2, 0, 10, color(255, 0, 0), "red"));
        }
        specimenSpawnTime = millis();
    }
}

void displayStatistics() {
    textSize(35);
    text(millis(), 10, 50);
    fill(0, 255, 0);
    // rect(150, 75, hp*75, 25); // displays how much damage you can take
    displayHearts();
    noFill();
    fill(255);
    text("Life:", 10, 100);
    text("Alien count: "+alienCount, 10, 150);
    textSize(24);
    text("Messages: "+message, 10, 200);
    noFill();
    text("Specimen: ", 10, 240);
    displaySpec(currentSpec);
}

void displayHearts() {
    PImage heart = loadImage("heart.png");
    for (int i = 0, x = 0; i < hp; i++, x+=25) {
        image(heart, 125+x, 75, 25, 25);
    }    
}

void displaySpec(Specimen spec) {
    if (spec != null) {
        color c = spec.getColour();
        fill(c);
        rect(135, 220, 35, 35);
        noFill();
    }
}
