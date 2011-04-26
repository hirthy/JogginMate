import processing.core.*; 
import processing.xml.*; 

import ddf.minim.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class JogginMate extends PApplet {



Minim minim;

int WIDTH = 400;
int HEIGHT = 600;
AudioSample sauce;

int currentcolor;

CircleButton circle1;

boolean locked = false;

public void setup() {
  size(WIDTH,HEIGHT);
  minim = new Minim(this);
  sauce = minim.loadSample("sauceboss.wav");
  
  smooth();

  int baseColor = color(102);
  currentcolor = baseColor;

  // Define and create circle button
  int buttoncolor = color(204);
  int highlight = color(153);
  ellipseMode(CENTER);
  circle1 = new CircleButton(WIDTH/2, 100, 100, buttoncolor, highlight);
  
  frameRate(30);
}

public void draw() {
  fill(0);
  background(255);
  stroke(255);
  update(mouseX, mouseY);
  circle1.display();
}

public void update(int x, int y)
{
  if(locked == false) {
    circle1.update();
  } 
  else {
    locked = false;
  }
}

public void mousePressed()
{
  if(circle1.pressed()) {
      sauce.trigger();
   }
}

public void stop()
{
  sauce.close();
  minim.stop();
  super.stop();
}

class Button
{
  int x, y;
  int size;
  int basecolor, highlightcolor;
  int currentcolor;
  boolean over = false;
  boolean pressed = false;   

  public void update() 
  {
    if(over()) {
      currentcolor = highlightcolor;
    } 
    else {
      currentcolor = basecolor;
    }
  }

  public boolean pressed() 
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

  public boolean over() 
  { 
    return true; 
  }

  public boolean overRect(int x, int y, int width, int height) 
  {
    if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
      return true;
    } 
    else {
      return false;
    }
  }

  public boolean overCircle(int x, int y, int diameter) 
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
  CircleButton(int ix, int iy, int isize, int icolor, int ihighlight) 
  {
    x = ix;
    y = iy;
    size = isize;
    basecolor = icolor;
    highlightcolor = ihighlight;
    currentcolor = basecolor;
  }

  public boolean over() 
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

  public void display() 
  {
    stroke(255);
    fill(currentcolor);
    ellipse(x, y, size, size);
  }
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "JogginMate" });
  }
}
