import java.awt.Rectangle;
import controlP5.*;
import processing.video.*;
import jp.nyatla.nyar4psg.*;
import gab.opencv.*;


PImage load1, load2;
PImage loadData1, loadData2, loadData3;
PImage myCar;
PImage redcar, greencar, yellowcar, bird, dog, human;
PImage goal;
PImage[] house=new PImage[2];
int house1x, house1y, house2x, house2y, house3x, house3y;
int goalPos;
int load1YPos, load2YPos;
int isUnderImageFlag;
int moveDis;
int moveDisBuff;
int myCarmoveDis;
int myCarPosX, myCarPosY, myCarW, myCarH, myCarCenterX, myCarCenterY;
int gameW, gameH;
PImage hitEffect;
int timer;
int startTime;
int stopTimeFlag;
String[] lines, lines2;
String[] rank;
String[] goaltimes;
String[] distance;
int isGoal;
int goalTime;
int gameCtrl=0;
PImage title, congura, gameover;
int speedUpTime, isSpeedUp;
int isStop;
int SpeedUpDis;
int hp;
PImage life;
int gameoverTime;
int isGameover;
int ddd=0;
int scoretime=0;
int isSetRank=0;
int isRank=-1;
int isSetRank2=0;


class SecondApplet extends PApplet {
  PApplet parent;
  Obstacle[] o = new Obstacle[3];
  Obstacle[] data = new Obstacle[6];
  Obstacle[] data2 = new Obstacle[6];

  SecondApplet(PApplet _parent) {
    super();
    this.parent = _parent;
    try {
      java.lang.reflect.Method handleSettingsMethod =
        this.getClass().getSuperclass().getDeclaredMethod("handleSettings", null);
      handleSettingsMethod.setAccessible(true);
      handleSettingsMethod.invoke(this, null);
    } 
    catch (Exception ex) {
      ex.printStackTrace();
    }

    PSurface surface = super.initSurface();
    surface.placeWindow(new int[]{50, 50}, new int[]{0, 0});
    this.showSurface();
    this.startSurface();
  }


  void settings() {
    size(600, 600);
  }


  void setup() {
    isGameover=0;
    hp=5;
    SpeedUpDis=15;
    isStop=0;
    isSpeedUp=0;
    speedUpTime=-1;
    isGoal=0;
    goalPos=-25000;
    isUnderImageFlag=1;
    moveDis=10;
    myCarmoveDis=20;
    gameW=600;
    gameH=600;
    stopTimeFlag=-1;
    moveDisBuff=moveDis;
    myCarW=70;
    myCarH=70;
    load1=loadData1;
    load2=loadData2;
    
    load1YPos=-(load1.height-height);
    load2YPos=load1YPos-load2.height;
    myCarPosX=gameW/2-myCarW/2;
    myCarPosY=gameH-myCarH;
    myCarCenterX=myCarPosX+myCarW/2;
    myCarCenterY=gameH-myCarH/2;

    data[0]=new Obstacle(0, 0, 70, 70, redcar, 0, moveDisBuff+1);
    data[1]=new Obstacle(0, 0, 70, 70, greencar, 0, moveDisBuff+1);
    data[2]=new Obstacle(0, 0, 70, 70, yellowcar, 0, moveDisBuff+1);
    data[3]=new Obstacle(0, 0, 70, 70, human, -1, moveDisBuff-5);
    data[4]=new Obstacle(0, 0, 70, 70, bird, 0, moveDisBuff+5);
    data[5]=new Obstacle(0, 0, 70, 70, dog, 7, moveDisBuff-3);
    data2=data;

    int buff=0;
    for (int i=0; i<o.length; i++) {
      int r=(int)random(0, 6);
      int x=(int)random(1, 6);
      buff-=data[r].h*2+10;
      o[i]=new Obstacle(80*x+(x-1)*10+5, buff, data[r].w, data[r].h, data[r].image, data[r].deltaX, data[r].deltaY);
      o[i].show();
    }

    house1x=10; 
    house1y=-70;
    house2x=gameW-70-10; 
    house2y=house1y-(height-70*3)/3;
    house3x=10; 
    house3y=house2y-(height-70*3)/3;
  }

