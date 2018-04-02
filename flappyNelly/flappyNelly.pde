World game;
boolean gameOver = false;
PImage pillarUp;
PImage pillarDown;
PImage nelly;
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
        gameOver = game.checkCollision();
        game.display();
        if(gameOver){
            setCookie(game.getHighScore());
            frameRate(0);
        }
    }
}

void mousePressed() {
    if (!gameOver){
        game.getBird().flyUp();
    }
    else{
        game = new World();
        gameOver = false;
        frameRate(30);
    }
     
}

void keyPressed() {
    if (!gameOver)
        game.getBird().flyUp();
    else{
        game = new World();
        gameOver = false;
        frameRate(30);
    }
}

class World {
    int Yvelocity = 5;
    int dist = 0;
    int spawnDist = 180;
    int highScore = loadCookie();
    int currentScore = 0;
    
    Bird flappyNelly = new Bird();
    List<Pillar> pillars = new ArrayList();  
    
    World(){
        this.flappyNelly = new Bird();
    }
    
    private void updateScore(){
        currentScore += 1;
        if (currentScore > highScore){
            highScore = currentScore;
        }
    }
    
    public void scroll(){
        flappyNelly.move();
        for(int i=pillars.size()-1;i>0;i--){
            Pillar p = pillars.get(i);
            p.scroll(Yvelocity);
            if (p.getXpos() <= -1*p.getThickness()) {
                pillars.remove(i);
            }
            if (p.getXpos()+p.getThickness() <= flappyNelly.getPos().x && !p.hasCounted()){
                p.setCounted(true);
                updateScore();
            }
        }
        if(dist>= spawnDist){
            dist = 0;
            pillars.add(new Pillar());
        }
        dist += Yvelocity;
    }
    
    public boolean checkCollision(){
        PVector birdPos = flappyNelly.getPos();
        if (birdPos.y == 0 || birdPos.y == height - flappyNelly.getSize()){
            return true;
        }
        else if (hitPillar(birdPos)){
            return true;
        }
        return false;
    }
    
    private boolean hitPillar(PVector birdPos){
        for (Pillar p: pillars){
            if (p.getXpos()-birdPos.x >= -1*p.getThickness() && p.getXpos()-birdPos.x <= flappyNelly.getSize()){
                if (birdPos.y <= p.getGateTop()){
                    if (p.getXpos()-birdPos.x != flappyNelly.getSize()){
                        flappyNelly.setYpos(p.getGateTop());
                    }
                    return true;
                }
                else if (birdPos.y+flappyNelly.getSize() >= p.getGateBottom()){
                    if (p.getXpos()-birdPos.x != flappyNelly.getSize()){
                        flappyNelly.setYpos(p.getGateBottom()-flappyNelly.getSize());
                    }
                    return true;
                }
            }
        }
        return false;
    }
    
    public void display() {
        background(0);
        flappyNelly.show();
        for (Pillar p: pillars){
            p.show();
        }
        showScores();
    }
    
    public void showScores(){
        fill(0,200,0);
        textAlign(CENTER);
        String score = "Current Score: "+currentScore+" | High Score: "+highScore;
        text(score,width/2,25);
    }
    
    public Bird getBird(){
        return this.flappyNelly;
    }
    
    public int getHighScore(){
        return this.highScore;
    }
}

class Bird{
    final int Xpos = 15;
    final int size = 25;
    final float gravity = -1.5;
    final float lift = 20;
    int Ypos = height/2 - size;
    float velocity = 0;
    
    public void show(){
        image(nelly,Xpos,Ypos,size,size);
    }
    
    public void move() {
        this.Ypos += this.velocity;
        this.velocity -= gravity;
        if (Ypos < 0){
            Ypos = 0;
        }
        if (Ypos > height-size){
            Ypos = height-size;
        }
    }
    
    public void setYpos(int Ypos){
        this.Ypos = Ypos;
    }
    public void flyUp(){
        this.velocity = -1*lift;
    }
        
    public int getSize() {
        return this.size;
    }
    
    public PVector getPos() {
        return new PVector(Xpos,Ypos);
    }
}

class Pillar {
    int Xpos = 380;
    int thickness = 50;
    int pilHeight = 300;
    int gatePos = int(random(10,height-pilHeight));
    boolean counted = false;
    
    
    public void show(){
        image(pillarDown,Xpos, gatePos-180, thickness, 180);
        image(pillarUp,Xpos, gatePos+pilHeight, thickness, 180);
    }
    
    public void scroll(int velocity){
        this.Xpos -= velocity;
    }
    
    public void setCounted(boolean counted){
        this.counted = counted;
    }
    
    public boolean hasCounted(){
        return this.counted;
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
