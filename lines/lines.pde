String[] imagePath = new String[9]; // Edit number of entries here
PImage[] seeds = new PImage[imagePath.length];
int pathSelector;
float w, h, account;

PGraphics buffer;
PGraphics output;

boolean isInColor = true;


void setup() {
  size(700, 990);

  // Load all paths
  for (int i=0; i < imagePath.length; i++) {
    imagePath[i] = i + ".jpg";
  }

  // Fill the array
  for (int i=0; i < imagePath.length; i++) {
    String path = imagePath[i];
    seeds[i] = loadImage(path);
  }

  // Define first image loaded
  pathSelector = 0;

  // Set up the scenes
  buffer = createGraphics(width, height);
  output = createGraphics(width / 2, height);
 
}

void draw() {
  // Init Buffer
  drawBuffer();

  // Init and display ouput
  drawOutput();
  image(output, 0, 0);
  pushMatrix(); // Save the current transformation matrix
  scale(-1, 1); // Flip the image horizontally
  translate(- width, 0); // Move the image back to the right position
  image(output, 0, 0); // Draw the flipped image
  popMatrix(); // Restore the original transformation matrix
}

void drawBuffer() {
  buffer.beginDraw();
  buffer.imageMode(CENTER);
  buffer.image(seeds[pathSelector], width / 2, height / 2);
  buffer.endDraw();
}


void drawOutput() {

  output.beginDraw();

  account = 19;
  w = width / account;
  h = 2;

  buffer.loadPixels(); // Load the pixels of the buffer

  for (int x = 0; x < account; x++) {
    for (int y = 0; y < output.height; y++) {

      int pxW = int((w * x) + (w / 2));
      int pxH = int((h * y) + (h / 2));

      int c = buffer.pixels[index(pxW, pxH, buffer)];

      float red = red(c);
      float green = green(c);
      float blue = blue(c);

      // Define color
      color nc = color(red, green, blue);
      // Define brightness value
      float cb = brightness(c);

      if (isInColor) {
        output.stroke(nc);
        output.fill(nc);
      } else {
        output.stroke(cb);
        output.fill(cb);
      }

      output.rect(w * x, h * y, w, h);
    }
  }

  output.endDraw();
}


void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      pathSelector = (pathSelector + 1) % imagePath.length;
    }
    if (keyCode == LEFT) {
      pathSelector = (pathSelector - 1 + imagePath.length) % imagePath.length;
    }
  }
}

// better way for accessing pixels than ".get" method

int index(int x, int y, PImage target) {
  if (x < target.width && y < target.height) { // Prevent "array out of bounds" error
    return x + y * target.width;
  } else {
    return 0; // safe value
  }
}

void keyTyped() {
  if (key == 's' || key == 'S') {
    save("export/mirror.tif");
  }
}
