import processing.sound.*;
SoundFile musicSnd, HitEn, lostSnd, fastSnd, itemSnd, Swing, Scream;
PImage img, game, arrow, enemy1, enemy2, enemy3, heroo, LSD, Food;
PFont ard;
int score = 0;
int highscore=0;
int START = 1, STARTONE = 2, GAME = 3, GAMEOVER = 4, PAUSE = 5;
int gameState = START;
boolean pause = false;//normal state
boolean mute = false;//normal state

//Values Opponents
float Gegner1X=1000;
float Gegner1Y=300;
float Gegner1VX=-200;
float Gegner1VY=300;
float Gegner1W=20;
float Gegner1H=40;
float Gegner2X=1000;
float Gegner2Y=300;
float Gegner2VX=-200;
float Gegner2VY=300;
float Gegner2W=20;
float Gegner2H=40;
float Gegner3X=1000;
float Gegner3Y=300;
float Gegner3W=20;
float Gegner3H=40;
float Gegner3VX;
float Gegner3VY;

int frameCount;

//Values Hero
float HeldX=500;
float HeldY=300;
float HeldH=70;
float HeldW=70;
float HeldVX=0;
float HeldVY=0;
float HeldSpeedY=250;
float HeldSpeedX=250;
float HeroRange=1.24;  //how far can hero reach to kill
float EnemyRange=0.80; // how far an enemy can reach to kill 

// Values Items 1
float Item1X=200;
float Item1Y=400;
float Item1H=20;
float Item1W=20;

// Values Items 2
float Item2X=500;
float Item2Y=100;
float Item2H=20;
float Item2W=20;

int timer = 1500;

//game over messages
String death[] = {"He could save others from death.\nBut not himself.", 
  "Just A Flesh Wound?", 
  "Noooooooooooooooooo!", 
  "*insert sad emoji*", 
  "Flown too close to the Death Star", 
  "Unfortunately,\nwe don't have Baby Mode"
};
int randDeath;
int enemyOneState;

void setup() {
  size( 900, 600 );
  println("A Game made for 'IfG' by Abdoulaye Diene, Vanessa Dirks, Alina Fischer and Damjan Pjevic");//Made by message in Console
  smooth();

  //LOAD IMAGES
  img = loadImage("PixelBack.jpg");           //Startbackground
  game = loadImage("hoth.png");              //actual gamebackground
  enemy1 = loadImage("enemy1.png");           //Opponent1
  enemy2 = loadImage("enemy2.png");           //Oppenent2
  enemy3 = loadImage("enemy3.png");           //Opponent3
  heroo = loadImage("luke.png");              // hero
  LSD = loadImage("MF.png");                  //LSD Item
  Food = loadImage("R2.png");                //Food Item

  //LOAD FONT
  ard = loadFont("ARDESTINE.vlw");                 //Font vor erverything

  //LOAD SOUNDS
  HitEn = new SoundFile(this, "2 clash 5.mp3");    //Hit enemy
  HitEn.amp(0.2);                                  //Volume for this Sound
  fastSnd = new SoundFile(this, "ItemFast.mp3");   //Pick up Fast Item
  itemSnd =new SoundFile(this, "r2d2.mp3");        //Pick up Point Item
  lostSnd = new SoundFile(this, "lost.wav");       //GameOver
  lostSnd.amp(0.4);                                //Volume
  Swing = new SoundFile(this, "Swing03.wav");      //Mouseclick swing
  Scream = new SoundFile(this, "Scream.mp3");      //Scream if Hero dies
  musicSnd = new SoundFile(this, "Killers2.mp3");   //Background
  musicSnd.amp(0.5);
  musicSnd.loop();

  //make opponent 1 appear randomly from right side of screen
  Gegner1X=1000;
  Gegner1Y= random(30, height-30);

  // make opponent 2 appear randomly from right side of screen
  Gegner2X=1000;
  Gegner2Y= random(30, height-30);
  Gegner2VX= random (-200, -400);
  Gegner2VY= random (-200, -400);

  //make opponent 3 appear randomly from right side of screen
  Gegner3X=1000;
  Gegner3Y=random(30, height-30);
}

