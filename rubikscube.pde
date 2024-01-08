float rotateX = 0;
float rotateY = 0;
float scale;


// Faces MUST be set up in this order or everything breaks
// we have to use final ints because enums aren't good in java
// this is the faces enum
final int FACE_UPPER = 0;
final int FACE_FRONT = 1;
final int FACE_RIGHT = 2;
final int FACE_BACK = 3;
final int FACE_LEFT = 4;
final int FACE_DOWN = 5;

color colors[] = new color[9]; 

// Not to be confused with face enum
// This enum is used to map each of the edges of a face
// to the way each square is labeled during setup
// Imagine a face labeled like so:
// 0 1 2
// 3 4 5
// 6 7 8
// EDGE_RIGHT, refers to { 2, 5, 8 }
// EDGE_DOWN, refers to { 6, 7, 8 }
// we have to use final ints because enums aren't good in java
// this is the edges enum
final int EDGE_UPPER = 0;
final int EDGE_LEFT = 1;
final int EDGE_DOWN = 2;
final int EDGE_RIGHT = 3;

int[] get_edge(int face, int edge, boolean reversed) {
  int offset = 9*face;
  int ret[] = new int[3];
  switch (edge) {
    case EDGE_UPPER:
    ret[0] = squares[offset+0];
    ret[1] = squares[offset+1];
    ret[2] = squares[offset+2];
    break;
    case EDGE_LEFT:
    ret[0] = squares[offset+0];
    ret[1] = squares[offset+3];
    ret[2] = squares[offset+6];
    break;
    case EDGE_DOWN:
    ret[0] = squares[offset+6];
    ret[1] = squares[offset+7];
    ret[2] = squares[offset+8];
    break;
    case EDGE_RIGHT:
    ret[0] = squares[offset+2];
    ret[1] = squares[offset+5];
    ret[2] = squares[offset+8];
    break;
  }
  
  if (reversed) {
    int tmp = ret[0];
    ret[0] = ret[2];
    ret[2] = tmp;
  }
  
  return ret;
}

void set_edge(int face, int edge, boolean reversed, int[] new_edge) {
  int offset = 9*face;
  if (reversed) {
    int tmp = new_edge[0];
    new_edge[0] = new_edge[2];
    new_edge[2] = tmp;
  }
  
  switch (edge) {
    case EDGE_UPPER:
    squares[offset+0] = new_edge[0];
    squares[offset+1] = new_edge[1];
    squares[offset+2] = new_edge[2];
    break;
    case EDGE_LEFT:
    squares[offset+0] = new_edge[0];
    squares[offset+3] = new_edge[1];
    squares[offset+6] = new_edge[2];
    break;
    case EDGE_DOWN:
    squares[offset+6] = new_edge[0];
    squares[offset+7] = new_edge[1];
    squares[offset+8] = new_edge[2];
    break;
    case EDGE_RIGHT:
    squares[offset+2] = new_edge[0];
    squares[offset+5] = new_edge[1];
    squares[offset+8] = new_edge[2];
    break;
  }
}

int squares[] = new int[54];

// rotates the 9 sqauares of a face clockwise
// Faces are labeled in reading order as such:
// 0 1 2
// 3 4 5
// 6 7 8
// This function performs the following transformation
// 6 3 0
// 7 4 1
// 8 5 2
void rotateSquaresClockwise(int face) {
  // get the index in the squares array we want to start at
  int offset = face * 9;
  int tmp[] = new int[9];
  int tmp2[] = new int[9];
  arrayCopy(squares, offset, tmp, 0, 9);
  tmp2[0] = tmp[6];
  tmp2[1] = tmp[3];
  tmp2[2] = tmp[0];
  tmp2[3] = tmp[7];
  tmp2[4] = tmp[4];
  tmp2[5] = tmp[1];
  tmp2[6] = tmp[8];
  tmp2[7] = tmp[5];
  tmp2[8] = tmp[2];
  
  // apply the change
  arrayCopy(tmp2, 0, squares, offset, 9);
}

// rotates the 9 sqauares of a face counterclockwise
// Faces are labeled in reading order as such:
// 0 1 2
// 3 4 5
// 6 7 8
// This function performs the following transformation
// 2 5 8
// 1 4 7
// 0 3 6
void rotateSquaresCounterclockwise(int face) {
  int offset = face * 9;
  int tmp[] = new int[9];
  int tmp2[] = new int[9];
  arrayCopy(squares, offset, tmp, 0, 9);
  tmp2[0] = tmp[2];
  tmp2[1] = tmp[5];
  tmp2[2] = tmp[8];
  tmp2[3] = tmp[1];
  tmp2[4] = tmp[4];
  tmp2[5] = tmp[7];
  tmp2[6] = tmp[0];
  tmp2[7] = tmp[3];
  tmp2[8] = tmp[6];
  
  // apply the change
  arrayCopy(tmp2, 0, squares, offset, 9);
}

