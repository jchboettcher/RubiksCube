class Box {
  PMatrix3D matrix;
  PMatrix3D pos_matrix;
  int[] type;
  float[] pos;
  float side;
  int dim;
  color[] colors = {
    #FFFFFF, #FFFF00, 
    #0000FF, #008000, 
    #FFA500, #FF0000
  };
  float smaller;
  boolean colorsOn;

  Box(PMatrix3D m1, PMatrix3D m2, int x, int y, int z, float len, int dim, float smaller, boolean colorsOn) {
    matrix = m1;
    pos_matrix = m2;
    int[] type = {x, y, z};
    float[] pos = {x-(dim-1)*0.5, y-(dim-1)*0.5, z-(dim-1)*0.5};
    this.pos = pos;
    this.type = type;
    side = len;
    this.dim = dim;
    this.smaller = smaller;
    this.colorsOn = colorsOn;
  }

  void update(float x, float y, float z) {
    pos[0] = x;
    pos[1] = y;
    pos[2] = z;
  }

  void face(int face_, color color_) {
    int[] f = {2, 1, 1};
    fill(color_);
    if (type[int(face_/2)] == 0 && face_%2 == 0) {
      f[int(face_/2)] = 5;
    } else if (type[int(face_/2)] == dim - 1 && face_%2 == 1) {
      f[int(face_/2)] = 7;
    } else {
      return;
    }
    int[] x = {1, 1, 1, 1, 1, 1, 1, 1, 1, -1};
    int[] y = {1, 1, 1, 1, 1, 1, 1, 1, 1, -1};
    int[] z = {1, 1, 1, 1, 1, 1, 1, 1, 1, -1};
    x[f[0]] = -1;
    x[f[0]+1] = -1;
    y[f[1]+f[0]%2] = -1;
    y[f[1]+f[0]%2 + 1] = -1;
    z[f[2]] = -1;
    z[f[2]+1] = -1;
    beginShape();
    for (int i = 0; i < 5; i++) {
      vertex(-x[f[0]+2]*x[i]*smaller*0.5, -y[f[1]+2]*y[i]*smaller*0.5, -z[f[2]+2]*z[i]*smaller*0.5);
    }
    endShape();
  }

  void show() {
    pushMatrix();
    stroke(0);
    strokeWeight(2.0*dim/240);
    scale(240/dim);
    applyMatrix(matrix);
    fill(255);
    for (int i = 0; i < 6; i++) {
      face(i, colors[i]);
      if (!colorsOn) {
        push();
        pushMatrix();
        scale(0.99);
        stroke(150);
        face(i, 150);
        popMatrix();
        pop();
      }
    }
    popMatrix();
  }
}