void keyPressed() {
  //Switch to the different screens
  if (key == ENTER) {
    if (gameState == START) {
      gameState = STARTONE;
    } else if (gameState == STARTONE) {
      gameState = GAME;
    } else if (gameState==GAMEOVER) {
      gameState = START;
      lostSnd.stop(); //lost sound stops
      musicSnd.loop();//background music starts again
    }
  }

  // Jedi movement with arrows and wsad
  if (keyCode==UP || key=='w'|| key=='W') {
    HeldVY = -HeldSpeedY;
  } else if (keyCode==DOWN || key=='s'|| key=='S') {
    HeldVY = +HeldSpeedY;
  } else if (keyCode==LEFT || key=='a'|| key=='A') {
    HeldVX= -HeldSpeedX;
    heroo = loadImage("lukeL.png");// hero
  } else if (keyCode==RIGHT || key=='d'|| key=='D') {
    HeldVX= +HeldSpeedX;
    heroo = loadImage("luke.png");// hero
  }

  //Pause Game
  if (key == ' ' || key == ' ') {
    if (gameState==GAME) {
      pause = true;
      gameState = PAUSE;
    } else if (gameState == PAUSE) {
      pause = false;
      gameState = GAME;
    }
  }

  //Mute Sound
  if (key == 'm' || key == 'M') {
    if (mute) {
      musicSnd.amp(0.5);
      HitEn.amp(0.2);
      lostSnd.amp(0.4);
      fastSnd.amp(1.0);
      itemSnd.amp(1.0);
      Swing.amp(1.0);
      Scream.amp(1.0);
      mute = false;
    } else {
      musicSnd.amp(0.0);
      HitEn.amp(0.0);
      lostSnd.amp(0.0);
      fastSnd.amp(0.0);
      itemSnd.amp(0.0);
      Swing.amp(0.0);
      Scream.amp(0.0);
      mute = true;
    }
  }
}

//Jedi Movement 2 with arrows and wsad
void keyReleased() {
  if (keyCode==UP || key=='w'|| key=='W') {
    HeldVY = 0;
  } else if (keyCode==DOWN || key=='s'|| key=='S') {
    HeldVY = 0;
  } else if (keyCode==LEFT || key== 'a'|| key=='A') {
    HeldVX=0;
  } else if (keyCode==RIGHT || key=='d'|| key=='D') {
    HeldVX=0;
  }
}

//Lightsaber sound when mouse clicked
void mouseClicked() {    
  if (gameState==GAME) {
    Swing.amp(1.0);
    Swing.play();
  }
}

float ENTERtextSize=40;
int changeDir=0;

