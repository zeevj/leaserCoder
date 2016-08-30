String lines[];

void setup() {
  size(800, 600);
  lines = loadStrings("sens.txt");
  //println("there are " + lines.length + " lines");
  noStroke();
  pixelDensity(2);
  scale(0.4, 1);
  //display(int(lines.length * mouseX / float(width)), lines.length);
  //println(output);
}


//GLOBALS{
double cycletime;
double currentTime;
double savedTime;
double estimatedTimeForNextStep;
double estimatedTimeForNextHalfStep;
double estimatedTimeForNextDoubleStep;

float threshUp = 100.0;
float threshDown = 102.0;
boolean isStepUp = false;
boolean pisStepUp = false;

int counter = 0;
String output = "";
// }


boolean stepIsInWindowOf(double t, double estimatedTimeForNextStep, double windowWidth) {
  return (t > estimatedTimeForNextStep - windowWidth/2.0 && estimatedTimeForNextStep + windowWidth/2.0 > t);
}


void countSteps(float val, float ctime) {

  //currentTime = ctime;
  threshUp = updateThreshUp(val, threshUp);
  threshDown = updateThreshDown(val, threshDown);
  pushStyle();
  stroke(0,255,0);
  point(ctime,height/2.0 - threshUp);
  point(ctime,height/2.0 - threshDown);
  stroke(0,255,100);
  point(ctime,height/2.0 - threshUp * (0.3));
  point(ctime,height/2.0 - threshDown * 2.0);
  popStyle();

  if (val > (threshUp * (0.3)) && !isStepUp) {
    isStepUp = true;
    counter++;
    text(counter, ctime, 320);
    cycletime = ctime - savedTime;
    savedTime = ctime;

    //Render
    ellipse(ctime, height/2.0 - val, 5, 5);
  } else if (val < (threshDown + (threshUp -threshDown) * 0.2) && isStepUp) {
    isStepUp = false;
    ellipse(ctime, height/2.0 - val, 5, 5);
  }

  if (isStepUp != pisStepUp) {
    if (isStepUp) {
      if (stepIsInWindowOf(ctime, estimatedTimeForNextStep, 20)) {
        //Render
        text("1", ctime, 50);
        output += "1";
      } else if (stepIsInWindowOf(ctime, estimatedTimeForNextHalfStep, 20)) {
        //Render
        text("0", ctime, 50);
        output += "0";
      } else if (stepIsInWindowOf(ctime, estimatedTimeForNextDoubleStep, 20)) {
        //Render
        text("0", ctime, 50);
        output += "0";
      } else {
        //Render
        text("F", ctime, 50);
        output += "F";
      }

      estimatedTimeForNextStep = ctime + cycletime;
      estimatedTimeForNextHalfStep = ctime + cycletime / 2.0;
      estimatedTimeForNextDoubleStep = ctime + cycletime + cycletime;
      float windowWidth = 20;

      //Render
      rectMode(CENTER);
      pushStyle();

      fill(color(noise(ctime) * 200 + 50, noise(ctime/2) * 200 + 50, noise(ctime/3) * 200 + 50));

      int repos = (counter % 16) * 32 + 350;
      rect((float)estimatedTimeForNextStep, repos, windowWidth, 30);
      rect((float)estimatedTimeForNextHalfStep, repos, windowWidth, 30);
      rect((float)estimatedTimeForNextDoubleStep, repos, windowWidth, 30);
      stroke(color(noise(ctime) * 200 + 50, noise(ctime/2) * 200 + 50, noise(ctime/3) * 200 + 50));
      line((float)estimatedTimeForNextStep, repos, (float)estimatedTimeForNextHalfStep, repos);
      line((float)estimatedTimeForNextStep, repos, (float)estimatedTimeForNextDoubleStep, repos);

      popStyle();
    }
  }
  pisStepUp = isStepUp;
}


float updateThreshUp(float value, float threshUp) {
  if (value > threshUp) { 
    threshUp = value;
  }
  return threshUp - 0.1;//* 0.999;
}

float updateThreshDown(float value, float threshDown) {
  if (value < threshDown) {
    threshDown = value;
  }
  return threshDown + 0.1; //* 1.001;
}

void draw() {
  counter = 0;
  scale(0.5, 0.5);
  display(int(lines.length * mouseX / float(width)), lines.length);
}

void resetGlobalValues() {
  cycletime= 0;
  currentTime = 0;
  savedTime = 0;
  estimatedTimeForNextStep = 0;
  estimatedTimeForNextHalfStep = 0;
  estimatedTimeForNextDoubleStep = 0;

  threshUp = 100.0;
  threshDown = 102.0;
  isStepUp = false;
  pisStepUp = false;
}

void display(int from, int untilNum) {
  background(0);
  float sample = 0;
  float psample = 0;
  float filtveredVal = 0;
  //float pFiltveredVal = 0;
  resetGlobalValues();

  translate(-from, 0);
  for (int i = 0; i < untilNum; i++) {
    String tokens[] = split(lines[i], ",");

    psample = sample;
    sample = float(tokens[1]) - 900;
    float ctime = int(tokens[0]) / 1.0;

    //pval = pval * 0.0 + num * 1.0;
    //pval = num * 0.7 - pval * 0.3; 
    //if (frameCount % 8 > 3) {
    //  filtveredVal = 0.996 * (filtveredVal + sample - psample);
    //} else {
      filtveredVal = sample;
    //}

    countSteps(filtveredVal, ctime);
    
    
        pushStyle();
    stroke(255);
    point(ctime, height/2.0 - filtveredVal);
    popStyle();
  }
}