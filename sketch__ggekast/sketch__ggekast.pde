int houseX = 300;  // Variabler for at tegne hus
int houseY = 150;
int houseWidth = 200;
int houseHeight = 200;
int eggSize = 20;    //Variabler for æg tegning og parametre for hastighed og antal.
float throwSpeed = 2.0;
int numEggs = 10;
float armAngle = -PI / 4;  // Hvor armen starter i kastet
boolean isThrowing = false;
boolean allEggsThrown = false;  // Tæller til om alle æg er kastet

String message = "Tryk R for at starte animationen!";
Egg[] eggs = new Egg[numEggs];
ArrayList<Stain> stains = new ArrayList<Stain>();

void setup() {
  size(600, 400);
  initEggs();
  noLoop();  // Starter uden at loope animationen
}

void draw() {
  background(200, 220, 255); // himmel farven
  drawHouse(houseX, houseY, houseWidth, houseHeight); // tegner huset
  drawGirl(); // tegner pigen
  drawStains(); // tegner æggeklatter 
  textSize(16);
  fill(0);
  text(message, 20, 20); 
  
  if (isThrowing) { //animerer armen til at bevægesig kun når æggene kastes
    throwEggs(); 
    animateArm(); 
  }
}

// Initialiserer æggene på tilfældige positioner
void initEggs() {
  for (int i = 0; i < eggs.length; i++) {
    eggs[i] = new Egg(random(50, 100), random(200, 300), random(3, 5));  
  }
}

// Metode for at starte/genstarte animationen på r
void keyPressed() {
  if (key == 'r' || key == 'R') {
    stains.clear(); 
    initEggs();  
    isThrowing = true;  
    allEggsThrown = false;  
    armAngle = -PI / 4;  
    message = "Tryk R for at kaste flere!";
    loop();  
  }
}

// Metode for at tegne huset
void drawHouse(int x, int y, int w, int h) {
  fill(150, 75, 0);  
  rect(x, y, w, h);  
  fill(100, 50, 0);
  triangle(x, y, x + w / 2, y - 100, x + w, y);  
}

// Metode for at tegne pigen
void drawGirl() {
  fill(255, 200, 200);
  ellipse(100, 280, 30, 30); // Hoved
  fill(255, 150, 150);
  rect(85, 300, 30, 50); // Krop
  
  // tegner armen
  pushMatrix();
  translate(95, 320);  
  rotate(armAngle);  
  stroke(255, 200, 200);
  strokeWeight(5);
  line(0, 0, -35, -50);  
  popMatrix();
  noStroke();
}

// Animerer armen
void animateArm() {
  if (armAngle < 0) {
    armAngle += 0.05;  
  } else {
    armAngle = -PI / 4;  
  }

// Stopper animation når æggene klækker
  if (allEggsCracked()) {
    isThrowing = false;  
    noLoop();  
  }
}

// Metode for at se om æggene er klækket
boolean allEggsCracked() {
  for (Egg egg : eggs) {
    if (!egg.isCracked) {
      return false;  
    }
  }
  return true;  
}

// Metode for at lave pletter
void drawStains() {
  for (Stain stain : stains) {
    stain.display();
  }
}

// Metode for at æggene kastes
void throwEggs() {
  for (Egg egg : eggs) {
    if (!egg.isCracked) {
     egg.move();  
    }
    egg.display();
    
    // Tjekker om æggene rammer huset
    if (!egg.isCracked && egg.x > houseX - eggSize && egg.x < houseX + houseWidth + eggSize 
    && egg.y > houseY - eggSize && egg.y < houseY + houseHeight + eggSize) {
  egg.isCracked = true;
  stains.add(new Stain(egg.x, egg.y));  
}



    
    // Hvis æggene klækker tilføjer plet
    if (egg.isCracked) {
      egg.y = houseY + houseHeight;  
    }
  }
}

// Æg klasse
class Egg {
  float x, y;
  float speed;
  boolean isCracked = false;
  
  Egg(float x, float y, float speed) {
    this.x = x;
    this.y = y;
    this.speed = speed;
  }
  
// Æggenes bevægelse
  void move() {
    if (!isCracked) {
      x += speed++;  
    }
  }
  
//Æggene tegnes
  void display() {
    if (!isCracked) {
      fill(255, 255, 200); 
      ellipse(x, y, eggSize, eggSize); 
    }
  }
}

// Klasse for at lave klatter
class Stain {
  float x, y;
  
  Stain(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void display() {
    fill(255, 200, 0, 150);  
    ellipse(x, y, eggSize + 10, eggSize + 10);  
  }
}
