PImage seeds;
PGraphics buffer, output;
float w, h, xLimit, yLimit, cell;
boolean isInColor, verticalDistribution;

PGraphics cmplx2;
PGraphics cmplx3;
PGraphics cmplx4;

void setup() {
  size(700, 990);
  colorMode(HSB, 360, 100, 100);
  seeds = loadImage("0.jpg");
  buffer = createGraphics(width, height);
  output = createGraphics(width, height);

  cmplx2 = createGraphics(500, 1000);
  cmplx3 = createGraphics(500, 1000);
  cmplx4 = createGraphics(500, 1000);
  noLoop();

  // --------------------------------------------
  // Options

  isInColor = false;
  verticalDistribution = true;
  cell = 45;

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
  buffer.endDraw();
}

// Line dithering
void drawOutput() {

  output.beginDraw();
  // drawCmplx3();
  // output.image(cmplx3, 100, 50, 100, 200);
  // drawCmplx2();
  // output.image(cmplx2, 300, 50, 100, 200);
  // drawCmplx4();
  // output.image(cmplx4, 500, 50, 100, 200);


  w = output.width / cell;
  h = w * 2;
  
  // Load the pixels of the buffer
  buffer.loadPixels();

  for (int x = 0; x < cell; x++) {
    for (int y = 0; y < cell * 2; y++) {

      int pxW = int((w * x) + (w / 2));
      int pxH = int((h * y) + (w / 2));

      int c = buffer.pixels[index(pxW, pxH, buffer)];

      float red = red(c);
      float green = green(c);
      float blue = blue(c);

      float cb = brightness(c);
      // println(cb);   

      drawCmplx3();
      drawCmplx2();
      drawCmplx4();

      if (cb > 0 && cb < 35) {
        output.stroke(0);
        output.fill(0);
        output.rect(w * x, h * y, w, h);
      } else if (cb > 35 && cb < 40) {
        output.image(cmplx3, w * x, h * y, w, h);
      } else if (cb > 40 && cb < 60) {
        output.image(cmplx2, w * x, h * y, w, h);
      } else if (cb > 60 && cb < 80) {
        output.image(cmplx4, w * x, h * y, w, h);
      } else if(cb > 80 && cb < 100) {
        output.stroke(255);
        output.fill(255);
        output.rect(w * x, h * y, w, h);
      }

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

void cmplx0(float x, float y, float w){
  output.fill(0);
  output.rect(x, y, w, w * 2);
}


void cmplx1(float x, float y, float w){
  output.fill(255);
  output.rect(x, y, w, w * 2);
}

void drawCmplx2(){

  cmplx2.beginDraw();
  cmplx2.noStroke();

  float amount = 7;
  float w = cmplx2.width / amount;
  float h = w;

  for (int x = 0; x < amount; ++x) {  
    for (int y = 0; y < amount * 2; ++y) {  
      if((x % 2 == 0 && y % 2 == 0) || (x % 2 == 1 && y % 2 == 1)){
        cmplx2.fill(255);
      }else {
        cmplx2.fill(0);
      }
      cmplx2.rect(w * x, h * y, w, h);
    }
  }
  cmplx2.endDraw();
}

void drawCmplx3(){

  cmplx3.beginDraw();
  // pg.background(255, 0 ,0);
  cmplx3.noStroke();

  float amount = 7;
  float w = cmplx3.width / amount;
  float h = w;

  for (int x = 0; x < amount; ++x) {  
    for (int y = 0; y < amount * 2; ++y) {  
      if((x % 2 == 0 && y % 2 == 0)){
        cmplx3.fill(0);
      }else {
        cmplx3.fill(255);
      }
      cmplx3.rect(w * x, h * y, w, h);
    }
  }
  cmplx3.endDraw();
}

void drawCmplx4(){

  cmplx4.beginDraw();
  // pg.background(255, 0 ,0);
  cmplx4.noStroke();

  float amount = 7;
  float w = cmplx4.width / amount;
  float h = w;

  for (int x = 0; x < amount; ++x) {  
    for (int y = 0; y < amount * 2; ++y) {  
      if((x % 2 == 0 && y % 2 == 0)){
        cmplx4.fill(255);
      }else {
        cmplx4.fill(0);
      }
      cmplx4.rect(w * x, h * y, w, h);
    }
  }
  cmplx4.endDraw();
}