void rotateFaceClockwise(int face) {
  rotateSquaresClockwise(face);
  
  //print("retrieving map " + face + "\n");
  EdgeMap map = edge_map[face];
  EdgePairing pair_u = map.pair[EDGE_UPPER];
  EdgePairing pair_l = map.pair[EDGE_LEFT];
  EdgePairing pair_d = map.pair[EDGE_DOWN];
  EdgePairing pair_r = map.pair[EDGE_RIGHT];
  //print("Upper edge paired face is " + map.pair[EDGE_UPPER].target_face + "\n");
  int u[] = get_edge(pair_u.target_face, pair_u.target_edge, pair_u.reversed);
  int l[] = get_edge(pair_l.target_face, pair_l.target_edge, pair_l.reversed);
  int d[] = get_edge(pair_d.target_face, pair_d.target_edge, pair_d.reversed);
  int r[] = get_edge(pair_r.target_face, pair_r.target_edge, pair_r.reversed);
  
  //print("U mapped edge is " + u[0] + "," + u[1] + "," + u[2] + "\n");
  set_edge(pair_u.target_face, pair_u.target_edge, pair_u.reversed,l);
  set_edge(pair_l.target_face, pair_l.target_edge, pair_l.reversed,d);
  set_edge(pair_d.target_face, pair_d.target_edge, pair_d.reversed,r);
  set_edge(pair_r.target_face, pair_r.target_edge, pair_r.reversed,u);
}

void rotateFaceCounterclockwise(int face) {
  rotateSquaresCounterclockwise(face); 
  EdgeMap map = edge_map[face];
 
  EdgePairing pair_u = map.pair[EDGE_UPPER];
  EdgePairing pair_l = map.pair[EDGE_LEFT];
  EdgePairing pair_d = map.pair[EDGE_DOWN];
  EdgePairing pair_r = map.pair[EDGE_RIGHT];
  //print("Upper edge paired face is " + map.pair[EDGE_UPPER].target_face + "\n");
  int u[] = get_edge(pair_u.target_face, pair_u.target_edge, pair_u.reversed);
  int l[] = get_edge(pair_l.target_face, pair_l.target_edge, pair_l.reversed);
  int d[] = get_edge(pair_d.target_face, pair_d.target_edge, pair_d.reversed);
  int r[] = get_edge(pair_r.target_face, pair_r.target_edge, pair_r.reversed);
  
  //print("U mapped edge is " + u[0] + "," + u[1] + "," + u[2] + "\n");
  set_edge(pair_u.target_face, pair_u.target_edge, pair_u.reversed,r);
  set_edge(pair_l.target_face, pair_l.target_edge, pair_l.reversed,u);
  set_edge(pair_d.target_face, pair_d.target_edge, pair_d.reversed,l);
  set_edge(pair_r.target_face, pair_r.target_edge, pair_r.reversed,d);
}

void setup_face(int face) {
  int size = 3;
  int offset = face * 9;
  for (int y=0; y<size; y++) {
    for (int x = 0; x<size; x++) {
      fill(colors[squares[offset++]]);
      rect(x*scale/size, y*scale/size, scale/size, scale/size);
      //fill(0);
      //textSize(30);
      //String s = "" + (offset-1);
      //text(s, x*scale/size+scale/size/2, y*scale/size+scale/size/2);
    }
  }
}

void drawRubiks() {
  // set up upper face first 
  pushMatrix();
  rotateX(PI/2);
  translate(-scale/2,-scale/2,scale/2);
  setup_face(FACE_UPPER);
  popMatrix();
  
  int cur_face = FACE_FRONT;
  for (int i=0; i<4; i++) {
    pushMatrix();
    rotateY(i*PI/2);
    translate(-scale/2,-scale/2,scale/2);
    setup_face(cur_face++);
    popMatrix();
  }
  
  pushMatrix();
  rotateX(-PI/2);
  translate(-scale/2,-scale/2,scale/2);
  setup_face(FACE_DOWN);
  popMatrix();
}

void draw() {
  translate(width/2, height/2, 0); 
  rotateX(rotateX);
  rotateY(rotateY);
  background(100);
  drawRubiks();
}

void setup_solved() {
  // Iterate across 6 faces
  for (int face=0; face<6; face++) {
    // iterate across 9 squares
    for (int square=0; square<9; square++) {
      // the value of each square corresponds to a color's index
      // colors in the color array are already indexed to the default solved cube configuration
      // set each square's color equal to the index of it's face
      squares[9*face+square] = face;
    }
  }
}

