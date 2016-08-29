String lines[];

void setup() {
  size(800, 600);
  lines = loadStrings("sens.txt");
  //println("there are " + lines.length + " lines");
  noStroke();
  pixelDensity(2);
  display(lines.length);
}

float cycletime= 0;
float currentTime = 0;
float savedTime = 0;
float threshUp = 100.0;
float threshDown = 102.0;
boolean isStepUp = false;
boolean pisStepUp = false;

float estimatedTimeForNextStep;
float estimatedTimeForNextHalfStep;
float estimatedTimeForNextDoubleStep;

boolean stepIsInWindowOf(float t, float estimatedTimeForNextStep, float windowWidth) {
  return (t > estimatedTimeForNextStep - windowWidth/2.0 && estimatedTimeForNextStep + windowWidth/2.0 > t);
}


void countSteps(float val, float ctime) {
  //currentTime = ctime;
  threshUp = updateThreshUp(val, threshUp);
  threshDown = updateThreshDown(val, threshDown);

  if (val > (threshUp * (0.7)) && !isStepUp) {
    isStepUp = true;
    cycletime = ctime - savedTime;
    savedTime = ctime;

    ellipse(ctime, height/2.0 - val, 5, 5);
  } else if (val < (threshDown * 1.5) && isStepUp) {
    isStepUp = false;
  }

  if (isStepUp != pisStepUp) {
    if (isStepUp) {
      if (stepIsInWindowOf(ctime, estimatedTimeForNextStep, 20)) {
        text("1", ctime, 50);
      } else if (stepIsInWindowOf(ctime, estimatedTimeForNextHalfStep, 20)) {
        text("0", ctime, 50);
      } else if (stepIsInWindowOf(ctime, estimatedTimeForNextDoubleStep, 20)) {
        text("0", ctime, 50);
      }
      //println(cycletime);
      //println(savedTime);
      //println("&&&&&");
      estimatedTimeForNextStep = ctime + cycletime;
      estimatedTimeForNextHalfStep = ctime + cycletime / 2.0;
      estimatedTimeForNextDoubleStep = ctime + cycletime + cycletime;
      float windowWidth = 20;


      rectMode(CENTER);
      rect(estimatedTimeForNextStep, 320, windowWidth, 30);
      pushStyle();
      fill(200);
      rect(estimatedTimeForNextHalfStep, 350, windowWidth, 30);
      rect(estimatedTimeForNextDoubleStep, 380, windowWidth, 30);
      popStyle();
    }
  }
  pisStepUp = isStepUp;
}


float updateThreshUp(float value, float threshUp) {
  if (value > threshUp) { 
    threshUp = value;
  }
  return threshUp * 0.9999;
}

float updateThreshDown(float value, float threshDown) {
  if (value < threshDown) {
    threshDown = value;
  }
  return threshDown * 1.0001;
}

void draw() {
  scale(0.5, 0.5);
  //display(min(frameCount, lines.length));
}

void display(int untilNum) {
  background(100);
  float pval = 0;
  for (int i = 0; i < untilNum; i++) {
    String tokens[] = split(lines[i], ",");
    float num = float(tokens[1]) - 900;
    float ctime = int(tokens[0]) / 1.0;
    pval = pval * 0.3 + num * 0.7;
    pushStyle();
    stroke(255);
    point(ctime, height/2.0 - pval);
    popStyle();
    countSteps(pval, ctime);
  }
}