  void draw() {
    if (gameCtrl==0) {
      image(title, 0, 0, gameW, gameH);
      fill(255, 0, 0);
      textSize(15);
      text("Start if ENTER key pressed", gameW/2-100, gameH-100);
    } 
    
    else if (gameCtrl==1) {
      if (startTime>=0) {
        ddd+=moveDis;
        load1YPos+=moveDis;
        load2YPos+=moveDis;
        if (isUnderImageFlag==1 && load1YPos>gameH) {
          int rand=(int)random(0.0, 3.0);
          if (rand==0)load1=loadData1;
          else if (rand==1) load1=loadData2;
          else load1=loadData3;
          load1YPos=load2YPos-load1.height;
          isUnderImageFlag=2;
        }
        if (isUnderImageFlag==2 && load2YPos>gameH) {
          load2YPos=load1YPos-load2.height;
          isUnderImageFlag=1;
          int rand=(int)random(0.0, 3.0);
          if (rand==0)load2=loadData1;
          else if (rand==1) load2=loadData2;
          else load1=loadData3;
        }

        if (moveDis>0) {
          if (keyPressed) {
            /*
            if (keyCode==RIGHT) {
              myCarPosX+=myCarmoveDis; 
              myCarCenterX=myCarPosX+myCarW/2;
            } 
            if (keyCode==LEFT) {
              myCarPosX-=myCarmoveDis; 
              myCarCenterX=myCarPosX+myCarW/2;
            }
            */
          }

          //println(angle_do);
          if (angle_do>=0 && angle_do<90) {
            float per=1-(float)angle_do/90;
            myCarPosX+=myCarmoveDis*per;
            myCarCenterX=myCarPosX+myCarW/2;
          } else if (angle_do>90 && angle_do<=180) {
            float per=(float)(angle_do-90)/90;
            myCarPosX-=myCarmoveDis*per;
            myCarCenterX=myCarPosX+myCarW/2;
          }

          if (myCarPosX<80) {
            myCarPosX=80;
          }
          if (myCarPosX+myCarW>gameW-80) {
            myCarPosX=gameW-80-myCarW;
          }
        }
        image(load1, 0, load1YPos, gameW, load1.height);
        image(load2, 0, load2YPos, gameW, load2.height);

        for (int i=0; i<o.length; i++) {
          o[i].move();
          o[i].show();
        }
        image(myCar, myCarPosX, myCarPosY, myCarW, myCarH);

        for (int i=0; i<o.length; i++) {
          if (o[i].hitCheck()==1) {
            println("hit");
            stopTimeFlag=millis();
            hp-=1;
            Stop();
          }
        }

        house1y+=moveDis;
        house2y+=moveDis;
        house3y+=moveDis;
        image(house[0], house1x, house1y, 70, 70);
        image(house[1], house2x, house2y, 70, 70);
        image(house[0], house3x, house3y, 70, 70);
        if (house1y>gameH) {
          house1y-=height+70;
          int r=(int)random(0, 2);
          if (r==0)house1x=10;
          else house1x=gameW-70-10;
        }
        if (house2y>gameH) {
          house2y-=height+70;
          int r=(int)random(0, 2);
          if (r==0)house2x=10;
          else house2x=gameW-70-10;
        }
        if (house3y>gameH) {
          house3y-=height+70;
          int r=(int)random(0, 2);
          if (r==0)house3x=10;
          else house3x=gameW-70-10;
        }

        timer=millis();
        fill(255, 0, 0);
        textSize(10);
        if (isGoal==0)text((timer-startTime)/1000, 10, 10);
        else text((goalTime-startTime)/1000, 10, 10);

        if (isSpeedUp==1) {
          if (isStop==0) {
            speedUpTime=timer;
            for (int i=0; i<o.length; i++) {
              o[i].deltaY+=SpeedUpDis;
            }
            moveDis=moveDisBuff+SpeedUpDis;
            isSpeedUp=2;
            println("speedup");
          } else if (isStop==1) {
            isSpeedUp=0; 
            println("not speedup");
          }
        } else if (isSpeedUp==2 && (timer-speedUpTime)>5000) {
          moveDis=moveDisBuff;
          for (int i=0; i<data.length; i++) {
            data[i].deltaY=data2[i].deltaY;
          }
          for (int i=0; i<o.length; i++) {
            for (int j=0; j<data2.length; j++) {
              if (o[i].image==data2[j].image) {
                o[i].deltaY=data2[j].deltaY;
              }
            }
          }
          isSpeedUp=0;
          println("end speedup");
        } else if (isSpeedUp==2) {
          for (int i=0; i<o.length; i++) {
            for (int j=0; j<data2.length; j++) {
              if (o[i].image==data2[j].image) {
                o[i].deltaY=data2[j].deltaY+SpeedUpDis;
              }
            }
          }
        }

        if (timer-stopTimeFlag>1000 && isGoal==0 && isStop==1) {
          ReStart();
        } else if (isStop==1) {
          image(hitEffect, myCarCenterX-15, myCarPosY-15, 30, 30);
        }
        goalPos+=moveDis;
        image(goal, 0, goalPos, gameW, 50);
        if (isGoal()==1) {
          goalTime=timer;
          scoretime=goalTime-startTime;
          GameEnd();
        }
        if (isGoal==1) {
          println("goal!");

          image(congura, 0, gameH/2, gameW, 50);
          if ((timer-goalTime)>5000) {
            gameCtrl=2;
            GameReset();
          }
        }

        if (hp<=0 && isGameover==0) {
          isGameover=1;
          gameoverTime=timer;
          GameEnd();
        }
        if (isGameover==1) {
          image(gameover, 0, gameH/2, gameW, 50); 
          GameEnd();
        }
        if ((timer-gameoverTime)>5000 && hp<=0 && isGameover==1) {
          gameCtrl=2;
          GameReset();
        }
        textSize(15);
        text("HP", gameW-90, 20);
        for (int i=0; i<hp; i++) {
          image(life, gameW-30-i*(10+5), 30, 10, 10);
        }
      }
    } else if (gameCtrl==2) {
      background(0);
      int y=30;
      textSize(15);


      for (int i=1; i<100-1; i++) {
        if (isSetRank==0) {
          if (scoretime>0 && goaltimes[i]!="-" && goaltimes[i]!=null && float(goaltimes[i])>=scoretime/1000) {
            for (int j=100-1; j>i; j--) {
              goaltimes[j]=goaltimes[j-1];
              distance[j]=distance[j-1];
            }
            goaltimes[i]=str((float)scoretime/1000);
            distance[i]="-";
            isRank=i;
            break;
          } else if (scoretime<=0 && !distance[i].equals("-") && distance[i]!=null && int(distance[i])<=ddd) {
            for (int j=100-1; j>i; j--) {
              goaltimes[j]=goaltimes[j-1];
              distance[j]=distance[j-1];
            }
            goaltimes[i]="-";
            distance[i]=str(ddd);
            isRank=i;
            break;
          }
        }
      }
      isSetRank=1;
      int x1=30, x2=100, x3=240;

      for (int i=0; i<100-1; i++) {
        if (goaltimes[i]==null)break;
        if (isRank==i) {
          fill(0, 255, 0);
        } else fill(255, 255, 255);

        if (rank[i]==null)rank[i]=str(i);
        if (i<11 || isRank==i) {
          if (isRank==i && i>11) {
            text(rank[i], x1, 400);
            text(goaltimes[i], x2, 400);
            text(distance[i], x3, 400);
            fill(0, 0, 255); 
            text("<-- your ranking", 350, 400);
          } else {
            text(rank[i], x1, y);
            text(goaltimes[i], x2, y);
            text(distance[i], x3, y);
            if (isRank==i)text("<-- your ranking", 350, y);
          }
        }
        y+=30;
      }

      fill(255, 0, 0);
      textSize(15);
      text("Go back title if ENTER key pressed", gameW/2-200, gameH-100);

      if (isSetRank2==0) {
        isSetRank2=1;
        for (int x=0; x<100-1; x++) {
          if (goaltimes[x]==null)break;

          if (rank[x]==null)rank[x]=str(x);
          println(x);
          lines2[x]=rank[x]+","+goaltimes[x]+","+distance[x];
          println(lines2[x]);
        }
      }
    }
  }

