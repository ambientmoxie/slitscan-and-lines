String[] imagePath = new String[12];
PImage[] seeds = new PImage[imagePath.length];

PGraphics scan;
PGraphics source;

int selectorW = 10;
int selectorH = 100;
int selectorWadapt;
int selectorHadapt;
int pathSelector = 1;
int col;
int row;
int mx;
int my;

boolean scanning;

void setup() {

  size(1190, 842);
  
  for (int i=0; i < imagePath.length; i++) {
    imagePath[i] = i + ".jpg";    
  }


  for (int i=0; i < imagePath.length; i++) {
    String path = imagePath[i];
    seeds[i] = loadImage(path);
  }

  scan = createGraphics(width / 2, height);
  source = createGraphics(width / 2, height);

  col = 0;
  row = 0;

  scanning = false;
}

void draw() {

  drawSource();
  image(source, 0, 0);

  if (scanning == true) {
    drawScan();
    image(scan, width / 2, 0);
  }

  selectorWadapt = mouseX - selectorW / 2;
  selectorHadapt = mouseY - selectorH / 2;

  mx = constrain(selectorWadapt, 0, (width / 2) - (selectorW + 1));
  my = constrain(selectorHadapt, 0, height - selectorH);
  drawSelector();
}

void drawSource() {
  source.beginDraw();
  source.imageMode(CENTER);
  source.image(seeds[pathSelector], source.width / 2, source.height / 2);
  seeds[pathSelector].resize(width / 2, 0);
  source.endDraw();
}

void drawScan() {
  scan.beginDraw();
  scan.copy(source, mx, my, selectorW, selectorH, col, row, selectorW, selectorH);
  col++;
  if (col % scan.width == 0) {
    row += selectorH;
    col = 0;
  }
  scan.endDraw();
}

void drawSelector() {
  stroke(0, 255, 0);
  noFill();
  rect(mx, my, selectorW, selectorH);
}

void mousePressed() {
  scanning = !scanning;
}

void mouseReleased() {
  scanning = !scanning;
  col += selectorW - 1;
}

// Controller

void keyTyped() {
  if (key == 's' || key == 'S') {
    scan.save("export/slit_scan.tif");
  }

  if (key == 'm' || key == 'M') {
    if (selectorH <= height) {
      selectorH += 10;
    }
  }

  if (key == 'l' || key == 'L') {
    if (selectorH > 1) {
      selectorH -= 10;
    }
  }

  if (key == 'a' || key == 'A') {
    selectorW += 10;
  }

  if (key == 'z' || key == 'Z') {
    if (selectorW > 1) {
      selectorW -= 10;
    }
  }

  if (key == 'r' || key == 'R') {
    pathSelector += 1;
    if (pathSelector % imagePath.length == 0) {
      pathSelector = 0;
    }
  }
}
