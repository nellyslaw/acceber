int BOX_HEIGHT = 80;
int BOX_WIDTH = 80;
int gridOffset = 10;
int cols= 4;
int rows= 4;
Grid game;
boolean gameOver = false;
boolean rectOver;
int rectSize = 60;
void setup() {   
    background(0);
    size(340, 340);
    smooth();
    textFont("Courier");
    textAlign(CENTER, CENTER);
    game = new Grid(cols,rows);
    frameRate(30);
} 

void update(int x, int y) {
    if ( overRect(width*0.5-rectSize*0.5, height*0.5-rectSize*0.5, rectSize, rectSize) ) {
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
        if (game.makeMove()){
            game.newBox();
        }
        else {
            gameOver = true;
        }
        game.show();
    }
    else{
        update(mouseX,mouseY);
        showRetry();
    }
}

void showRetry() {
    background(0);
    textSize(25);
    fill(255);
    text("Nelly Bo Belly Small Belly?", width*0.5, height*0.3);
    stroke(255);
    rect(width*0.5-rectSize*0.5, height*0.5-rectSize*0.5, rectSize, rectSize);
    textSize(20);
    fill(0);
    text("YES", width*0.5, height*0.5);
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
            showRetry();
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
    
    public int[] calcWeights() {
        private int[][] weights = new int[4][4];
        private int[] adjusted = new int[4];
        int firstW = 1;
        int secondW = 0.3;
        int thirdW = 0.2;
        int fourthW = 0.1;
        int k = 0;
        
        for (int i=0; i<cols; i++){
            for (int j=0; j<rows; j++){
                weights[0][k] += gameGrid[i][j].getValue();
                weights[1][3-k] += gameGrid[i][j].getValue();
                weights[2][k] += gameGrid[j][i].getValue();
                weights[3][3-k] += gameGrid[j][i].getValue();
            }
            k++;
            }
        for (int i=0; i<cols;i++){
            adjusted[i] = weights[i][0]*firstW + weights[i][1]*secondW + weights[i][2]*thirdW + weights[i][3]*fourthW;    
        }
        return adjusted;
    } 
    
    public boolean makeMove(){
        List<int> sortedWeights = sortWeights(calcWeights()); 
        List<int> legalMoves = findLegalMoves();
        int move = sortedWeights.get(0);

        while(legalMoves.size() >0 && !legalMoves.contains(move)){
            sortedWeights.remove(0);
            move = sortedWeights.get(0);
        }           
        if (move == 0){
            left();
            return true;
        }
        else if(move == 1){
            right();
            return true;
        }
        else if(move == 2){
            up();
            return true;
        }
        else if(move == 3){
            down();
            return true;
        }
        return false;    
    }
    
    public List<int> findLegalMoves() {
        List<int> legalMoves = new ArrayList();
        //up
        for (int i=0; i<cols;i++){
            int ref_j = 0;
            Box ref = gameGrid[i][ref_j];
            for (int j=1;j<rows; j++){
                Box curr = gameGrid[i][j];
                if (curr.getValue() > 0){
                    if (ref.getValue() == 0){
                        legalMoves.add(2);
                        break;
                    }
                    else if(ref.getValue() == curr.getValue()){
                        ref_j++;
                        ref = gameGrid[i][ref_j];
                        legalMoves.add(2);
                        break;
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
        //down
        for (int i=0; i<cols;i++){
            int ref_j = rows-1;
            Box ref = gameGrid[i][ref_j];
            for (int j=rows-2;j>=0; j--){
                Box curr = gameGrid[i][j];
                if (curr.getValue() > 0){
                    if (ref.getValue() == 0){
                        legalMoves.add(3);
                        break;
                    }
                    else if(ref.getValue() == curr.getValue()){
                        ref_j--;
                        ref = gameGrid[i][ref_j];
                        legalMoves.add(3);
                        break;
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
        //left
        for (int i=0; i<cols;i++){
            int ref_j = 0;
            Box ref = gameGrid[ref_j][i];
            for (int j=1;j<rows; j++){
                Box curr = gameGrid[j][i];
                if (curr.getValue() > 0){
                    if (ref.getValue() == 0){
                        legalMoves.add(0);
                        break;
                    }
                    else if(ref.getValue() == curr.getValue()){
                        ref_j++;
                        ref = gameGrid[ref_j][i];
                        legalMoves.add(0);
                        break;
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
        //right
        for (int i=0; i<cols;i++){
            int ref_j = rows-1;
            Box ref = gameGrid[ref_j][i];
            for (int j=rows-2;j>=0; j--){
                Box curr = gameGrid[j][i];
                if (curr.getValue() > 0){
                    if (ref.getValue() == 0){
                        legalMoves.add(1);
                        break;
                    }
                    else if(ref.getValue() == curr.getValue()){
                        ref_j--;
                        ref = gameGrid[ref_j][i];
                        legalMoves.add(1);
                        break;
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
        return legalMoves;
    }
    
    public List<int> sortWeights(int[] weights){
        List<int> sorted = new ArrayList();
        int maxWeight = 0;
        int maxIndex = 0;
        
        while (sorted.size() < 4){    
            for (int i=0; i<4; i++){;
                if (weights[i] > -1 && weights[i] >= maxWeight ) {
                    maxWeight = weights[i];
                    maxIndex = i;
                }
            }
            sorted.add(maxIndex);
            weights[maxIndex] = -1;
            maxWeight = 0;
        }
        return sorted;        
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
        rect(col*BOX_WIDTH+gridOffset, row*BOX_HEIGHT+gridOffset, BOX_WIDTH, BOX_HEIGHT);
        if (value > 0){    
            textSize(20);
            fill(200);
            text(this.value, col*BOX_WIDTH+gridOffset+BOX_WIDTH*0.5, row*BOX_HEIGHT+gridOffset+BOX_WIDTH*0.5, 1);
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
            this.value = 4;//2;
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