  int isGoal() {
    int result=0;
    Rectangle r=new Rectangle(0, goalPos, gameW, 50);
    if (isGoal==0 && (r.contains(myCarPosX, myCarPosY) || r.contains(myCarPosX, myCarPosY+myCarH) || r.contains(myCarPosX+myCarW, myCarPosY+myCarH) || r.contains(myCarPosX+myCarW, myCarPosY))) {
      isGoal=1; 
      result=1;
    }
    return result;
  }
  void keyReleased() {
    if (keyCode==ENTER && gameCtrl==0)Start();  
    else if (keyCode==ENTER && gameCtrl==2)Title();
  }
  void Start() {
    gameCtrl=1;
    startTime=millis();
  }
  void Stop() {
    if (moveDis != 0) {
      moveDis=0; 
      isStop=1;
    } else ReStart();
  }
  void ReStart() {
    isStop=0;
    isSpeedUp=0;
    moveDis=moveDisBuff;
  }
  void GameEnd() {
    moveDis=0;
  }

  void GameReset() {
    setup();
  }

  void Title() {
    ddd=0;
    scoretime=0;
    isSetRank=0;
    isRank=-1;
    isSetRank2=0;
    gameCtrl=0;
  }

  void SpeedUp() {
    if (gameCtrl!=1)return;

    if (isSpeedUp==0) {
      isSpeedUp=1;
    }
  }
  void exit() {
    shutdown();
  }

