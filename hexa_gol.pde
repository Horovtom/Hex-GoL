final int DISPLAY_WIDTH = 640;
final int DISPLAY_HEIGHT = 640;
int cellSize = 10;
int W_0, H_0;

int rows, cols;

boolean[][] grid;
PVector[][] gridCoords;
boolean[] rules;

void setup() {
  size(640, 640);
  loadRules();
  initializeGrid();
}

void loadRules() {
  rules = new boolean[6];
  
  
  // TODO: Complete
}

void makeStep() {
  // TODO: Complete
  
}

void initializeGrid() {
  W_0 =  (int) (0.5 * cellSize);
  H_0 = (int) sqrt(cellSize * cellSize-0.25 * cellSize * cellSize);
  cols = (int) ((((DISPLAY_WIDTH / (cellSize*3.0/4))) / 2) * 1.2);
  rows = DISPLAY_HEIGHT / (H_0 * 2) + 2;

  grid = new boolean[rows][cols];
  gridCoords = new PVector[rows][cols];
  final int offset = cellSize + W_0;
  boolean down = false;
  for (int i = 0; i < rows; i++) {
    int baseY = i * H_0 * 2;
    for (int j = 0; j < cols; j++) {
      gridCoords[i][j] = new PVector(j * (cellSize + W_0), baseY + (down? H_0 : 0));
      down = !down;
    }
    if (cols % 2 == 1)
      down = !down;
  }
}

void mousePressed() {
  for (int i = 0; i < rows; i++) 
    for (int j = 0; j < cols; j++) {
       if (pow(gridCoords[i][j].x - mouseX, 2) + pow(gridCoords[i][j].y - mouseY, 2) <= cellSize * cellSize) {
          grid[i][j] = !grid[i][j];
         return; 
       }
    }
}

void draw() {
  background(255);
  //translate(100, 100);

  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      drawHexa((int) gridCoords[i][j].x, (int)gridCoords[i][j].y,grid[i][j]);
    }
  }

  //drawHexa(100, 100, false);
}

void keyPressed() {
  if (key == '+') {
    cellSize++;
    initializeGrid();
  } else if (key == '-') {
    cellSize= max(--cellSize, 4);
    initializeGrid();
  }
}

void drawHexa(int x, int y, boolean filled) {
  if (filled)
    fill(50);

  beginShape();
  vertex(x - cellSize, y);
  vertex(x-W_0, y + H_0);
  vertex(x + W_0, y + H_0);
  vertex(x + cellSize, y);
  vertex(x + W_0, y - H_0);
  vertex(x - W_0, y - H_0);
  vertex(x - cellSize, y );

  endShape();

  noFill();
}