// randomizes the colors
// does NOT result in a solvable cube
void setup_random() {
  for (int i=0; i<squares.length; i++) {
    squares[i] = int(random(0,6));
  }
}

void scramble() {
  for(int i=0; i<20; i++) {
    int r = int(random(0,2));
    if (r==0) {
      rotateFaceClockwise(int(random(0,6)));
    } else {
      rotateFaceCounterclockwise(int(random(0,6)));
    }
  }
}

class EdgePairing {
  int target_face;
  int target_edge;
  boolean reversed;
}

class EdgeMap {
  EdgePairing pair[];
}

EdgeMap edge_map[];

// in order to correctly rotate a face, the 4 adjacent faces must swap edges
// we must create a mapping between adjacent faces that tells us which edges are touching
void setup_edge_maps() {
  edge_map = new EdgeMap[6]; // six faces
  for (int i=0; i<6; i++) {
    edge_map[i] = new EdgeMap();
    edge_map[i].pair = new EdgePairing[4]; // four edges per face
    for (int j=0; j<4; j++) {
        edge_map[i].pair[j] = new EdgePairing();
    }
  }
  
  edge_map[FACE_UPPER].pair[EDGE_LEFT].target_face = FACE_LEFT;
  edge_map[FACE_UPPER].pair[EDGE_LEFT].target_edge = EDGE_UPPER;
  edge_map[FACE_UPPER].pair[EDGE_UPPER].target_face = FACE_BACK;
  edge_map[FACE_UPPER].pair[EDGE_UPPER].target_edge = EDGE_UPPER;
  edge_map[FACE_UPPER].pair[EDGE_RIGHT].target_face = FACE_RIGHT;
  edge_map[FACE_UPPER].pair[EDGE_RIGHT].target_edge = EDGE_UPPER;
  edge_map[FACE_UPPER].pair[EDGE_DOWN].target_face = FACE_FRONT;
  edge_map[FACE_UPPER].pair[EDGE_DOWN].target_edge = EDGE_UPPER;
  
  edge_map[FACE_FRONT].pair[EDGE_LEFT].target_face = FACE_LEFT;
  edge_map[FACE_FRONT].pair[EDGE_LEFT].target_edge = EDGE_RIGHT;
  edge_map[FACE_FRONT].pair[EDGE_LEFT].reversed = true;
  edge_map[FACE_FRONT].pair[EDGE_UPPER].target_face = FACE_UPPER;
  edge_map[FACE_FRONT].pair[EDGE_UPPER].target_edge = EDGE_DOWN;
  edge_map[FACE_FRONT].pair[EDGE_RIGHT].target_face = FACE_RIGHT;
  edge_map[FACE_FRONT].pair[EDGE_RIGHT].target_edge = EDGE_LEFT;
  edge_map[FACE_FRONT].pair[EDGE_DOWN].target_face = FACE_DOWN;
  edge_map[FACE_FRONT].pair[EDGE_DOWN].target_edge = EDGE_UPPER;
  edge_map[FACE_FRONT].pair[EDGE_DOWN].reversed = true;
  
  edge_map[FACE_RIGHT].pair[EDGE_LEFT].target_face = FACE_FRONT;
  edge_map[FACE_RIGHT].pair[EDGE_LEFT].target_edge = EDGE_RIGHT;
  edge_map[FACE_RIGHT].pair[EDGE_UPPER].target_face = FACE_UPPER;
  edge_map[FACE_RIGHT].pair[EDGE_UPPER].target_edge = EDGE_RIGHT;
  edge_map[FACE_RIGHT].pair[EDGE_RIGHT].target_face = FACE_BACK;
  edge_map[FACE_RIGHT].pair[EDGE_RIGHT].target_edge = EDGE_LEFT;
  edge_map[FACE_RIGHT].pair[EDGE_RIGHT].reversed = true;
  edge_map[FACE_RIGHT].pair[EDGE_DOWN].target_face = FACE_DOWN;
  edge_map[FACE_RIGHT].pair[EDGE_DOWN].target_edge = EDGE_RIGHT;
  
  edge_map[FACE_BACK].pair[EDGE_LEFT].target_face = FACE_RIGHT;
  edge_map[FACE_BACK].pair[EDGE_LEFT].target_edge = EDGE_RIGHT;
  edge_map[FACE_BACK].pair[EDGE_UPPER].target_face = FACE_UPPER;
  edge_map[FACE_BACK].pair[EDGE_UPPER].target_edge = EDGE_UPPER;
  edge_map[FACE_BACK].pair[EDGE_RIGHT].target_face = FACE_LEFT;
  edge_map[FACE_BACK].pair[EDGE_RIGHT].target_edge = EDGE_LEFT;
  edge_map[FACE_BACK].pair[EDGE_RIGHT].reversed = true;
  edge_map[FACE_BACK].pair[EDGE_DOWN].target_face = FACE_DOWN;
  edge_map[FACE_BACK].pair[EDGE_DOWN].target_edge = EDGE_DOWN;
  edge_map[FACE_BACK].pair[EDGE_DOWN].reversed = true;
  
  edge_map[FACE_LEFT].pair[EDGE_LEFT].target_face = FACE_BACK;
  edge_map[FACE_LEFT].pair[EDGE_LEFT].target_edge = EDGE_RIGHT;
  edge_map[FACE_LEFT].pair[EDGE_LEFT].reversed = true;
  edge_map[FACE_LEFT].pair[EDGE_UPPER].target_face = FACE_UPPER;
  edge_map[FACE_LEFT].pair[EDGE_UPPER].target_edge = EDGE_LEFT;
  edge_map[FACE_LEFT].pair[EDGE_RIGHT].target_face = FACE_FRONT;
  edge_map[FACE_LEFT].pair[EDGE_RIGHT].target_edge = EDGE_LEFT;
  edge_map[FACE_LEFT].pair[EDGE_DOWN].target_face = FACE_DOWN;
  edge_map[FACE_LEFT].pair[EDGE_DOWN].target_edge = EDGE_LEFT;
  
  edge_map[FACE_DOWN].pair[EDGE_LEFT].target_face = FACE_LEFT;
  edge_map[FACE_DOWN].pair[EDGE_LEFT].target_edge = EDGE_DOWN;
  edge_map[FACE_DOWN].pair[EDGE_UPPER].target_face = FACE_FRONT;
  edge_map[FACE_DOWN].pair[EDGE_UPPER].target_edge = EDGE_DOWN;
  edge_map[FACE_DOWN].pair[EDGE_RIGHT].target_face = FACE_RIGHT;
  edge_map[FACE_DOWN].pair[EDGE_RIGHT].target_edge = EDGE_DOWN;
  edge_map[FACE_DOWN].pair[EDGE_DOWN].target_face = FACE_BACK;
  edge_map[FACE_DOWN].pair[EDGE_DOWN].target_edge = EDGE_DOWN;
  
}


