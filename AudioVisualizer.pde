import ddf.minim.analysis.*;
import ddf.minim.*;
import http.requests.*;

Minim minim;
ddf.minim.analysis.FFT fft;

ArrayList<Particle> particleArr = new ArrayList<Particle>();

color circleColor = #FFFFFF;

AudioInput in;

String[] weather = new String[2];

void setup()
{
  size(1080, 1650); // Change these values to adjust display dimensions
  background(0);
  //fullScreen(0); // Uncomment for full screen
  frame.setTitle("Audio Visualizer");
  
  surface.setResizable(true);
    
  minim = new Minim(this);
  in = minim.getLineIn();
 
  fft = new FFT(in.bufferSize(), in.sampleRate());
  
  initParticles();
  
  weather = getWeather();
}
 
void draw()
{
  background(0);
  
  drawCircle();
  
  drawWave();
  
  drawTime();
  
  drawDate();
  
  drawWeather();
 
  animate();
}

void drawCircle()
{
  // Configure and draw main circle.
  noFill();
  stroke(circleColor);
  strokeWeight(3);
  circle(width / 2, height / 2, width / 2);
}

void drawWave()
{
  fft.forward(in.mix);
  float waveHeight;
  
  // Draw sound wave from fft
  for(int i = 0; i < fft.specSize(); i++)
  {
    if (i * 25 > 0 + 25 && i * 25 < width - 25) 
    {
      // Change color of bar if height is big enough
      if (fft.getBand(i) * 40 > 30) {
        fill(#CC2936);
      }
      else 
      {
        fill(255);
      }
      noStroke();
      // Check if height is outside circle
      waveHeight = fft.getBand(i) * 10 < (height / 10) / 2 ? (fft.getBand(i) * 10) : ((height / 10));
      
      rect((i * 25) * .3 + (width / 2.88), height / 2, 3, (waveHeight * -1) - 3);
      rect((i * 25) * .3 + (width / 2.88), height / 2, 3, waveHeight + 3);
    }
  }
}

void drawTime() 
{  
  // Load and set font
  PFont font;
  font = loadFont("Roboto-Regular-48.vlw");
  textFont(font, 48);
  
  // Draw
  fill(#FFFFFF);
  textSize(32);
  
  // Format hour and minute
  String currHour = hour() >= 10 ? Integer.toString(hour()) : "0" + Integer.toString(hour());
  if (hour() > 12) 
  {
    currHour =  hour() - 12 >= 10 ? Integer.toString(hour() -12) : "0" + Integer.toString(hour() - 12);
  }
  String currMinute = minute() >= 10 ? Integer.toString(minute()) : "0" + Integer.toString(minute());
  
  text(currHour, (width / 2) - 15, (height / 1.3) - 60);
  text(currMinute, (width / 2) - 15, (height / 1.3) - 30); 
  fill(255, 102, 153);
}

String formatDay()
{
  String[] daysOfWeek = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" };
  int day = ((year() * 365 + round((year() - 1) / 4) - round((year() - 1) / 100) + round((year() - 1) / 400)) % 7) - 1;
  
  return daysOfWeek[day];
}

String formatMonth() 
{
  String[] months = { "Jan", "Feb", "March", "April", "May", "June", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };
  
  return months[month()];
}

void drawDate() 
{
  textSize(22);
  fill(#CC2936);
  text(formatDay() + ", " + formatMonth() + " " + day(), (width / 2) - 65, (height / 1.5) + 40);
}

String[] getWeather() 
{
  String temp = "";
  String condition = "";
  
  GetRequest request = new GetRequest("https://api.openweathermap.org/data/2.5/weather?q=Madison&units=imperial&appid=391ec8f635cf83451823edf0cd69ba3a");
  request.send();
  
  JSONObject response = parseJSONObject(request.getContent());
  
  temp = String.valueOf(Math.round(Double.parseDouble(response.getJSONObject("main").get("temp").toString())));
  condition = response.getJSONArray("weather").getJSONObject(0).get("main").toString();
  
  if (condition.equals("Clouds")) 
    condition = "Cloudy";
    
  return new String[] {temp, condition};
}

void drawWeather() 
{
  textSize(22);
  fill(#CC2936);
  text(weather[0] + "°F" + " " + weather[1], (width / 2) - 55, height / 1.5 + 65);
}
