PImage seeds;
PGraphics buffer, output;
float w, h, xLimit, yLimit, cell, chance;
boolean isInColor, verticalDistribution;


void setup() {
  size(700, 990);
  seeds = loadImage("0.jpg");
  colorMode(HSB, 360, 100, 100);
  buffer = createGraphics(width, height);
  output = createGraphics(width, height);
  noLoop();

  // --------------------------------------------
  // Options

  isInColor = false;
  verticalDistribution = true;
  cell = 50;
  chance = 1;

  // --------------------------------------------
  
}

void draw() {

  // Init the image to be dithered
  drawBuffer();

  // Init the dithered output and display it
  drawOutput();
  image(output, 0, 0);
}

void drawBuffer() {
  buffer.beginDraw();
  buffer.imageMode(CENTER);
  buffer.image(seeds, width / 2, height / 2);
  buffer.filter(INVERT);
  buffer.endDraw();
}

// Line dithering
void drawOutput() {

  output.beginDraw();
  output.background(255);

  w = width / cell;
  h = w;
  
  // Load the pixels of the buffer
  buffer.loadPixels();

  for (int x = 0; x < cell; x++) {
    for (int y = 0; y < cell * 2; y++) {

      int pxW = int((w * x) + (w / 2));
      int pxH = int((h * y) + (h / 2));

      int c = buffer.pixels[index(pxW, pxH, buffer)];

      float red = red(c);
      float green = green(c);
      float blue = blue(c);

      output.noStroke();
      float cb = brightness(c);
      float cm = map(cb, 0, 100, 8, w);

      float mapChance = map(y, 0, cell, 0, 1);
      color cc = random(0,1) > chance - mapChance ? color(0) : color(360, 0, 100);

      output.fill(cc);
      output.pushMatrix();
      output.translate(w / 2, h / 2);
      output.ellipse(w * x, h * y, cm, cm);
      output.popMatrix();
    }
  }
  output.endDraw();
}

// Accessing px in the px array
int index(int x, int y, PImage target) {
  // Prevent "array out of bounds" error
  if (x < target.width && y < target.height) {
    return x + y * target.width;
  } else {
    // Safe value
    return 0;
  }
}

void keyTyped() {
  if (key == 's' || key == 'S') {
    save("export/mirror.tif");
  }
}