  class Obstacle {
    int x, y, w, h, deltaX, deltaY;
    int centerX, centerY;
    PImage image;
    int isHit=0;
    Rectangle r;

    Obstacle(int xpos, int ypos, int wid, int hei, PImage i, int dx, int dy) {
      x=xpos;
      y=ypos;
      w=wid;
      h=hei;
      centerX=x+w/2;
      centerY=y+h/2;
      image=i;
      deltaX=dx;
      deltaY=dy;
      r=new Rectangle(x, y, w, h);
    }

    void ChangeY(int delta) {
      y+=delta;
      centerY=y+h/2;
      r.y=y;
    }
    void ChangeX(int delta) {
      x+=delta;
      centerX=x+w/2;
      r.x=x;

      if (x<0 || x+w>gameW) {
        deltaX=-deltaX;
      }
    }

    void move() {
      if (moveDis > 0) {
        ChangeX(deltaX);
        ChangeY(deltaY);
        if (y>height+10) {
          int r=(int)random(0, 100);
          if (r>=0 && r<20)r=0;
          else if (r>=20 && r<40)r=1;
          else if (r>=40 && r<60)r=2;
          else if (r>=60 && r<80)r=4;
          else if (r>=80 && r<90)r=3;
          else if (r>=90 && r<100)r=5;
          reset(data[r].w, data[r].h, data[r].image, data[r].deltaX, data[r].deltaY);
        }
      }
    }

    void reset(int wid, int hei, PImage i, int dx, int dy) {
      w=wid;
      h=hei;
      centerX=x+w/2;
      centerY=y+h/2;
      image=i;
      deltaX=dx;
      deltaY=dy;
      r=new Rectangle(x, y, w, h);

      ChangeY(-height-h);
      x=(int)random(1, 6);
      x=80*x+(x-1)*10+5;
      r.x=x;
    }

    void show() {
      if (deltaX>0) {
        scale(-1, 1); 
        image(image, -x, y, -w, h); 
        scale(-1, 1);
      } else image(image, x, y, w, h);
    }

    int hitCheck() {
      if (y>gameH || (y+h)<myCarPosY) {
        isHit=0;
      }
      int result=0;

      if (isHit==0 && (r.contains(myCarPosX, myCarPosY) || r.contains(myCarPosX, myCarPosY+myCarH) || r.contains(myCarPosX+myCarW, myCarPosY+myCarH) || r.contains(myCarPosX+myCarW, myCarPosY))) {
        result=1; 
        isHit=1;
      }

      return result;
    }
  }
}
