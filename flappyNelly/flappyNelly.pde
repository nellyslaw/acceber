World game;
boolean gameOver = false;
PImage pillarUp;
PImage pillarDown;
PImage nelly;
PImage andy;
final String hsParam = "nellyhs=";

int loadCookie(){
  int hsIndex;
  String cs = document.cookie;
  for (String s: cs.split(";")){
      if (s.contains(hsParam)){
          return int(s.split(hsParam)[1]);
      }
  }
  return 0;
}

void setCookie(int score){
    String expiryDate = new Date(Date.now()+31556952000).toUTCString();
    document.cookie = hsParam+score+";expires="+expiryDate+";";
}

void setup() { 
    pillarUp = loadImage("flappyNelly/pillarUp.jpg");
    pillarDown = loadImage("flappyNelly/pillarDown.jpg");
    nelly = loadImage("flappyNelly/smiles.jpg");
    andy = loadImage("flappyNelly/smokes.jpg");
    textFont("Courier");
    textSize(20);
    background(0);
    size(380, 500); 
    smooth();
    frameRate(30);
    game = new World();
} 

void draw() { 
    if (!gameOver){  
        game.scroll();
        game.checkCollision();
        gameOver = game.isGameOver();
        game.display();
        if(gameOver){
            setCookie(game.getHighScore());
            frameRate(0);
        }
    }
}

void mousePressed() {
    if (!gameOver){
        if (game.nelly && mouseButton == LEFT && game.nelly.isAlive()){
            game.nelly.flyUp();
        }
        else if (game.andy && mouseButton == RIGHT && game.andy.isAlive()){
            game.andy.flyUp();
        }
    }
    else{
        game = new World();
        gameOver = false;
        frameRate(30);
    }
     
}

class World {
    float Xvelocity = 5;
    int dist = 0;
    int spawnDist = 180;
    int highScore = loadCookie();
    int currentScore = 0;
    Bird nelly = new Bird(0,15,20.0);
    Bird andy = new Bird(1,50,20.0);
    List<Bird> birds = new ArrayList();
    List<Pillar> pillars = new ArrayList(); 
    
    World(){
        this.birds.add(nelly);
        this.birds.add(andy);
    }
    
    private void updateScore(){
        currentScore += 1;
        if (currentScore > highScore){
            highScore = currentScore;
        }
    }
    
    public void scroll(){
        for(int i=pillars.size()-1;i>=0;i--){
            Pillar p = pillars.get(i);
            p.scroll(Xvelocity);
            if (p.getXpos() <= -1*p.getThickness()) {
                pillars.remove(i);
            }
        }
        Pillar firstP = pillars.get(0);
        for(int i= birds.size()-1; i>=0; i--){
            Bird b = birds.get(i);
            b.move();
            if (firstP){
                if (firstP.getXpos()+firstP.getThickness() <= b.getPos().x && !firstP.hasCounted(b)){
                    firstP.count(b);
                    updateScore();
                }
                if (b.getPos().x < -1*b.getSize()){
                    birds.remove(b);
                }
            }
        }
        if(dist>= spawnDist){
            dist = 0;
            pillars.add(new Pillar());
        }
        dist += Xvelocity;
    }
    
    public void checkCollision(){
        for (Bird b : birds){
            int pillarBottom;
            if (b.isAlive()){ 
                PVector birdPos = b.getPos();
                if (birdPos.y == 0 || birdPos.y == height - b.getSize()){
                    b.kill(this.Xvelocity, 0);
                }
                else if ((pillarBottom = hitPillar(b)) > -1){
                    b.kill(this.Xvelocity, pillarBottom);
                }
            }
        }
    }
    
    public boolean isGameOver(){
        for (Bird b: birds){
            if (b.isAlive()){
                return false;
            }
        }
        return true;
    }
    
    private int hitPillar(Bird b){
        PVector birdPos = b.getPos();
        for (Pillar p: pillars){
            if (p.getXpos()-birdPos.x >= -1*p.getThickness() && p.getXpos()-birdPos.x <= b.getSize()){
                if (birdPos.y <= p.getGateTop()){
                    if (p.getXpos()-birdPos.x != b.getSize()){
                        b.setYpos(p.getGateTop());
                        return p.getGateBottom();
                    }
                    return 0;
                }
                else if (birdPos.y+b.getSize() >= p.getGateBottom()){
                    if (p.getXpos()-birdPos.x != b.getSize()){
                        b.setYpos(p.getGateBottom()-b.getSize());
                        return p.getGateBottom();
                    }
                    return 0;
                }
            }
        }
        return -1;
    }
    
    public void display() {
        background(0);
        for (Pillar p: pillars){
            p.show();
        }
        for (Bird b: birds){
            b.show();
        }
        showScores();
    }
    
    public void showScores(){
        fill(0,200,0);
        textAlign(CENTER);
        String score = "Current Score: "+currentScore+" | High Score: "+highScore;
        text(score,width/2,25);
    }
    
    public Bird getBird(int index){
        return this.birds.get(index);
    }
    
    public int getHighScore(){
        return this.highScore;
    }
}

class Bird{
    final int size = 25;
    final float gravity = -1.5;
    int Xpos;
    float Xvelocity = 0;
    float lift;
    int Ypos = height/2 - size;
    float Yvelocity = 0;
    boolean alive = true;
    int XfloorPos = height-size;
    int id;
    
    public Bird(int id, int Xpos, float lift){
        this.Xpos = Xpos;
        this.lift = lift;
        this.id = id;
    }
    
    public void show(){
        if (id == 0){
            image(nelly,Xpos,Ypos,size,size);
        }
        else if (id == 1){
            image(andy,Xpos,Ypos,size,size);
        }
    }
    
    public void move() {
        this.Ypos += this.Yvelocity;
        this.Yvelocity -= gravity;
        this.Xpos -= this.Xvelocity;
        if (Ypos < 0){
            Ypos = 0;
        }
        if (Ypos > XfloorPos){
            Ypos = XfloorPos;
        }
    }
    
    public void kill(float Xvecocity, int floor){
        this.alive = false;
        this.Xvelocity = Xvecocity;
        this.Yvelocity = 0;
        if (floor > 0){
            this.XfloorPos = floor-size;
        }
    }
    
    public void setYpos(int Ypos){
        this.Ypos = Ypos;
    }
    public void flyUp(){
        this.Yvelocity = -1*lift;
    }
        
    public int getSize() {
        return this.size;
    }
    
    public PVector getPos() {
        return new PVector(Xpos,Ypos);
    }
    
    public boolean isAlive(){
        return this.alive;
    } 
}

class Pillar {
    int Xpos = 380;
    int thickness = 50;
    int pilHeight = 300;
    int gatePos = int(random(10,height-pilHeight));
    List<Bird> counted = new ArrayList();    
    
    public void show(){
        image(pillarDown,Xpos, gatePos-180, thickness, 180);
        image(pillarUp,Xpos, gatePos+pilHeight, thickness, 180);
    }
    
    public void scroll(float velocity){
        this.Xpos -= velocity;
    }
    
    public void count(Bird b){
        this.counted.add(b);
    }
    
    public boolean hasCounted(Bird b){
        return this.counted.contains(b);
    }
    
    public int getXpos(){
        return this.Xpos;
    }
    
    public int getGateTop(){
        return this.gatePos;
    }
    
    public int getGateBottom(){
        return this.gatePos + this.pilHeight;
    }
    
    public int getThickness(){
        return this.thickness;
    }
}
