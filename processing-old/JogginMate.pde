import ddf.minim.*;

Minim minim;

int WIDTH = 400;
int HEIGHT = 600;
AudioSample sauce;

color currentcolor, othercolor;

CircleButton quickStartBtn, customizeBtn;

CircleButton[] buttons;

boolean locked = false;

PImage logo;

PFont font;

void setup() {
  size(WIDTH,HEIGHT);
  minim = new Minim(this);
  sauce = minim.loadSample("sauceboss.wav");
  logo = loadImage("logo.jpg");
  font = loadFont("Helvetica-32.vlw");
  smooth();
  
  color baseColor = color(255);
  currentcolor = baseColor;

  // Define and create circle button
  color buttoncolor = color(204);
  color highlight = color(153);
  ellipseMode(CENTER);
  quickStartBtn = new CircleButton((WIDTH-250)/2, HEIGHT - 200, 250.0, 60.0, currentcolor, highlight, "QUICK START");
  customizeBtn = new CircleButton((WIDTH-250)/2, HEIGHT - 100, 250.0, 60.0, currentcolor, highlight, "CUSTOMIZE");
  buttons = new CircleButton[]{ quickStartBtn, customizeBtn };
  frameRate(30);
}

void draw() {
  fill(0);
  background(255);
  stroke(255);
  update(mouseX, mouseY);
  image(logo,0,0);
  for (int i = 0; i < buttons.length; i++)
  {
     buttons[i].display();
  }
  textFont(font);
  fill(153);
}

void update(int x, int y)
{
  if(locked == false) {
    for(int i = 0; i < buttons.length; i++)
    {
      buttons[i].update();
    }
  } 
  else {
    locked = false;
  }
}

void mousePressed()
{
  for(int i = 0; i < buttons.length; i++)
  { 
    if(buttons[i].pressed()) {
        sauce.trigger();
     }
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
  float x, y, w, h;
  color basecolor, highlightcolor, currentcolor, textcolor;
  boolean over = false;
  boolean pressed = false; 
  String label;  

  void update() 
  {
    if(over()) {
      textcolor = basecolor;
      currentcolor = highlightcolor;
    } 
    else {
      textcolor = highlightcolor;
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

  boolean overRect(float x, float y, float width, float height) 
  {
    if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
      return true;
    } 
    else {
      return false;
    }
  }

  boolean overCircle(float x, float y, float diameter) 
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
  CircleButton(float ix, float iy, float iw, float ih, color icolor, color ihighlight, String ilabel)
  {
    x = ix;
    y = iy;
    w = iw;
    h = ih;
    basecolor = icolor;
    highlightcolor = ihighlight;
    currentcolor = basecolor;
    textcolor = highlightcolor;
    label = ilabel;
  } 

  boolean over() 
  {
    if( overRect(x, y, w, h) ) {
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
    stroke(highlightcolor);
    fill(currentcolor);
    float corner = w/10.0;
    float midDisp = w/25.0;
  
    beginShape();  
    curveVertex(x+corner,y);
    curveVertex(x+w-corner,y);
    curveVertex(x+w+midDisp,y+h/2.0);
    curveVertex(x+w-corner,y+h);
    curveVertex(x+corner,y+h);
    curveVertex(x-midDisp,y+h/2.0);
  
    curveVertex(x+corner,y);
    curveVertex(x+w-corner,y);
    curveVertex(x+w+midDisp,y+h/2.0);
    endShape();
    //Draw button label
    fill(textcolor);
    textAlign(CENTER);
    text(label, (WIDTH)/2, y + (h-17));
  }
}
