import processing.pdf.*;
import org.gicentre.handy.*;

class Sticky {
  String text;
  String type;
  String team;
  float pain = -1;
  boolean priority;
  
  boolean isWorking() {
    return type != null && type.equals("Working");
  }
  
  boolean isNotWorking() {
    return type != null &&
      (type.equals("Not Working") || type.equals("Not working"));
  }
  
  boolean isPuzzling() {
    return type != null && type.equals("Puzzling");
  }
  
  void draw(float size, float x, float y) {
    pushMatrix();
    translate(x - size / 2, y - size / 2);
    rotate(random(-0.1, 0.1));
    if (isWorking()) {
      fill(random(92), 255, random(92));
    }
    else if (isNotWorking()) {
      fill(255, random(64), random(92));
    }
    else if (isPuzzling()) {
      fill(255, 255, random(92));
    }
    else {
      println(type);
      fill(64 + random(64), 64 + random(64), 255);
    }
    rect(0, 0, size, size);
    float margin = 10;
    float tsize = size - margin;
    textAlign(CENTER);
    fill(0);
    textSize(type == null || pain > 0 ? 12 : 8);
    textFont(type == null || pain > 0 ? c12 : c8);
    text(text, margin / 2, margin / 2, tsize, tsize);
    popMatrix();
  }
}

ArrayList<Sticky> stickies;
PFont sr48, c8, c12;
HandyRenderer h;
boolean tw_obs = false;
boolean pain = false;


void setup() {
  size(displayWidth, displayHeight);
  noLoop();
  //beginRecord(PDF, "retros.pdf");
  
  //sr48 = createFont("SketchRockwell", 48);
  //c8 = createFont("ChalkboardSE-Light", 8);
  sr48 = loadFont("SketchRockwell-48.vlw");
  c8 = loadFont("ChalkboardSE-Light-8.vlw");
  c12 = loadFont("ChalkboardSE-Light-12.vlw");
  h = HandyPresets.createColouredPencil(this);
  
  stickies = new ArrayList<Sticky>();  
  Table table =
    loadTable(tw_obs ? "tw_obs.csv" : "retros_data.csv");
  for (TableRow row : table.rows()) {
    Sticky sticky = new Sticky();
    sticky.text = row.getString(0);
    try {
      sticky.type = row.getString(1);
      sticky.team = row.getString(2);
      sticky.pain = row.getFloat(3);
      String ps = row.getString(4);
      sticky.priority = ps != null && ps.equals("YES");
    }
    catch (ArrayIndexOutOfBoundsException e) {
      // do nothing
    }
    stickies.add(sticky);
  }
}

void heading(String text, float x, float y) {
  fill(0);
  textFont(sr48);
  textSize(48);
  textAlign(CENTER);
  text(text, x, y);
}

void draw() {
  background(255);
  
  if (pain) {
    drawChangePain();
  }
  else {
    if (tw_obs) {
      drawTwObs();
    }
    else {
      drawWelRetros();
    }
  }
  
}

void drawChangePain() {
  float margin = 80;

  heading("Change Pain", width / 2, 70);
  for (int i = 0; i <= 10; i++) {
    heading("" + i, margin + (width - 2 * margin) * i / 10, 150);
  }
  
  heading("---------------------------", width / 2, 360);
  
  float size = 100;
  float x, y;

  for (Sticky s : stickies) {
    if (s.pain > 0) {
      x = margin + (width - 2 * margin) * s.pain / 10;
      if (s.priority) {
        y = 250;
      }   
      else {
        y = 550 + random(-130, 150);
      }
      s.draw(size, x + random(10), y + random(10));
    }
  }  
  
}

void drawTwObs() {

  float margin = 100;
  float size = 120;
  float x, y;

  heading("ThoughtWorks Observations", width / 2, 70);

  x = size / 2 + margin;
  y = 180;
  for (Sticky s : stickies) {
    s.draw(size, x + random(10), y + random(10));
    x += size;
    if (x > width - size / 2 - margin) {
      x = size / 2 + margin;
      y += size;
    }
  }
  
}

void drawWelRetros() {
  float margin = 20;
  float size = 70;
  float x, y;

  heading("Working", width / 4, 70);

  x = size / 2 + margin;
  y = 140;
  for (Sticky s : stickies) {
    if (s.isWorking()) {
      s.draw(size, x + random(10), y + random(10));
      x += size;
      if (x > width / 2 - size / 2 - margin) {
        x = size / 2 + margin;
        y += size;
      }
    }
  }

  heading("Not Working", 3 * width / 4, 70);

  x = width / 2 + size / 2 + margin;
  y = 140;
  for (Sticky s : stickies) {
    if (s.isNotWorking()) {
      s.draw(size, x + random(10), y + random(10));
      x += size;
      if (x > width - size / 2 - margin) {
        x = width / 2 + size / 2 + margin;
        y += size;
      }
    }
  }

  heading("Puzzling", width / 4, 450);

  x = size / 2 + margin;
  y = 520;
  for (Sticky s : stickies) {
    if (s.isPuzzling()) {
      s.draw(size, x + random(10), y + random(10));
      x += size;
      if (x > width / 2 - size / 2 - margin) {
        x = size / 2 + margin;
        y += size;
      }
    }
  }

  //endRecord();
}

