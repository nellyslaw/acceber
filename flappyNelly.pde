World game;

void setup() { 
    background(0);
    size(380, 500); 
    smooth();
    frameRate(30);
    game = new World();
} 

void draw() { 
    game.display();
}

class World {
    int Yvelocity = 1;
    int time = 0;
    int maxTime = 100;
    Bird flappyNelly = new Bird();
    List<Pillar> pillars = new ArrayList();  
    
    public World(){
        this.flappyNelly = new Bird();
        return this;
    }
    
    private void scroll(){
        if(time>= maxTime){
            time = 0;
            pillars.add(new Pillar());
        }
        time += Yvelocity;
    }
    
    public void display() {
        scroll();
        for(int i=0; i<pillars.size(); i++){
            Pillar p = pillars.get(i);
            p.moveAndShow(this.Yvelocity);
            if (p.getXpos() <= -1*p.getThickness()) {
                pillars.remove(i);
            }
        }
    }
}

class Bird{
    int Xpos = 0;
    int Ypos = height/2;
    
    public Bird(){
        return this;
    }
    
}

class Pillar {
    int Xpos = 380;
    int thickness = 25;
    int gatePos = int(random(50,450));
    int pilHeight = 100;
    
    public Pillar() {
        return this;
    }
    
    public void moveAndShow(int velocity){
        this.Xpos -= velocity;
        rect(Xpos, 0, thickness, gatePos);
        rect(Xpos, gatePos+pilHeight, thickness, height);
    }
    
    public int getXpos(){
        return this.Xpos;
    }
    
    public int getThickness(){
        return this.thickness;
    }
}