import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class stack2DTransformation_junosLKJ extends PApplet {

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

public void setup() {
    START_X = width/6;
    START_Y = height;
    // size(1024, 800);
    // frameRate(15);
    
    menu = new Menu(width, height);
    // frameRate(15);
    objects.add(new Tesla(1400, 0, 100));
    sackboy = new Sackboy(START_X, START_Y);
    toggle = new Toggle(START_X, START_Y);
    orbiter = new Orbiter(width-200, height-650);
    baseCamp = new BaseCamp(100, height-300);
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

public void draw() {
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
            if (orbiter.collisionDetected(sack)) {
                message = "You enter the orbiter";
                // println("You enter the orbiter");
                astronauts.remove(sack);
                if (sack instanceof Sackboy) {
                    astronauts.add(toggle);
                }
            } 
            if (baseCamp.collisionDetected(sack)) {
                sack.inBaseCamp(true);
                message = "You cannot be hurt in the base camp.";
                // println("You cannot be hurt in the base camp.");
            } else {
                sack.inBaseCamp(false);
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

public void keyPressed(Sack sack) {
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

public void gameOver() {
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

public void iterateGraveyard() {
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

public void iterateOrbiter() {
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
public void spawnAlien() {
    if (millis() > alienSpawnTime + alienFrequency) {
        objects.add(new Rock(width/2, 0, 25));
        alienSpawnTime = millis();
        alienCount++;
    }  
}

// spawns a random specimen
public void spawnSpecimin() {
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

public void displayStatistics() {
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

public void displayHearts() {
    PImage heart = loadImage("heart.png");
    for (int i = 0, x = 0; i < hp; i++, x+=25) {
        image(heart, 125+x, 75, 25, 25);
    }    
}

public void displaySpec(Specimen spec) {
    if (spec != null) {
        int c = spec.getColour();
        fill(c);
        rect(135, 220, 35, 35);
        noFill();
    }
}
public class BaseCamp implements Collision {

    private float x, y;
    private float baseWidth, baseHeight;
    private int colour;

    public BaseCamp (float x, float y) {
        this.x = x;
        this.y = y;
        this.baseWidth = 400;
        this.baseHeight = 300;
        this.colour = color(169, 229, 236);
    }

    public void display() {
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

    public boolean collisionDetected(Sack sack) {
        float sackWidth = sack.getBodyWidth();
        float sackHeight = sack.getBodyHeight();
        float sackPos_x = sack.getPositionX();
        float sackPos_y = sack.getPositionY();
        if (x + baseWidth >= sackPos_x &&
            x <= sackPos_x + sackWidth &&
            y + baseHeight >= sackPos_y &&
            y <= sackPos_y + sackHeight) {
                colour = color(74, 201, 78);
                return true;
        } else {
            colour = color(169, 229, 236);
            return false;
        }
    } 

}
public interface Collision {
    public boolean collisionDetected(Sack sack);
}

public class ExternalTank extends Orbiter {

    private float x, y;

    public ExternalTank(float x, float y) {
        this.x = x;
        this.y = y;
    }

    public void display() {
        rect(x, y, super.getWidth(), super.getHeight());
        pushMatrix();
        translate(x, y);
        triangle(0, 0, super.getWidth()/2, -100, super.getWidth(), 0);
        popMatrix();
    }

}
public class Ground {
  float x1, y1, x2, y2;  
  float x, y, len, rot;

  // Constructor
  public Ground(float x1, float y1, float x2, float y2) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    x = (x1+x2)/2;
    y = (y1+y2)/2;
    len = dist(x1, y1, x2, y2);
    rot = atan2((y2-y1), (x2-x1));
  }
}
// https://processing.org/examples/scrollbar.html
public class HScrollbar {
  private int swidth, sheight;    // width and height of bar
  private float xpos, ypos;       // x and y position of bar
  private float spos, newspos;    // x position of slider
  private float sposMin, sposMax; // max and min values of slider
  private int loose;              // how loose/heavy
  private boolean over;           // is the mouse over the slider?
  private boolean locked;
  private float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  public void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  public float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  public boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  public void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  public float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }

}
public class JetPack {

    private float x, y;
    private float packWidth, packHeight;

    public JetPack (float x, float y, float packWidth, float packHeight) {
        this.x = x;
        this.y = y;
        this.packWidth = packWidth;
        this.packHeight = packHeight;
    }

    public void display() {
        fill(100);
        rect(x, y, packWidth, packHeight);
        drawTopOfTank(x, y);
        fill(100);
        rect(x+packWidth, y, packWidth, packHeight);
        drawTopOfTank(x+packWidth, y);
        pushMatrix();
        translate(x, y);
        rect(packWidth/3, packHeight, 10, 10);
        popMatrix();
        pushMatrix();
        translate(x+packWidth, y);
        rect(packWidth/3, packHeight, 10, 10);
        popMatrix();
        turnOn();
        noFill();
    }

    private void drawTopOfTank(float x1, float y1) {
        fill(232, 15, 15);
        pushMatrix();
        translate(x1, y1);
        rotate(radians(180));
        arc(-packWidth/2, 0, packWidth, 30, 0, PI);
        popMatrix();
        noFill();
    }

    public void turnOn() {
        PImage jetFlame = loadImage("jetFlame.png");
        pushMatrix();
        translate(x, y);
        translate(packWidth/3, packHeight);
        image(jetFlame, -3, 8, 15, 130);
        popMatrix();
        pushMatrix();
        translate(x+packWidth, y);
        translate(packWidth/3, packHeight);
        image(jetFlame, -3, 8, 15, 130);
        popMatrix();
    }

}
public class Menu {

    private String start = "single player";
    private String highscores = "highscores";
    private String settings = "settings";
    private int x, y; // menu coordinates
    private int windowX, windowY;
    private int textsize = 75;
    private boolean singlePlayerOver = false;
    private boolean settingsOver = false;
    private boolean highscoresOver = false;
    private boolean backOver = false;
    private int highlight1; // highlights single player option
    private int highlight2; // highlights highscore option
    private int highlight3; // highlights settings option
    private int highlight4; // highlights back button
    private int startPosition;
    private int highscorePosition;
    private int settingsPosition;
    private boolean startGame = false;
    private boolean settingsClicked = false;
    private boolean displayMenu = true;
    private boolean backClicked = false;
    private HScrollbar hs1;
    private int time = 3000;
    

    // x and y should be the width and height of the screen
    public Menu (int x, int y) {
        this.x = x; 
        this.y = y;
        windowX = x/2;
        windowY = y/2;
        startPosition = windowY/2+30;
        highscorePosition = windowY/2+textsize+30;
        settingsPosition = windowY/2+textsize+120;
        hs1 = new HScrollbar(windowX-15, windowY/2+90, windowX/2, 16, 16);
    }
    
    public void display() {
        update(mouseX, mouseY);
        if (singlePlayerOver) {
            highlight1 = color(60, 173, 229);
            if (mousePressed) {
                startGame = true;
            }
        } 
        else if (highscoresOver) {
            highlight2 = color(60, 173, 229);
            if (mousePressed) {
                println("highscore");
            }
        } 
        else if (settingsOver) {
            highlight3 = color(60, 173, 229);
            if (mousePressed) {
                displayMenu = false;
                settingsClicked = true;
            }
        } 
        else if (backOver) {
            highlight4 = color(60, 173, 229);
            if (mousePressed) {
                backOver = false;
                settingsClicked = false;
                displayMenu = true;
            }
        } else {
            highlight1 = color(16, 92, 129);
            highlight2 = color(16, 92, 129);
            highlight3 = color(16, 92, 129);
            highlight4 = color(16, 92, 129);            
        } 
        displayWindow();
        if (displayMenu) {
            displayStart();
            highscoreText();
            settingsText();
        }
        if (settingsClicked) {
            displaySettings();
        }
        rectMode(CORNER);
    }   

    private void displayStart() {
        textSize(textsize);
        fill(highlight1, 150);
        rect(windowX/2, startPosition, windowX, textsize);
        noFill();     
        fill(255, 255, 255, 150);      
        text(start, windowX/1.5f, windowY/2+90);
        noFill();
    }

    private void highscoreText() {
        textSize(textsize);
        fill(highlight2, 150);
        // rectMode(CENTER);
        rect(windowX/2, highscorePosition, windowX, textsize);
        noFill();     
        pushMatrix();
        translate(windowX/1.5f, windowY/2+textsize+90);
        fill(255, 255, 255, 150);      
        text(highscores, 0, 0);
        popMatrix();
        noFill();
    }

    private void settingsText() {
        textSize(textsize);
        fill(highlight3, 150);
        // rectMode(CENTER);
        rect(windowX/2, settingsPosition, windowX, textsize);
        noFill();    
        fill(255, 255, 255, 150);      
        pushMatrix();
        translate(windowX/1.5f, windowY/2+textsize+180);
        text(settings, 0, 0);
        popMatrix();
        noFill();
    }

    private void displayWindow() {
        rectMode(CENTER);
        fill(47, 148, 198, 40);
        rect(windowX, windowY, windowX, y-150);
        noFill();
        fill(255, 255, 255, 150);
        pushMatrix();
        translate(windowX, y-150);
        textSize(textsize);
        text("/main menu", 0-x/4, -y/1.5f);
        popMatrix();
        noFill();
        rectMode(CORNER);
    }

    private void update(int x, int y) {
            // over single player option
        if (displayMenu) {
            if ( overRect(windowX/2, windowY/2+15, windowX, textsize) ) {
                singlePlayerOver = true;
                highscoresOver = false;
                settingsOver = false;
            } 
                // over highscores option
            else if ( overRect(windowX/2,  windowY/2+textsize+30, windowX, textsize) ) {
                singlePlayerOver = false;
                highscoresOver = true;
                settingsOver = false;
            }
                // over settings option
            else if ( overRect(windowX/2, windowY/2+textsize+120, windowX, textsize) ) {
                singlePlayerOver = false;
                highscoresOver = false;
                settingsOver = true;
            } else {
                highscoresOver = settingsOver = singlePlayerOver = false;
            }
        } 
        if (settingsClicked) {
            if ( overRect(windowX/1.5f, windowY+300-24, 168, 45) ) {
                backOver = true;
                displayMenu = true;
                settingsClicked = false;
            } else {
                backOver = false;
            }
        }
    }

    private boolean overRect(float x1, float y1, int w, int h) {
        if (mouseX >= x1 && mouseX <= x1+w && 
            mouseY >= y1 && mouseY <= y1+h) {
            return true;
        } else {
            return false;
        }
    }   

    public boolean startGame() {
        return startGame;
    }

    public void displaySettings() {
        textSize(24);
        fill(highlight4, 150);
        rect(windowX/1.5f, windowY+300-24, 168, 45);
        noFill();
        fill(255, 255, 255, 150);      
        text("Alien frequency: \nDEFAULT: 1 per 3000ms.", windowX/1.5f, windowY/2+90);
        text("<< Back", windowX/1.5f, windowY+300);
        text("Movement:\nUP = W\nLEFT = A\nDOWN = S\nRIGHT = D\nCommit Suicide: K", windowX/1.5f, windowY/2+180);
        text("Game Instructions: \nObtain as many moon specimens as you can i.e. the red, green"+
            "\nand blue squares."+"\nYou play as two astronauts: sackboy and toggle."+ 
            "\nEach exit the space camp from the bottom"+ 
            "\nleft of the screen one at a time. The game ends when both"+ 
            "\nenter the ship or are killed by an alien.", 
            windowX/1.5f, windowY/2+360);
        int time = (int)hs1.getPos()-500;
        time *= 5;
        text(time+"ms", windowX-15, windowY/2+50);
        setAlienFrequency(time);
        hs1.update();
        hs1.display();
        noFill();
    }
    

    public void setAlienFrequency(int time) {
        this.time = time;
    }

    public int getAlienFrequency() {
        return time;
    }
}
public abstract class MovingObject {
    
    // MovingObject has position and velocity
    PVector position;
    PVector velocity;
    PVector gravity = new PVector(0,0.05f);
    float r, m;
    // A damping of n% slows it down when it hits the ground
    float damping;

    public void move() {
        velocity.add(gravity);
        position.add(velocity);
    }

    public abstract void display();

    public void moveX(float x) {
        velocity.add(x, 0.05f);
        position.add(velocity);
        // position.x += x;
    }

    public void moveY(float y) {
        velocity.add(0.05f, y);
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
        m = r*0.1f;
    }

    public float getR() {
        return r;
    }

    public void setDamping(float n) {
        damping = n;
    }

    // Check boundaries of window
    public void checkWallCollision() {
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
            float distanceCorrection = (minDistance-distanceVectMag)/2.0f;
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

    public void checkGroundCollision(Ground groundSegment) {
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
            velocityYTemp *= -1.0f;
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
/* 
*   Collision Detection for a stationary object
*   http://www.jeffreythompson.org/collision-detection/rect-rect.php 
*   
*/
public class Orbiter implements Collision {

    private float orbiterWidth = 100;
    private float orbiterHeight = 600;
    private float x; // position
    private float y; // position
    private ArrayList<Sack> passengers = new ArrayList<Sack>();
    private OrbiterBody body;
    private OrbiterLeftBooster leftBooster;
    private OrbiterRightBooster rightBooster;
    private OrbiterLeftWing leftWing;
    private OrbiterRightWing rightWing;
    private ExternalTank tank;

    public Orbiter() {
        
    }

    public Orbiter (float x, float y) {
        this.x = x;
        this.y = y;
        body = new OrbiterBody(x, y);
        leftBooster = new OrbiterLeftBooster(x, y);
        rightBooster = new OrbiterRightBooster(x, y);
        leftWing = new OrbiterLeftWing(x, y);
        rightWing = new OrbiterRightWing(x, y);
        tank = new ExternalTank(x, y);
    }

    // if Sack collides with orbiter, 
    // add Sack to passengers ArrayList and return true
    public boolean collisionDetected(Sack sack) {
        float sackWidth = sack.getBodyWidth();
        float sackHeight = sack.getBodyHeight();
        float sackPos_x = sack.getPositionX();
        float sackPos_y = sack.getPositionY();
        if (x + orbiterWidth >= sackPos_x &&
            x <= sackPos_x + sackWidth &&
            y + orbiterHeight >= sackPos_y &&
            y <= sackPos_y + sackHeight) {
                passengers.add(sack);
                return true;
        }
        return false;
    } 
    
    public ArrayList<Sack> getPassengers() {
        return passengers;
    }

    public void display() {
        int booster = color(166, 90, 13);
        fill(booster);
        tank.display();
        leftBooster.display();
        rightBooster.display();
        // displayExternalTank();
        // displayLeftBooster();
        // displayRightBooster();
        fill(245);
        body.display();
        // displayOrbiterBody();
        fill(100);
        leftWing.display();
        rightWing.display();
        // displayLeftWing();
        // displayRightWing();
    }

    public void displayOrbiterBody() {
        int c = color(193, 193, 193);
        fill(c);
        rect(x, y, 25, orbiterHeight+75);
        rect(x+25, y, 25, orbiterHeight+75);
        rect(x+50, y, 25, orbiterHeight+75);
        rect(x+75, y, 25, orbiterHeight+75);
        rect(x, y, orbiterWidth, orbiterHeight); // cockpit
        pushMatrix();
        int c2 = color(25, 29, 85);
        translate(x, y);
        rotate(radians(180));
        fill(c2);
        arc(-orbiterWidth/2, 0, orbiterWidth, 100, 0, PI);
        popMatrix();
    } 

    public void displayLeftWing() {
        triangle(x-200, y+orbiterHeight, x, orbiterHeight+30, x, y+orbiterHeight);
        PImage nasa = loadImage("nasa.png");
        pushMatrix();
        translate(x-200, y+orbiterHeight);
        image(nasa, 75, -100, 75, 75);
        popMatrix();
    }

    public void displayRightWing() {
        triangle(x+orbiterWidth, y+orbiterHeight, x+orbiterWidth, orbiterHeight+30, orbiterWidth+x+200, y+orbiterHeight);
        PImage flag = loadImage("flag.png");
        pushMatrix();
        translate(x+orbiterWidth, y+orbiterHeight);
        image(flag, 10, -75, 75, 50);
        popMatrix();
    }

    public void displayLeftBooster() {
        rect(x-orbiterWidth/4, y, orbiterWidth/4, orbiterHeight+25);
        pushMatrix();
        translate(x-orbiterWidth/4, y);
        triangle(0, 0, orbiterWidth/6, -50, orbiterWidth/4, 0);
        popMatrix();
    }
    public void displayRightBooster() {
        rect(x+orbiterWidth, y, orbiterWidth/4, orbiterHeight+25);
        pushMatrix();
        translate(x+orbiterWidth, y);
        triangle(0, 0, orbiterWidth/6, -50, orbiterWidth/4, 0);
        popMatrix();
    }

    public void displayExternalTank() {
        rect(x, y, orbiterWidth, orbiterHeight);
        pushMatrix();
        translate(x, y);
        triangle(0, 0, orbiterWidth/2, -100, orbiterWidth, 0);
        popMatrix();
    }

    public int getPassengersSize() {
        return passengers.size();
    }

    public float getX() {
        return x;
    }

    public float getY() {
        return y;
    }

    public float getWidth() {
        return orbiterWidth;
    }

    public float getHeight() {
        return orbiterHeight;
    }
       
}
public class OrbiterBody extends Orbiter {

    private float x, y;

    public OrbiterBody(float x, float y) {
        this.x = x; 
        this.y = y;
    }
    
    public void display() {
        int c = color(193, 193, 193);
        fill(c);
        rect(x, y, 25, super.getHeight()+75);
        rect(x+25, y, 25, super.getHeight()+75);
        rect(x+50, y, 25, super.getHeight()+75);
        rect(x+75, y, 25, super.getHeight()+75);
        rect(x, y, super.getWidth(), super.getHeight()); // cockpit
        pushMatrix();
        int c2 = color(25, 29, 85);
        translate(x, y);
        rotate(radians(180));
        fill(c2);
        arc(-super.getWidth()/2, 0, super.getWidth(), 100, 0, PI);
        popMatrix();
    } 

}
public class OrbiterLeftBooster extends Orbiter {

    private float x, y;

    public OrbiterLeftBooster(float x, float y) {
        this.x = x;
        this.y = y;
    }

    public void display() {
        rect(x-super.getWidth()/4, y, super.getWidth()/4, super.getHeight()+25);
        pushMatrix();
        translate(x-super.getWidth()/4, y);
        triangle(0, 0, super.getWidth()/6, -50, super.getWidth()/4, 0);
        popMatrix();
    }

}
public class OrbiterLeftWing extends Orbiter {

    private float x, y;

    public OrbiterLeftWing(float x, float y) {
        this.x = x;
        this.y = y;
    }

    public void display() {
        triangle(x-200, y+super.getHeight(), x, super.getHeight()+30, 
            x, y+super.getHeight());
        PImage nasa = loadImage("nasa.png");
        pushMatrix();
        translate(x-200, y+super.getHeight());
        image(nasa, 75, -100, 75, 75);
        popMatrix();
    }

}
public class OrbiterRightBooster extends Orbiter {

    private float x, y;

    public OrbiterRightBooster(float x, float y) {
        this.x = x;
        this.y = y;
    }

    public void display() {
        rect(x+super.getWidth(), y, super.getWidth()/4, super.getHeight()+25);
        pushMatrix();
        translate(x+super.getWidth(), y);
        triangle(0, 0, super.getWidth()/6, -50, super.getWidth()/4, 0);
        popMatrix();
    }

}
public class OrbiterRightWing extends Orbiter {

    private float x, y;

    public OrbiterRightWing(float x, float y) {
        this.x = x;
        this.y = y;
    }

    public void display() {
        triangle(x+super.getWidth(), y+super.getHeight(), 
            x+super.getWidth(), super.getHeight()+30, super.getWidth()+x+200, 
            y+super.getHeight());
        PImage flag = loadImage("flag.png");
        pushMatrix();
        translate(x+super.getWidth(), y+super.getHeight());
        image(flag, 10, -75, 75, 50);
        popMatrix();
    }

}
public class Rock extends MovingObject {

  public Rock(float x, float y, float r) {
    PVector p = new PVector(x, y);
    PVector v = new PVector(.5f, 0);
    super.setPosition(new PVector(x, y));
    super.setVelocity(new PVector(.5f, 0));
    super.setR(r);
    super.setDamping(1);
  }

  public void move() {
    super.move();
  }

  public void display() {
    // Draw Rock
    fill(100);
    PImage alien = loadImage("alien2.png");
    image(alien, super.getPositionX(), super.getPositionY(), super.getR()*2, super.getR()*2);
    // ellipse(super.getPositionX(), super.getPositionY(), super.getR()*2, super.getR()*2);
  }
  
  // Check boundaries of window
  public void checkWallCollision() {
    super.checkWallCollision();
  }

  public void checkGroundCollision(Ground groundSegment) {
      super.checkGroundCollision(groundSegment);
  }      
}
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
        super.setVelocity(new PVector(0.5f, 0));
        super.setR(bodyHeight/2+legLength/2);
        super.setDamping(0.2f);
        isAlive = true;
        this.jetPack = jetPack;
        this.healthPoints = 3;
    }

    public void display() {
        pushMatrix();
        translate(position.x, position.y);
        scale(0.5f);
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

    public abstract void drawBody();
    public abstract void drawHead();
    public abstract void drawRightArm();
    public abstract void drawLeftArm();
    public abstract void drawLeftLeg();
    public abstract void drawRightLeg();
    public abstract String getName();

    public void collectSpecimen(Specimen s) {
        specimens.add(s);
    } 
    
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
public class SackBody extends Sackboy {

    private float bodyHeight;

    public SackBody(float bodyHeight) {
        this.bodyHeight = bodyHeight;
    }

    public void display() {
        fill(255, 255, 0);
        beginShape();
        curveVertex(55, bodyHeight);
        curveVertex(55, 78); // arm socket
        curveVertex(32, 78);
        curveVertex(30, bodyHeight);
        curveVertex(60, bodyHeight);
        curveVertex(55, 78);
        curveVertex(40, bodyHeight);
        endShape();
    }

}
public class SackHead extends Sackboy {

    public void display() {
        fill(255, 255, 0);
        beginShape();
        curveVertex(84, 70);
        curveVertex(70, 70);
        curveVertex(84, 60);
        curveVertex(70, 20);
        curveVertex(10, 20);
        curveVertex(6, 70);
        curveVertex(70, 70);
        curveVertex(21, 75);
        endShape();
        fill(0, 0, 0);
        ellipse(60, 35, 10, 10); // right eye
        ellipse(20, 35, 10, 10); // left eye
    }

}
public class SackLeftArm extends Sackboy {

    private float armLength;

    public SackLeftArm(float armLength) {
        this.armLength = armLength;
    }

    public void display() {
        fill(255, 255, 0);
        pushMatrix();
        translate(30, 90);
        rotate(radians(super.getLeftArmAngle()*60));
        beginShape();
        curveVertex(-10, 0);
        curveVertex(0, armLength); // shoulder
        curveVertex(-10, armLength); // shoulder
        curveVertex(-10, 0); // forearm
        curveVertex(0, 0); // forearm 
        curveVertex(0, armLength); // forearm
        curveVertex(-10, 0);
        endShape();
        popMatrix();
        noFill();
    }

}
public class SackLeftLeg extends Sackboy {

    private float legLength;

    public SackLeftLeg(float legLength) {
        this.legLength = legLength;
    } 

    public void display() {
        fill(255, 255, 0);        
        pushMatrix();
        translate(33, 125);
        // rotate(radians(-leftArmAngle*55));
        beginShape();
        curveVertex(-10, 0);
        curveVertex(0, legLength); // shoulder
        curveVertex(-20, legLength); // shoulder
        curveVertex(-10, 0); // forearm
        curveVertex(0, 0); // forearm 
        curveVertex(0, legLength); // forearm
        curveVertex(-10, 0);
        endShape();
        popMatrix();
        noFill();
    }

}
public class SackRightArm extends Sackboy {
    
    private float armLength;

    public SackRightArm(float armLength) {
        this.armLength = armLength;
    }

    public void display() {
        fill(255, 255, 0);
        pushMatrix();
        translate(59, 90);
        rotate(radians(super.getRightArmAngle()*60));
        beginShape();
        curveVertex(0, 0);
        curveVertex(10, armLength); // shoulder
        curveVertex(0, armLength); // shoulder
        curveVertex(0, 0); // forearm
        curveVertex(10, 0); // forearm 
        curveVertex(10, armLength); // forearm
        curveVertex(0, 0);
        endShape();
        popMatrix();
        noFill();
    }

}
public class SackRightLeg extends Sackboy {

    private float legLength;

    public SackRightLeg(float legLength) {
        this.legLength = legLength;
    }

    public void display() {
        fill(255, 255, 0);        
        pushMatrix();
        translate(54, 125);
        // rotate(radians(-rightArmAngle*45));
        beginShape();
        curveVertex(0, 0);
        curveVertex(20, legLength); // shoulder
        curveVertex(0, legLength); // shoulder
        curveVertex(0, 0); // forearm
        curveVertex(10, 0); // forearm 
        curveVertex(20, legLength); // forearm
        curveVertex(0, 0);
        endShape();
        popMatrix();
        noFill();
    }

}

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
public class Specimen extends MovingObject {

    private int colour; // denotes specimen
    private String type;

    public Specimen (float x, float y, float r, int colour, String type) {
        PVector p = new PVector(x, y);
        PVector v = new PVector(.5f, 0);
        super.setPosition(new PVector(x, y));
        super.setVelocity(new PVector(.5f, 0));
        super.setR(r);
        super.setDamping(0.8f);
        this.colour = colour;
        this.type = type;
    }


    public int getColour() {
        return colour;
    }

    public String getType() {
        return type;
    }
    
    public void move() {
        super.move();
    }

    public void display() {
        // Draw Rock
        fill(colour);
        rect(super.getPositionX(), super.getPositionY(), super.getR()*2, super.getR()*2);
    }

    // Check boundaries of window
    public void checkWallCollision() {
        super.checkWallCollision();
    }

    public void checkGroundCollision(Ground groundSegment) {
        super.checkGroundCollision(groundSegment);
  }   

}
public class Tesla extends MovingObject {

    public Tesla (float x, float y, float r) {
        PVector p = new PVector(x, y);
        PVector v = new PVector(.5f, 0);
        super.setPosition(new PVector(x, y));
        super.setVelocity(new PVector(.5f, 0));
        super.setR(r);
        super.setDamping(0.8f);
    }

    public void move() {
        super.move();
    }

    public void display() {
        // Draw Rock
        fill(100);
        PImage tesla = loadImage("tesla.png");
        image(tesla, super.getPositionX(), super.getPositionY(), super.getR()*2, super.getR()*2);
    }
    
    // Check boundaries of window
    public void checkWallCollision() {
        super.checkWallCollision();
    }

    public void checkGroundCollision(Ground groundSegment) {
        super.checkGroundCollision(groundSegment);
    }

}
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
public class ToggleBody extends Toggle {

    private float bodyHeight;

    public ToggleBody(float bodyHeight) {
        this.bodyHeight = bodyHeight;
    }

    public void display() {
        fill(255, 255, 0);
        beginShape();
        curveVertex(75, bodyHeight);
        curveVertex(75, 78); // arm socket
        curveVertex(15, 78);
        curveVertex(10, bodyHeight);
        curveVertex(100, bodyHeight);
        curveVertex(75, 78);
        curveVertex(40, bodyHeight);
        endShape();
        super.setBodyWidth(90);
        noFill();
    }

}
public class ToggleHead extends Toggle {

    public void display() {
        fill(0);
        ellipse(60, 100, 10, 10); // right eye
        ellipse(35, 100, 10, 10); // left eye
        noFill();
    }

}
public class ToggleLeftArm extends Toggle {

    private float armLength;

    public ToggleLeftArm(float armLength) {
        this.armLength = armLength;
    }

    public void display() {
        fill(255, 255, 0);
        pushMatrix();
        translate(5, 140);
        rotate(radians(super.getLeftArmAngle()*60));
        fill(255);
        beginShape();
        curveVertex(-10, 0);
        curveVertex(0, armLength); // shoulder
        curveVertex(-20, armLength); // shoulder
        curveVertex(-10, 0); // forearm
        curveVertex(0, 0); // forearm 
        curveVertex(0, armLength); // forearm
        curveVertex(-10, 0);
        endShape();
        popMatrix();
        noFill();
    }

}
public class ToggleLeftLeg extends Toggle {

    private float legLength;
    private float bodyHeight;

    public ToggleLeftLeg(float legLength, float bodyHeight) {
        this.legLength = legLength;
        this.bodyHeight = bodyHeight;
    }

    public void display() {
        fill(255, 255, 0);
        pushMatrix();
        translate(33, bodyHeight+8);
        // rotate(radians(super.getLeftArmAngle()*55));
        fill(255);
        beginShape();
        curveVertex(-15, 0);
        curveVertex(0, legLength); // shoulder
        curveVertex(-15, legLength); // shoulder
        curveVertex(-15, 0); // forearm
        curveVertex(0, 0); // forearm 
        curveVertex(0, legLength); // forearm
        curveVertex(-15, 0);
        endShape();
        popMatrix();
        noFill();
    }

}
public class ToggleRightArm extends Toggle {

    private float armLength;

    public ToggleRightArm(float armLength) {
        this.armLength = armLength;
    }

    public void display() {
        fill(255, 255, 0);
        pushMatrix();
        translate(96, 140);
        rotate(radians(super.getRightArmAngle()*60));
        fill(255);
        beginShape();
        curveVertex(0, 0);
        curveVertex(20, armLength); // shoulder
        curveVertex(0, armLength); // shoulder
        curveVertex(0, 0); // forearm
        curveVertex(10, 0); // forearm 
        curveVertex(20, armLength); // forearm
        curveVertex(0, 0);
        endShape();
        popMatrix();
    }

}
public class ToggleRightLeg extends Toggle {

    private float legLength;
    private float bodyHeight;

    public ToggleRightLeg(float legLength, float bodyHeight) {
        this.legLength = legLength;
        this.bodyHeight = bodyHeight;
    }

    public void display() {
        fill(255, 255, 0);
        pushMatrix();
        translate(80, bodyHeight+8);
        // rotate(radians(super.getRightArmAngle()*45));
        fill(255);
        beginShape();
        curveVertex(0, 0);
        curveVertex(15, legLength); // shoulder
        curveVertex(0, legLength); // shoulder
        curveVertex(0, 0); // forearm
        curveVertex(15, 0); // forearm 
        curveVertex(15, legLength); // forearm
        curveVertex(0, 0);
        endShape();
        popMatrix();
        noFill();
    }

}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "stack2DTransformation_junosLKJ" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}