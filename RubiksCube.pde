
import peasy.*;


// You can customize the settings here:
int dim = 3; //Change the dimension
boolean animate = true; //Toggle whether moves are animated
float speed = 50; //Change speed of animation (does nothing if animation is off)
float smaller = 0.8; //Change size of squares
int lengthrand = 40; //Change length of random scramble
boolean colorsInside = true; //Toggle between grey inside and colored inside


PeasyCam cam;
float angle = 0;
Cube cube = new Cube(dim, 50.0, smaller, colorsInside);
int axis = 0;
int number = 0;
int direction = 0;
boolean animate_start = false;
int[][] movesBack = {};
int[][] moves = new int[lengthrand][];
String allMoves = "qazwsxedcrfvtgbyhnujmik,ol.p;/QAZWSXEDCRFVTGBYHNUJMIK<OL>P:?";
boolean made = false;
boolean random_start = false;
int position = 0;
int[][] empty = {};
boolean solve_start = false;
// LEFT, RIGHT, TOP, BOTTOM, BACK, FRONT

void setup() {
  size(600, 600, P3D);
  cam = new PeasyCam(this, 600);
  cam.setMinimumDistance(10);
  cam.setMaximumDistance(1000);
}

int[][] addToFront(int[][] array, int[] element) {
  int[][] copy = new int[array.length+1][];
  copy[0] = element;
  for (int i = 0; i < array.length; i++) {
    copy[i+1] = array[i];
  }
  return copy;
}

String toUp(String s) {
  String nonletters = ";,./";
  String ups = ":<>?";
  int index = nonletters.indexOf(s);
  if (index != -1) {
    return ("" + ups.charAt(index));
  }
  return s.toUpperCase();
}

String toDown(String s) {
  String downs = ";,./";
  String nonletters = ":<>?";
  int index = nonletters.indexOf(s);
  if (index != -1) {
    return ("" + downs.charAt(index));
  }
  return s.toLowerCase();
}

int upper(char c) {
  String s = "" +c;
  if (s.equals(toUp(s))) {
    return -1;
  }
  return 1;
}

int[] firstTwo(char c) {
  String s = toUp(("" +c));
  String tops = "QWERTYUIOP";
  String middles = "ASDFGHJKL:";
  String bottoms = "ZXCVBNM<>?";
  int[] output = {0, 0};
  if (tops.indexOf(s) != -1) {
    output[0] = 0;
    output[1] = tops.indexOf(s);
  }
  if (middles.indexOf(s) != -1) {
    output[0] = 1;
    output[1] = middles.indexOf(s);
  }
  if (bottoms.indexOf(s) != -1) {
    output[0] = 2;
    output[1] = bottoms.indexOf(s);
  }
  return output;
}

void keyPressed() {
  if (!animate_start) {
    if (key == ENTER) {
      animate = !animate;
    }
    if (key == '\\' && !solve_start) {
      random_start = true;
    }
    if (key == ' ' && !random_start) {
      solve_start = true;
    }
    if (allMoves.indexOf(key) != -1 && !random_start && !solve_start) {
      turn(firstTwo(key)[0], firstTwo(key)[1], upper(key), animate);
      int[] add = {firstTwo(key)[0], firstTwo(key)[1], -upper(key)};
      movesBack = addToFront(movesBack, add);
    }
  }
}

void turn(int axis, int number, int direction, boolean animate) {
  if (animate) {
    if (!animate_start) {
      animate_start = true;
      this.axis = axis;
      this.number = number;
      this.direction = direction;
    }
  } else {
    cube.turn_ani(axis, number, direction, HALF_PI, true);
  }
}

void update() {
  if (animate_start) {
    if (angle < HALF_PI) {
      cube.turn_ani(axis, number, direction, angle, false);
      angle += speed/HALF_PI/100;
    } else {
      cube.turn_ani(axis, number, direction, HALF_PI, true);
      animate_start = false;
      angle = 0;
    }
  }
}

void draw() {
  rotateX(-PI/6+0.1);
  rotateY(-PI/4-0.3);
  rotateZ(PI/2);
  background(255);
  scale(1.15);
  cube.show();
  int[] hit = {};
  if (random_start) {
    if (!made) {
      for (int i = 0; i < lengthrand; i++) {
        int ax = int(random(3));
        int num = int(random(dim));
        int dir = int(random(2))*2-1;
        int[] addForward = {ax, num, dir};
        moves[i] = addForward;
      }
      made = true;
    }
    hit = moves[position];
    axis = hit[0];
    number = hit[1];
    direction = hit[2];
    if (animate) {
      animate_start = true;
      update();
    } else {
      animate_start = false;
      cube.turn_ani(axis, number, direction, HALF_PI, true);
    }
    if (!animate_start) {
      int[] add = {axis, number, -direction};
      movesBack = addToFront(movesBack, add);
      position++;
      if (position == lengthrand) {
        position = 0;
        random_start = false;
        made = false;
      }
    }
  } else if (solve_start) {
    if (cube.solved()) {
      solve_start = false;
    } else {
      hit = movesBack[position];
      axis = hit[0];
      number = hit[1];
      direction = hit[2];
      if (animate) {
        animate_start = true;
        update();
      } else {
        animate_start = false;
        cube.turn_ani(axis, number, direction, HALF_PI, true);
      }
      if (!animate_start) {
        position++;
        if (cube.solved()) {
          position = movesBack.length;
        }
        if (position == movesBack.length) {
          position = 0;
          solve_start = false;
          movesBack = empty;
        }
      }
    }
  } else {
    update();
  };
}
