


float vals[];
String lines[];

void setup() {
  size(800, 600);

  lines = loadStrings("sens.txt");
  vals = new float[lines.length];
  //println("there are " + lines.length + " lines");
}



void countSteps(float vals[]) {

  int cycletime= 0;
  int currentTime = 0;
  int savedTime = 0;
  float threshUp = 0.0;
  float threshDown = 1023.0;
  boolean isStepUp = false;
  boolean pisStepUp = false;

  for (int i = 0; i < vals.length; i++) {
    String tokens[] = split(lines[i],",");
    currentTime = int(tokens[0]);
    threshUp = updateThreshUp(float(tokens[1]), threshUp);
    threshDown = updateThreshDown(float(tokens[1]), threshDown);
    //println(threshUp);

    if (float(tokens[1]) > (threshUp * (0.9)) && !isStepUp) {

      isStepUp = true;
      ellipse(float(i) / 10.0, height/2.0 - float(tokens[1]), 10, 10);

      cycletime = currentTime - savedTime;
      savedTime = currentTime;
    } else if (float(tokens[1]) < (threshDown * 1.2) && isStepUp) {
      isStepUp = false;
    }

    if (isStepUp != pisStepUp) {
      if (isStepUp) {
        //estimatedTimeForNextStep = currentTime + cycletime;
        //needToLookForNextStep = true;
        //startWindow = estimatedTimeForNextStep - 100;
        //endWindow = estimatedTimeForNextStep + 40;
      }
    }


    pisStepUp = isStepUp;
  }
}

//boolean countSteps(float value) {

//}

float updateThreshUp(float value, float threshUp) {
  if (value > threshUp) {
    threshUp = value;
  }

  return threshUp * 0.99999;
}

float updateThreshDown(float value, float threshDown) {
  if (value < threshDown) {
    threshDown = value;
  }
  return threshDown * 1.00001;
}

void draw() {
  background(100);
  for (int i = 0; i < lines.length; i++) {
    String tokens[] = split(lines[i],",");
    float num = float(tokens[1]) - 900;
    //float(tokens[1]) = num;
    point(float(i) / 10.0, height/2.0 - vals[i]);
  }
  countSteps(vals);
} 