//Startscreen
void draw() {
  clear();
  if (gameState==START) {
    background(0);
    image(img, 0, 0);    
    textFont(ard);
    textSize(80);
    fill(#feda4a);    
    textAlign(CENTER, TOP);
    text("The super mega\n adventure of some\n random Jedi", 450, 75);
    textSize(ENTERtextSize);
    text("Press ENTER to start", 450, 450);

    //Moving for Press ENTER to start
    if (ENTERtextSize<=33) changeDir=1;
    if ( ENTERtextSize>=43)changeDir=0;
    if (changeDir==0) ENTERtextSize-=0.15;
    else ENTERtextSize+=0.15;

    randDeath = (int)random(death.length);  //pick death message
  }

  //Manual-screen
  if (gameState==STARTONE) {
    background(0);
    textFont(ard);
    textSize(50);
    fill(#feda4a);    
    textAlign(CORNER);
    text("Do or do not - there is no try.", 110, 80);//Header

    //Instructions
    textSize(25);
    textAlign(LEFT, BOTTOM);
    text("WASD to Move", 60, 486);
    text("'M' to Mute", 60, 518);
    text("Spacebar to Pause", 60, 550);
    textSize(52);
    textAlign(RIGHT, BOTTOM);
    text("ENTER\nto start", 840, 550);
    textSize(27);
    textAlign(CENTER, BOTTOM);
    text("Highscore: " + highscore, 444, 550);
    textSize(30);
    textAlign(LEFT, CENTER);
    fill(210, 0, 0);
    image(enemy1, 60, 130, 70, 70);//Opponent 1
    text("Allergic to right click - 1 Point", 170, 165);
    image (enemy2, 60, 220, 70, 70);//Opponent 2
    text("Allergic to left click - 3 Points", 170, 255);
    image (enemy3, 60, 310, 70, 70);//Opponent 3
    text("Run!", 170, 345);
    fill (255);
    image(Food, 700, 115, 70, 70);    //Item that gives Player points
    fill(#feda4a);
    text("Food", 780, 164);  
    fill (150, 200, 0);
    image(LSD, 700, 185, 75, 75); //Item to make Hero faster
    fill(#feda4a);
    text("LSD", 780, 224);
    fill(210, 0, 0);
    text("There is only one life", 305, 450);
  }

  //GameOver Screen
  if (gameState==GAMEOVER) {
    textSize(40);
    fill(210, 0, 0);
    textAlign(CENTER, CENTER);
    text(death[randDeath], width/2, height/2);  //print death message

    if (score>highscore) highscore=score;    //check highscore
    score=0;

    //reset all positions
    Gegner1X=1000;
    Gegner1Y=300;
    Gegner2X=1000;
    Gegner2Y=300;
    Gegner3X=1000;
    Gegner3Y=300;
    HeldX=500;
    HeldY=300;
    HeldSpeedX=250;
    HeldSpeedY=250;
    Item1X=200;
    Item1Y=400;
  }

  //Pause Screen
  if (gameState==PAUSE) {
    pause = true; //pause game
    textAlign(CENTER, CENTER);
    textSize(40);
    fill(#feda4a);
    text("PAUSE", width/2, height/2); //text for pause screen
  }

  //InGame
  if (gameState==GAME) { 
    background(0);
    image(game, 0, 0);

    if (!pause) {  //PAUSE on/off

      //HERO   
      // Hero movement Y-axis
      HeldY = HeldY + HeldVY/frameRate;

      //Hero cannot leave screen 
      if (HeldY<0) {
        HeldY = 0;
        HeldVY = 0;
      } else if (HeldY>height-HeldH) {
        HeldY=height-HeldH;
        HeldVY = 0;
      }

      //Hero Movement X-axis
      HeldX=HeldX+HeldVX/frameRate;

      //Hero cannot leave screen
      if (HeldX<0) {      
        HeldX=0;
        HeldVX=0;
      } else if (HeldX>width-HeldW) {
        HeldX=width-HeldW;
        HeldVX=0;
      }

      //ENEMIES
      Gegner2X += Gegner2VX/frameRate/1.5;
      Gegner2Y += Gegner2VY/frameRate/1.5;

      //Enemy 1 change how he follow hero every 2 seconds
      int sOnPC = second();  //checks computer seconds
      if (sOnPC%3==0) {   //if seconds devidable by 3 which means every 3 seconds do this for one second
        float targetX = HeldX;
        float dx = targetX - Gegner1X;
        Gegner1X += (dx * 0.03)/1.5;
        float targetY = HeldY;
        float dy = targetY - Gegner1Y;
        Gegner1Y += (dy * 0.03)/1.5;
      } else {             //for other two seconds just wander around
        Gegner1X += Gegner1VX/frameRate/1.5;
        Gegner1Y += Gegner1VY/frameRate/1.5;
      }

      //Enemy 3 follows hero with vectors - cannot be killed  - goes directly to player
      float targetV=HeldX;
      float dv=targetV-Gegner3X;
      Gegner3X+= (dv*0.025)/1.5;

      float targetW= HeldY;
      float dw=targetW-Gegner3Y;
      Gegner3Y+= (dw*0.025)/1.5;

      //ENEMIES CAN'T LEAVE SCREEN:
      if ((Gegner1Y<0 && Gegner1VY<0) ||(Gegner1Y>height-50 && Gegner1VY>0)) {
        Gegner1VY = -Gegner1VY;
      }  
      if ((Gegner1X>width-50 && Gegner1VX>0) || (Gegner1X<0 && Gegner1VX<0)) {
        Gegner1VX = -Gegner1VX;
      }

      //   opponent 2 cannot leave play screen
      if ((Gegner2Y<0 && Gegner2VY<0) ||(Gegner2Y>height-50 && Gegner2VY>0)) {
        Gegner2VY = -Gegner2VY;
      }  
      if ((Gegner2X>width-50 && Gegner2VX>0) || (Gegner2X<0 && Gegner2VX<0)) {
        Gegner2VX = -Gegner2VX;
      }

      // opponent 3 cannot leave screen
      if ((Gegner3Y<0 && Gegner3VY<0) ||(Gegner3Y>height-50 && Gegner3VY>0)) {
        Gegner3VY = -Gegner3VY;
      }  
      if ((Gegner3X>width-50 && Gegner3VX>0) || (Gegner3X<0 && Gegner3VX<0)) {
        Gegner3VX = -Gegner3VX;
      }


      // create opponent 1
      image (enemy2, Gegner1X, Gegner1Y, 50, 50);

      // create opponent 2
      image (enemy1, Gegner2X, Gegner2Y, 50, 50);

      //create opponent 3
      image (enemy3, Gegner3X, Gegner3Y, 50, 50);

      // opponent 1 is beaten by Hero by clicking left mouse button
      if (Gegner1X<=HeldX+(HeldW*HeroRange) && 
        Gegner1X>=HeldX-(HeldW*HeroRange) &&
        Gegner1Y<=HeldY+(HeldH*HeroRange) &&
        Gegner1Y>=HeldY-(HeldH*HeroRange)) {

        if (mousePressed && (mouseButton == LEFT))  //kill enemy
        {
          Gegner1X=1000; 
          Gegner1Y=random(30, height-30); //reset position of opponent 1
          score = score + 1;
          HitEn.play();
        }
      }

      // opponent 2 is beaten by Hero by clicking right mouse button
      if (Gegner2X<=HeldX+(HeldW*HeroRange) && 
        Gegner2X>=HeldX-(HeldW*HeroRange) &&
        Gegner2Y<=HeldY+(HeldH*HeroRange) &&
        Gegner2Y>=HeldY-(HeldH*HeroRange)) {

        if (mousePressed && (mouseButton == RIGHT))    //kill enemy
        {
          Gegner2X=0; 
          Gegner2Y=random(30, height-30);
          score = score + 3;
          HitEn.play();
        }
      }

      //Enemy gets too close - end the game
      if ((Gegner2X<=HeldX+(HeldW*EnemyRange) && 
        Gegner2X>=HeldX-(HeldW*EnemyRange) &&
        Gegner2Y<=HeldY+(HeldH*EnemyRange) &&
        Gegner2Y>=HeldY-(HeldH*EnemyRange))||

        (Gegner1X<=HeldX+(HeldW*EnemyRange) && 
        Gegner1X>=HeldX-(HeldW*EnemyRange) &&
        Gegner1Y<=HeldY+(HeldH*EnemyRange) &&
        Gegner1Y>=HeldY-(HeldH*EnemyRange)) ||

        (Gegner3X<=HeldX+(HeldW*EnemyRange) && 
        Gegner3X>=HeldX-(HeldW*EnemyRange) &&
        Gegner3Y<=HeldY+(HeldH*EnemyRange) &&
        Gegner3Y>=HeldY-(HeldH*EnemyRange))
        )
      {
        Scream.play();
        gameState = GAMEOVER;
        musicSnd.stop(); //background music stops
        lostSnd.play(); //Lost sound plays
      }

      //Pause Screen should appear
      if (pause) {
        gameState = PAUSE;
      }

      //ITEMS
      //R2 - Point Item 
      image (Food, Item1X, Item1Y, 70, 70);
      if (Item1X<=HeldX+HeldW && 
        Item1X>=HeldX-HeldW &&
        Item1Y<=HeldY+HeldH &&
        Item1Y>=HeldY-HeldH) {
        Item1H=0;
        Item1W=0;
        score++;
        ellipse (Item1X, Item1Y, Item1H, Item1W);

        //Can't appear out of screen
        Item1X = random(25, 855);
        Item1Y = random(25, 535);
        Item1H = 20;
        Item1W=20;
        HeldSpeedX-=50;
        HeldSpeedY-=50;
        /*Gegner1X += (dx * 0.05)/1.5;
         Gegner1Y += (dy * 0.05)/1.5;
         Gegner3X+= (dv*0.045)/1.5;
         Gegner3Y+= (dw*0.045)/1.5;*/
        itemSnd.play();
      }

      //Millennium Falcon - Speed Item
      fill (150, 200, 0);
      image (LSD, Item2X, Item2Y, 75, 75);
      if (Item2X<=HeldX+HeldW && 
        Item2X>=HeldX-HeldW &&
        Item2Y<=HeldY+HeldH &&
        Item2Y>=HeldY-HeldH) {
        Item2H=0;
        Item2W=0;
        ellipse (Item2X, Item2Y, Item2H, Item2W);

        //Can't appear out of screen
        Item2X = random(25, 845);
        Item2Y = random(25, 535);
        Item2H = 20;
        Item2W=20;
        HeldSpeedX+=50;
        if (HeldSpeedX>500) HeldSpeedX=500;
        HeldSpeedY+=50;
        if (HeldSpeedY>500) HeldSpeedY=500;
        fastSnd.play();
      }

      //draw hero
      image (heroo, HeldX, HeldY, HeldW, HeldH);
      fill (255);
      textSize(60);
      textAlign (CENTER, TOP);
      text (score, width/2, 0);//Score
    }
  }
}