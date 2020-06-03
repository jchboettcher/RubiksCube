class Cube {

  Box[][][] boxes;
  int dim;
  float side;

  Cube(int dim, float side, float smaller, boolean colorsOn) {
    this.dim = dim;
    boxes = new Box[dim][dim][dim];
    for (int i = 0; i < dim; i++) {
      for (int j = 0; j < dim; j++) {
        for (int k = 0; k < dim; k++) {
          PMatrix3D m = new PMatrix3D();
          m.translate(i-(dim-1)*0.5, j-(dim-1)*0.5, k-(dim-1)*0.5);
          PMatrix3D m2 = m.get();
          boxes[i][j][k] = new Box(m, m2, i, j, k, side, dim, smaller, colorsOn);
        }
      }
    }
    this.side = side;
  }

  PMatrix3D moveToCenter(PMatrix3D matrix) {
    matrix.m03 = 0;
    matrix.m13 = 0;
    matrix.m23 = 0;
    return matrix;
  }

  void turn_ani(int axis, int number, int direction, float angle, boolean update) {
    for (int i = 0; i < dim; i++) {
      for (int j = 0; j < dim; j++) {
        for (int k = 0; k < dim; k++) {
          if (boxes[i][j][k].pos[axis] == number-(dim-1)*0.5) {
            Box box = boxes[i][j][k];
            double newX = 0;
            double newY = 0;
            double newZ = 0;
            float oldX = box.pos[0];
            float oldY = box.pos[1];
            float oldZ = box.pos[2];
            PMatrix3D copyM = box.pos_matrix.get();
            copyM = moveToCenter(copyM);
            box.matrix.reset();
            if (axis == 2) {
              box.matrix.rotate(direction*angle, 0, 0, 1);
              box.matrix.apply(copyM);
              newX = oldX * Math.cos(direction*angle) - oldY * Math.sin(direction*angle);
              newY = oldX * Math.sin(direction*angle) + oldY * Math.cos(direction*angle);
              box.matrix.translate(box.type[0]-(dim-1)*0.5, box.type[1]-(dim-1)*0.5, box.type[2]-(dim-1)*0.5);
              if (update) {
                box.update((float) Math.round(newX*2)/2, (float) Math.round(newY*2)/2, oldZ);
              }
            }
            if (axis == 1) {
              box.matrix.rotate(direction*angle, 0, 1, 0);
              box.matrix.apply(copyM);
              newX = oldX * Math.cos(direction*angle) + oldZ * Math.sin(direction*angle);
              newZ = -oldX * Math.sin(direction*angle) + oldZ * Math.cos(direction*angle);
              box.matrix.translate(box.type[0]-(dim-1)*0.5, box.type[1]-(dim-1)*0.5, box.type[2]-(dim-1)*0.5);
              if (update) {
                box.update((float) Math.round(newX*2)/2, oldY, (float) Math.round(newZ*2)/2);
              }
            }
            if (axis == 0) {
              box.matrix.rotate(direction*angle, 1, 0, 0);
              box.matrix.apply(copyM);
              newY = oldY * Math.cos(direction*angle) - oldZ * Math.sin(direction*angle);
              newZ = oldY * Math.sin(direction*angle) + oldZ * Math.cos(direction*angle);
              box.matrix.translate(box.type[0]-(dim-1)*0.5, box.type[1]-(dim-1)*0.5, box.type[2]-(dim-1)*0.5);
              if (update) {
                box.update(oldX, (float) Math.round(newY*2)/2, (float) Math.round(newZ*2)/2);
              }
            }
            if (update) {
              box.pos_matrix = box.matrix.get();
            }
          }
        }
      }
    }
  }

  boolean solved() {
    for (int i = 0; i < dim; i++) {
      for (int j = 0; j < dim; j++) {
        for (int k = 0; k < dim; k++) {
          for (int ax = 0; ax < 3; ax++) {
            if (boxes[i][j][k].pos[ax]+(dim-1)*0.5 != boxes[i][j][k].type[ax]) {
              return false;
            }
          }
        }
      }
    }
    return true;
  }

  void show() {
    for (int i = 0; i < dim; i++) {
      for (int j = 0; j < dim; j++) {
        for (int k = 0; k < dim; k++) {
          boxes[i][j][k].show();
        }
      }
    }
  }
}
