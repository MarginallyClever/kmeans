// k-means clustering demo
// 2019-11-09 dan@marginallyclever.com
// CC-BY-NC-SA


// CONSTANTS
final int NUM_POINTS = 20000;
final int NUM_CLUSTERS = 30;


// STRUCTURES
class Point2D {
  public float x,y;
  int cluster;
  
  Point2D(float xx,float yy) {
    x=xx;
    y=yy;
  }
}


// GLOBALS
Point2D [] points;
Point2D [] clusters;
float r,g,b;  // cluster color;


// METHODS
void setup() {
  size(800,800);
  
  points = new Point2D[NUM_POINTS];
  for(int i=0;i<points.length;++i) {
    points[i] = new Point2D(random(width),random(height));
  }

  clusters = new Point2D[NUM_CLUSTERS];
  for(int j=0;j<clusters.length;++j) {
    clusters[j] = new Point2D(random(width),random(height));
  }
}


// Give j [0....NUM_CLUSTERS-1]
// sets globals {r,g,b} to a rainbow color.
void clusterColor(int j) {
  float v = (float)(j+1) / (float)NUM_CLUSTERS; // (0...1]

  if(false) {
    // naive
    long c = (long)(v*(float)0xffffff);
    r = (c>>16)&0xff;
    g = (c>> 8)&0xff;
    b = (c    )&0xff;
  } else {
    // index as hsv to rgb
    // https://en.wikipedia.org/wiki/HSL_and_HSV#HSV_to_RGB
    // Assume Hue=v/360, saturation=1, value=1.
    float C = 1;// C=V*S
    float H = v*6;
    float X = C * (1-abs((H % 2) - 1));
         if(H<1) { r=C; g=X; b=0; }
    else if(H<2) { r=X; g=C; b=0; }
    else if(H<3) { r=0; g=C; b=X; }
    else if(H<4) { r=0; g=X; b=C; }
    else if(H<5) { r=X; g=0; b=C; }
    else         { r=C; g=0; b=X; }  // H<6
    r*=255;
    g*=255;
    b*=255;
  }
}


void draw() {
  assignClusters();
  adjustClusters();
  background(0);
  
  // the clusters
  strokeWeight(4);
  for(int j=0;j<clusters.length;++j) {
    clusterColor(j);
    stroke(r,g,b);
    point(clusters[j].x,clusters[j].y);
  }
  
  // the points in those clusters
  stroke(0);
  fill(0);
  strokeWeight(1);
  for(int i=0;i<points.length;++i) {
    clusterColor(points[i].cluster);
    stroke(r/2,g/2,b/2);
    point(points[i].x,points[i].y);
  }
}

float distance2(Point2D a,Point2D b) {
  float dx=a.x-b.x;
  float dy=a.y-b.y;
  
  return dx*dx+dy*dy; 
}


void assignClusters() {
  for(int i=0;i<points.length;++i) {
    double minLen = distance2(clusters[0],points[i]);
    int minIndex=0;
    for(int j=1;j<clusters.length;++j) {
      double len = distance2(clusters[j],points[i]);
      if(minLen > len) {
        minLen=len;
        minIndex=j;
      }
    }
    points[i].cluster=minIndex;
  }
}

void adjustClusters() {
  for(int j=0;j<clusters.length;++j) {
    float x=0,y=0;
    int sum=0;
    for(int i=0;i<points.length;++i) {
      if(points[i].cluster==j) {
        x+=points[i].x;
        y+=points[i].y;
        sum++;
      }
    }
    if(sum<1) sum=1;
    clusters[j].x=x/sum;
    clusters[j].y=y/sum;
  }
}
