class MenuButton {
    int position;
    float translate_y; 
    String text; 
    color highlight;
    
    public MenuButton(int position, float translate_y, String text, color highlight) {
        this.position = position;
        this.translate_y = translate_y;
        this.text = text;
        this.highlight = highlight;
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
    private color highlight1; // highlights single player option
    private color highlight2; // highlights highscore option
    private color highlight3; // highlights settings option
    private color highlight4; // highlights back button
    private int startPosition;
    private int highscorePosition;
    private int settingsPosition;
    private boolean startGame = false;
    private boolean settingsClicked = false;
    private boolean displayMenu = true;
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
            sceneText(new MenuButton(highscorePosition, windowY/2+textsize+90, highscores, highlight2));
            sceneText(new MenuButton(settingsPosition, windowY/2+textsize+180, settings, highlight3));
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
        text(start, windowX/1.5, windowY/2+90);
        noFill();
    }
    
    private void sceneText(MenuButton button) {
        textSize(textsize);
        fill(button.highlight, 150);
        rect(windowX/2, button.position, windowX, textsize);
        noFill();     
        pushMatrix();
        //translate(windowX/1.5, windowY/2+textsize+90);
        translate(windowX/1.5, button.translate_y);
        fill(255, 255, 255, 150);      
        text(button.text, 0, 0);
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
        text("/main menu", 0-x/4, -y/1.5);
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
            if ( overRect(windowX/1.5, windowY+300-24, 168, 45) ) {
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
        rect(windowX/1.5, windowY+300-24, 168, 45);
        noFill();
        fill(255, 255, 255, 150);      
        text("Alien frequency: \nDEFAULT: 1 per 3000ms.", windowX/1.5, windowY/2+90);
        text("<< Back", windowX/1.5, windowY+300);
        text("Movement:\nUP = W\nLEFT = A\nDOWN = S\nRIGHT = D\nCommit Suicide: K", windowX/1.5, windowY/2+180);
        text("Game Instructions: \nObtain as many moon specimens as you can i.e. the red, green"+
            "\nand blue squares."+"\nYou play as two astronauts: sackboy and toggle."+ 
            "\nEach exit the space camp from the bottom"+ 
            "\nleft of the screen one at a time. The game ends when both"+ 
            "\nenter the ship or are killed by an alien.", 
            windowX/1.5, windowY/2+360);
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
