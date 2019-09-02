final int DISPLAY_WIDTH = 1024;
final int DISPLAY_HEIGHT = 1024;
int cellSize = 25;
int W_0, H_0;

int rows, cols;

boolean[][] grid;
boolean[][] lastGrid;
PVector[][] gridCoords;
boolean[] rulesAlive;
boolean[] rulesDead;

void setup() {
  size(1024, 1024);
  loadRules();
  initializeGrid();
}

void loadRules() {
  rulesAlive = new boolean[7];
  rulesDead = new boolean[7];

  String[] rules = loadStrings("rules.txt");
  if (rules == null) {
    println("Rules file not found!");
    exit();
    return;
  }

  for (String rule : rules) {
    String[] tokens = rule.split(":");
    if (tokens.length != 3) continue;
    int neighbors = Integer.parseInt(tokens[0]);
    boolean whenDead = Integer.parseInt(tokens[1]) == 1 ? true : false;
    boolean whenAlive = Integer.parseInt(tokens[2]) == 1 ? true : false;
    if (neighbors > 6 || neighbors < 0) continue;
    rulesDead[neighbors] = whenDead;
    rulesAlive[neighbors] = whenAlive;
  }
  println("Rules loaded");
}

int countNeighbors(boolean[][] currGrid, int x, int y) { // x - rows, y - cols
  int neighbors = 0;
  if (x > 0 && currGrid[x-1][y]) neighbors++;
  if (x < rows - 1 && currGrid[x+1][y]) neighbors++;

  if (y > 0 && currGrid[x][y-1]) neighbors++;
  if (y < cols - 1 && currGrid[x][y + 1]) neighbors++;

  if (y % 2 == 0) {
    // Even... 
    if (y > 0 && x > 0 && currGrid[x-1][y-1]) neighbors++;
    if (y < cols - 1 && x > 0 && currGrid[x-1][y+1]) neighbors++;
  } else {
    if (x < rows - 1 && y > 0 && currGrid[x + 1][y-1]) neighbors++;
    if (x < rows - 1 && y < cols - 1 && currGrid[x+1][y+1]) neighbors++;
  }
  return neighbors;
}

void makeStep() {
  lastGrid = grid;
  grid = new boolean[rows][cols];
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      int neighbors = countNeighbors(lastGrid, i, j);
      grid[i][j] = lastGrid[i][j] ? rulesAlive[neighbors] : rulesDead[neighbors];
    }
  }
}

void rollBack() {
  if (lastGrid == null) return;
  grid = lastGrid;
  lastGrid = null;
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
      drawHexa((int) gridCoords[i][j].x, (int)gridCoords[i][j].y, grid[i][j]);
      //text(i + "," + j, gridCoords[i][j].x, gridCoords[i][j].y);
    }
  }

  //drawHexa(100, 100, false);
}

void keyPressed() {
  if (keyCode == UP) {
    cellSize++;
    initializeGrid();
  } else if (keyCode == DOWN) {
    cellSize= max(--cellSize, 4);
    initializeGrid();
  } else if (key == ' ') {
    makeStep();
  } else if (key == BACKSPACE) {
    rollBack();
  } else if (key == 'r') {
     grid = new boolean[rows][cols]; 
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