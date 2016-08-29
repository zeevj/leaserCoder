String lines[];

void setup() {
  size(800, 600);
  lines = loadStrings("sens.txt");
  //println("there are " + lines.length + " lines");
  noStroke();
  pixelDensity(2);
  scale(0.4, 1);


  display(int(lines.length * mouseX / float(width)), lines.length);

  println(output);
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

int counter = 0;
String output = "";

void countSteps(float val, float ctime) {
  counter++;
  //currentTime = ctime;
  threshUp = updateThreshUp(val, threshUp);
  threshDown = updateThreshDown(val, threshDown);

  if (val > (threshUp * (0.8)) && !isStepUp) {
    isStepUp = true;
    cycletime = ctime - savedTime;
    savedTime = ctime;

    //Render
    ellipse(ctime, height/2.0 - val, 5, 5);
  } else if (val < (threshDown * 1.8) && isStepUp) {
    isStepUp = false;
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
      
      int repos = (counter % 16) * 30 + 350;
      rect(estimatedTimeForNextStep,repos, windowWidth, 30);
      rect(estimatedTimeForNextHalfStep, repos, windowWidth, 30);
      rect(estimatedTimeForNextDoubleStep, repos, windowWidth, 30);
      stroke(color(noise(ctime) * 200 + 50, noise(ctime/2) * 200 + 50, noise(ctime/3) * 200 + 50));
      //line(estimatedTimeForNextStep, repos, estimatedTimeForNextHalfStep, 350);
      //line(estimatedTimeForNextStep, repos, estimatedTimeForNextDoubleStep, 350);

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
  counter = 0;
  scale(0.5, 0.5);
  display(int(lines.length * mouseX / float(width)), lines.length);
}

void display(int from, int untilNum) {
  background(100);
  float pval = 0;
  translate(-from, 0);
  for (int i = 0; i < untilNum; i++) {
    String tokens[] = split(lines[i], ",");
    float num = float(tokens[1]) - 900;
    float ctime = int(tokens[0]) / 1.0;
    pval = pval * 0.1 + num * 0.9;
    pushStyle();
    stroke(255);
    point(ctime, height/2.0 - pval);
    popStyle();
    countSteps(pval, ctime);
  }
}