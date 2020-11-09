int n=4;
int[][] v=new int[20][3];
PVector[] p=new PVector[12];
PVector[][] tri;
PVector[][] tri0;
PVector[][] tri1;

void setup() {
  //size(600, 600, P3D);
  fullScreen(P3D);
  colorMode(RGB, 1);
  fill(0);
  sphereDetail(100);
  perspective(PI/3, (float)width/height, 0.1, Float.MAX_VALUE);
  for (int i=0; i<5; i++) {
    v[i]=new int[]{0, i+1, (i+1)%5+1};
  }
  for (int i=0; i<5; i++) {
    v[i+5]=new int[]{6, i+7, (i+1)%5+7};
  }
  for (int i=0; i<5; i++) {
    v[i+10]=new int[]{i+1, (i+1)%5+1, (i+8)%5+7};
  }
  for (int i=0; i<5; i++) {
    v[i+15]=new int[]{i+1, (i+7)%5+7, (i+8)%5+7};
  }
  float s=2/sqrt(5);
  float c=1/sqrt(5);
  p[0]=new PVector(0, 0, 1);
  for (int i=0; i<5; i++) {
    p[i+1]=new PVector(s*cos(i*TWO_PI/5), s*sin(i*TWO_PI/5), c);
  }
  for (int i=0; i<6; i++) {
    p[i+6]=p[i].copy().mult(-1);
  }
  for (int i=0; i<20; i++) {
    for (int j=0; j<3; j++) {
      print(nf(v[i][j], 2)+" ");
    }
    println();
  }
  tri=tri(n);
  tri0=new PVector[20][tri.length];
  tri1=new PVector[20][tri.length];
  for (int k=0; k<20; k++) {
    for (int i=0; i<tri.length; i++) {
      PVector p0=p[v[k][0]];
      PVector p1=p[v[k][1]];
      PVector p2=p[v[k][2]];
      tri0[k][i]=toSphere(tri[i][0], p0, p1, p2).copy().mult(200);
      tri1[k][i]=toSphere(tri[i][1], p0, p1, p2).copy().mult(200);
    }
  }
}

void draw() {
  println(frameRate);
  background(0);
  translate(width/2, height/2, 100+0*height/2.0/tan(PI/6));
  float rx=map(mouseY+60, 0, height, TWO_PI, 0);
  float ry=map(mouseX+160, 0, width, TWO_PI, 0);
  rotateX(rx);
  rotateY(ry);
  scale(2);
  noStroke();
  sphere(197);
  stroke(0, 1, 1);
  strokeWeight(0.5);
  for (int k=0; k<20; k++) {
    for (int i=0; i<tri.length; i++) {
      line(tri0[k][i].x, tri0[k][i].y, tri0[k][i].z, tri1[k][i].x, tri1[k][i].y, tri1[k][i].z);
    }
  }
}

PVector[][] tri(int iter) {
  PVector o=new PVector(0, 1.0/sqrt(12));
  if (iter<=0) {
    return new PVector[][]{{o.copy(), new PVector(0, 0)}, {o.copy(), new PVector(0.25, sqrt(3)/4)}, {o.copy(), new PVector(-0.25, sqrt(3)/4)}};
  }
  PVector[][] p=new PVector[3*floor(pow(4, iter))][2];
  PVector[][] q=tri(iter-1);
  PVector a=new PVector(0, sqrt(3)/2);
  PVector b=new PVector(-0.5, 0);
  PVector c=new PVector(0.5, 0);
  for (int i=0; i<q.length; i++) {
    p[i]=new PVector[]{PVector.lerp(q[i][0], a, 0.5), PVector.lerp(q[i][1], a, 0.5)};
    p[i+q.length]=new PVector[]{PVector.lerp(q[i][0], b, 0.5), PVector.lerp(q[i][1], b, 0.5)};
    p[i+2*q.length]=new PVector[]{PVector.lerp(q[i][0], c, 0.5), PVector.lerp(q[i][1], c, 0.5)};
    p[i+3*q.length]=new PVector[]{PVector.lerp(q[i][0], o, 1.5), PVector.lerp(q[i][1], o, 1.5)};
  }
  return p;
}

PVector bcc(PVector p) {
  float c3=p.y*2.0/sqrt(3);
  float c2=p.x+0.5*(1-c3);
  float c1=1-c2-c3;
  return new PVector(c1, c2, c3);
}

PVector slerp(PVector a, PVector b, float t) {
  float ang=acos(PVector.dot(a, b));
  return PVector.add(a.copy().mult(sin((1-t)*ang)), b.copy().mult(sin(t*ang))).div(sin(ang));
}

PVector toSphere(PVector q, PVector p0, PVector p1, PVector p2) {
  PVector bcc=bcc(q);
  return slerp(slerp(p0, p1, bcc.y/(bcc.x+bcc.y)), p2, bcc.z);
}