void setup() {
  // setup default colors
  colors[FACE_UPPER] = color(0xFF,0xFF,0); //yellow
  colors[FACE_DOWN] = color(0xFF,0xFF,0xFF); // white  
  colors[FACE_FRONT] = color(0,0xFF,0); //green
  colors[FACE_RIGHT] = color(0xFF,0xA5,0x00); //orange
  colors[FACE_BACK] = color(0x30,0x80,0xFF); //blue
  colors[FACE_LEFT] = color(0xFF,0,0); //red
  
  setup_edge_maps();
  
  size(600,600,P3D);
  fill(255);
  ortho();
  box(300);
  scale = width/2;
  setup_solved();
  //setup_random();
}

void mouseDragged() {
  float dy = mouseX - pmouseX;
  float dx = mouseY - pmouseY;
  
  // Y axis is flippped from the perspective of the mouse
  rotateX = rotateX - dx/100;
  rotateY = rotateY + dy/100;
}

void mouseClicked() {
  if (mouseButton == RIGHT) {
    rotateFaceClockwise(FACE_UPPER);
  } else {
    rotateFaceCounterclockwise(FACE_UPPER);
  }
}

void keyPressed() {
  switch (key) {
    case 'u':
    rotateFaceClockwise(FACE_UPPER);
    break;
    case 'U':
    rotateFaceCounterclockwise(FACE_UPPER);
    break;
    case 'r':
    rotateFaceClockwise(FACE_RIGHT);
    break;
    case 'R':
    rotateFaceCounterclockwise(FACE_RIGHT);
    break;
    case 'l':
    rotateFaceClockwise(FACE_LEFT);
    break;
    case 'L':
    rotateFaceCounterclockwise(FACE_LEFT);
    break;
    case 'f':
    rotateFaceClockwise(FACE_FRONT);
    break;
    case 'F':
    rotateFaceCounterclockwise(FACE_FRONT);
    break;
    case 'b':
    rotateFaceClockwise(FACE_BACK);
    break;
    case 'B':
    rotateFaceCounterclockwise(FACE_BACK);
    break;
    case 'd':
    rotateFaceClockwise(FACE_DOWN);
    break;
    case 'D':
    rotateFaceCounterclockwise(FACE_DOWN);
    break;
    case 'n':
    scramble();
    break;
  }
}
