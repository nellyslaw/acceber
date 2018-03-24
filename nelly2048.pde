int BOX_HEIGHT = 80;
int BOX_WIDTH = 80;
int cols= 4;
int rows= 4;
Grid game;
boolean gameOver = false;
boolean rectOver;
int rectX = 140;
int rectY = 100;
int rectSize = 60;
void setup() {   
    background(0);
    size(330, 400); 
    smooth();
    game = new Grid(cols,rows);
    noLoop();
} 

void update(int x, int y) {
    if ( overRect(rectX, rectY, rectSize, rectSize) ) {
        rectOver = true;
    } 
    else {
        rectOver = false;
    }
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

void draw() {
    if (!gameOver){
        game.show();
    }
    else{
        update(mouseX,mouseY);
        background(0);
        textSize(25);
        fill(255);
        text("Nelly Bo Belly Small Belly", 20, 200);
        stroke(255);
        rect(rectX, rectY, rectSize, rectSize);
        textSize(20);
        fill(0);
        text("Again", 145, 135);
    }
}

void mousePressed() {
  if (rectOver) {
    gameOver= false;
    game = new Grid(cols,rows);
    rectOver = false;
  }
}

void keyPressed() {
    if (key == CODED && !gameOver){
        if (keyCode == LEFT){
            if (game.left()){
                game.newBox();
            }
        }
        else if (keyCode == RIGHT){
            if (game.right()){
                game.newBox();
            }
        }
        else if (keyCode == UP){
            if (game.up()){
                game.newBox();
            }
        }
        else if (keyCode == DOWN){
            if (game.down()){
                game.newBox()
            }
        }
        if (!game.vertMovable() && !game.horizMovable()){
            gameOver = true;
        }
    }
    redraw();
}

class Grid {
    private Box[][] gameGrid;
    private List<Box> free = new ArrayList();
    
    public Grid(int cols, int rows){
        gameGrid = new Box[cols][rows];       
        for(int i=0;i<cols;i++){
            for(int j=0;j<rows;j++) {
                gameGrid[i][j] = new Box(i,j);
                free.add(gameGrid[i][j]);
            }
        }
        newBox();
    }
    
    public boolean vertMovable(){
        for(int i=0;i<cols;i++){
            Box refb = gameGrid[i][0];
            for(int j=1;j<rows;j++){
                if (gameGrid[i][j].getValue() == 0 || refb.getValue() == 0){
                    return true;
                }
                if (refb.getValue() == gameGrid[i][j].getValue()){
                    return true;
                }
                refb = gameGrid[i][j];
            }
        }
        return false;
    }
    public boolean horizMovable(){
        for(int i=0;i<cols;i++){
            Box refb = gameGrid[0][i];
            for(int j=1;j<rows;j++){
                if (gameGrid[j][i].getValue() == 0 || refb.getValue() == 0){
                    return true;
                }
                if (refb.getValue() == gameGrid[j][i].getValue()){
                    return true;
                }
                refb = gameGrid[j][i];
            }
        }
        return false;
    }
    
    public void newBox(){
        int randBox = int(random(0,free.size()));
        Box b = free.get(randBox);
        b.start();
        free.remove(b);
    }
    private void swap(Box ref, Box curr){
        int temp = ref.getValue();
        ref.setValue(curr.getValue());
        curr.setValue(temp);
        free.add(curr);
        free.remove(ref);
    }
    private void add(Box ref, Box curr){
        ref.doublePoints();
        curr.setValue(0);
        free.add(curr);
    }
    
    public boolean up(){
        boolean moved = false;
        for (int i=0; i<cols;i++){
            int ref_j = 0;
            Box ref = gameGrid[i][ref_j];
            for (int j=1;j<rows; j++){
                Box curr = gameGrid[i][j];
                if (curr.getValue() > 0){
                    if (ref.getValue() == 0){
                        swap(ref,curr);
                        moved = true;
                    }
                    else if(ref.getValue() == curr.getValue()){
                        add(ref,curr);
                        ref_j++;
                        ref = gameGrid[i][ref_j];
                        moved = true;
                    }
                    else if(ref.getValue() != curr.getValue()){
                        if (ref_j < j-1){
                            j--;
                        }
                        ref_j++;
                        ref = gameGrid[i][ref_j];
                    }
                }
            }
        }
        return moved;
    }
    public boolean down(){ 
        boolean moved = false;     
        for (int i=0; i<cols;i++){
            int ref_j = rows-1;
            Box ref = gameGrid[i][ref_j];
            for (int j=rows-2;j>=0; j--){
                Box curr = gameGrid[i][j];
                if (curr.getValue() > 0){
                    if (ref.getValue() == 0){
                        swap(ref,curr);
                        moved = true;
                    }
                    else if(ref.getValue() == curr.getValue()){
                        add(ref,curr);
                        ref_j--;
                        ref = gameGrid[i][ref_j];
                        moved = true;
                    }
                    else if(ref.getValue() != curr.getValue()){
                        if (ref_j > j+1){
                            j++;
                        }
                        ref_j--;
                        ref = gameGrid[i][ref_j];
                    }
                }
            }
        }
        return moved;
    }
    
    public boolean left(){
        boolean moved = false;
         for (int i=0; i<cols;i++){
            int ref_j = 0;
            Box ref = gameGrid[ref_j][i];
            for (int j=1;j<rows; j++){
                Box curr = gameGrid[j][i];
                if (curr.getValue() > 0){
                    if (ref.getValue() == 0){
                        swap(ref,curr);
                        moved = true;
                    }
                    else if(ref.getValue() == curr.getValue()){
                        add(ref,curr);
                        ref_j++;
                        ref = gameGrid[ref_j][i];
                        moved = true;
                    }
                    else if(ref.getValue() != curr.getValue()){
                        if (ref_j < j-1){
                            j--;
                        }
                        ref_j++;
                        ref = gameGrid[ref_j][i];
                    }
                }
            }
        }
        return moved;
    }
    
    public boolean right(){
        boolean moved = false;
        for (int i=0; i<cols;i++){
            int ref_j = rows-1;
            Box ref = gameGrid[ref_j][i];
            for (int j=rows-2;j>=0; j--){
                Box curr = gameGrid[j][i];
                if (curr.getValue() > 0){
                    if (ref.getValue() == 0){
                        swap(ref,curr);
                        moved = true;
                    }
                    else if(ref.getValue() == curr.getValue()){
                        add(ref,curr);
                        ref_j--;
                        ref = gameGrid[ref_j][i];
                        moved = true;
                    }
                    else if(ref.getValue() != curr.getValue()){
                        if (ref_j > j+1){
                            j++;
                        }
                        ref_j--;
                        ref = gameGrid[ref_j][i];
                    }
                }
            }
        }
        return moved;
    }
    
    public void show(){
        for(int i=0;i<cols;i++){
            for(int j=0;j<rows;j++) {
                if (gameGrid[i][j].hasChanged()){
                    gameGrid[i][j].display();
                }
            }
        }
    }    
}
class Box {
    private int row;
    private int col;
    private int value = 0;
    private boolean changed = true;
    
    public Box(int col,int row) {
        this.col = col;
        this.row = row;
    }
    
    public void display(){   
        colorMode(HSB);
        int logV = log(value)/log(2);     
        fill(200, 20*logV+50, 20*logV+50);
        stroke(255);
        rect(col*BOX_WIDTH, row*BOX_HEIGHT, BOX_WIDTH, BOX_HEIGHT);
        textSize(20);
        fill(200);
        if (value > 0){    
            text(this.value, (col*BOX_WIDTH)+30, (row*BOX_HEIGHT)+40, 1);
        }
        this.changed = false;
    }
    
    public void doublePoints(){
        this.value = this.value*2;
        this.changed = true;
    }
    
    public void setValue(int val) {
        this.value = val;
        this.changed = true;
    }
    
    public void start(){
        float r = random(0,5);
        if (r > 4){
            this.value = 4;
        }
        else {
            this.value = 2;
        }
        this.changed = true;
    }
    
    public boolean hasChanged(){
        return this.changed;
    }
    
    public int getValue(){
        return this.value;
    }
}