import java.awt.Rectangle;
import controlP5.*;
import processing.video.*;
import jp.nyatla.nyar4psg.*;
import gab.opencv.*;

SecondApplet second;
Capture cam;
MultiMarker nya_l;
PMatrix3D temp=new PMatrix3D();
PShape handle;
OpenCV opencv;
double angle_rad=PI/2;
double angle_do=90;
ArrayList<Contour> contours;
Contour contour;
int Hue_MinValue=5;
int Hue_MaxValue=20;


void settings() {
  size(640, 480, P3D);
}


void setup() {
  //String[] cams = Capture.list();
  //cam=new Capture(this,640,480, cams[1]);
  cam=new Capture(this, 640, 480);
  nya_l=new MultiMarker(this, width, height, "camera_para.dat", NyAR4PsgConfig.CONFIG_PSG);
  nya_l.addARMarker("patt.hiro", 80);
  cam.start();

  opencv = new OpenCV(this, cam.width, cam.height);

  lines=new String[100];
  lines2=new String[100];
  rank=new String[100];
  goaltimes=new String[100];
  distance=new String[100];
  lines=loadStrings("data2/test.txt");

  for (int i=0; i<lines.length; i++) {
    String[] data = lines[i].split(",", 0);
    if (data[0] == null || data[0] == "" || data[0].equals("null")) {
      break;
    }
    rank[i]=data[0];
    goaltimes[i]=data[1];
    distance[i]=data[2];
    lines2[i]=lines[i];
    println(rank[i]+", "+goaltimes[i]+", "+distance[i]);
  }

  myCar=loadImage("data2/bluecar.png");
  loadData1 = loadImage("data2/road1.JPG");
  loadData2 = loadImage("data2/road2.JPG");
  loadData3 = loadImage("data2/road3.JPG");
  hitEffect = loadImage("data2/hit.png");
  redcar=loadImage("data2/redcar.png");
  greencar=loadImage("data2/greencar.png");
  yellowcar=loadImage("data2/yellowcar.png");
  bird=loadImage("data2/bird.png");
  dog=loadImage("data2/dog.png");
  human=loadImage("data2/human.png");
  handle=loadShape("handle.obj");
  goal=loadImage("data2/goal.jpg");
  house[0]=loadImage("data2/house1.png");
  house[1]=loadImage("data2/house2.png");
  title=loadImage("data2/title.jpg");
  congura=loadImage("data2/congura.jpg");
  gameover=loadImage("data2/gameover.jpg");
  life=loadImage("data2/life.png");

  second = new SecondApplet(this);
}

void draw() {
  if (cam.available()) {
    cam.read();
    nya_l.detect(cam);
    background(0);
    nya_l.drawBackground(cam);

    if (nya_l.isExist(0)) {
      PMatrix3D temp=nya_l.getMarkerMatrix(0);
      angle_rad = atan2(temp.m10, temp.m00);
      angle_do=angle_rad*(180/PI);
      //println(angle_rad);
      //println(angle_do);
      /*
    if(angle_do>180)
       {
       angle_do=180;
       }
       if(angle_do<0)
       {
       angle_do=0;
       
       }
       */

      nya_l.beginTransform(0);
      rotateX(PI/2);
      //rotateY(PI);
      handle.setFill(color(0, 0, 0));
      shape(handle);
      nya_l.endTransform();
    }

    opencv.loadImage(cam);
    opencv.useColor(HSB);
    opencv.setGray(opencv.getH().clone());
    opencv.inRange(Hue_MinValue, Hue_MaxValue);
    PImage hsvImage = opencv.getSnapshot();
    opencv.loadImage(hsvImage);
    contours=opencv.findContours(false, true);  
    float maxsize=0;
    for (int i=0; i<contours.size(); i++) {
      Contour c=contours.get(i);  
      if (c != null && c.area()>maxsize) {
        maxsize=c.area();
        Rectangle rect=c.getBoundingBox();
        if (rect.getX()<width/4-60 && rect.getY()<height/4-60) {
          strokeWeight(2); 
          noFill();                                      
          stroke(0, 0, 255);
          c.draw();

          second.SpeedUp();
        }
      }
    }
    
    stroke(0, 0, 0);
    line(0, height/4-60, width/4-60, height/4-60);
    line(width/4-60, 0, width/4-60, height/4-60);
    fill(0, 0, 255);
    text("5second", 10, 15);
    text("speed up", 10, 30);
    text("if touch here!!", 10, 45);
  }
}

void exit() {
  shutdown();
}

void shutdown() {
  println("end"); 
  saveStrings("data2/test.txt", lines2);
  super.exit();
}
