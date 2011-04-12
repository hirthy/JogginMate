import ddf.minim.*;

Minim minim;

int WIDTH = 400;
int HEIGHT = 600;
AudioSample sauce;

color currentcolor;

CircleButton circle1;

boolean locked = false;

void setup() {
  size(WIDTH,HEIGHT);
  minim = new Minim(this);
  sauce = minim.loadSample("sauceboss.wav");
  
  smooth();

  color baseColor = color(102);
  currentcolor = baseColor;

  // Define and create circle button
  color buttoncolor = color(204);
  color highlight = color(153);
  ellipseMode(CENTER);
  circle1 = new CircleButton(WIDTH/2, 100, 100, buttoncolor, highlight);
  
  frameRate(30);
}

void draw() {
  fill(0);
  background(255);
  stroke(255);
  update(mouseX, mouseY);
  circle1.display();
}

void update(int x, int y)
{
  if(locked == false) {
    circle1.update();
  } 
  else {
    locked = false;
  }
}

void mousePressed()
{
  if(circle1.pressed()) {
      sauce.trigger();
   }
}

void stop()
{
  sauce.close();
  minim.stop();
  super.stop();
}

class Button
{
  int x, y;
  int size;
  color basecolor, highlightcolor;
  color currentcolor;
  boolean over = false;
  boolean pressed = false;   

  void update() 
  {
    if(over()) {
      currentcolor = highlightcolor;
    } 
    else {
      currentcolor = basecolor;
    }
  }

  boolean pressed() 
  {
    if(over) {
      locked = true;
      return true;
    } 
    else {
      locked = false;
      return false;
    }    
  }

  boolean over() 
  { 
    return true; 
  }

  boolean overRect(int x, int y, int width, int height) 
  {
    if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
      return true;
    } 
    else {
      return false;
    }
  }

  boolean overCircle(int x, int y, int diameter) 
  {
    float disX = x - mouseX;
    float disY = y - mouseY;
    if(sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
      return true;
    } 
    else {
      return false;
    }
  }

}

class CircleButton extends Button
{ 
  CircleButton(int ix, int iy, int isize, color icolor, color ihighlight) 
  {
    x = ix;
    y = iy;
    size = isize;
    basecolor = icolor;
    highlightcolor = ihighlight;
    currentcolor = basecolor;
  }

  boolean over() 
  {
    if( overCircle(x, y, size) ) {
      over = true;
      return true;
    } 
    else {
      over = false;
      return false;
    }
  }

  void display() 
  {
    stroke(255);
    fill(currentcolor);
    ellipse(x, y, size, size);
  }
}
