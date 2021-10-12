class Particle 
{
  double x;
  double y;
  double directionX;
  double directionY;
  double size;
  int particleColor;
    
  public Particle(double x, double y, double directionX, double directionY, double size, int particleColor)
  {
    this.x = x;
    this.y = y;
    this.directionX = directionX;
    this.directionY = directionY;
    this.size = size;
    this.particleColor = particleColor;
  }
  
  public void drawParticle()
  {
    fill(particleColor, 0);
    circle((float)x, (float)y, 10);  
  }
    
  public void update()
  {
    
    checkWindowCollision();
    
    checkMainCircleCollision();
    
    this.x += this.directionX;
    this.y += this.directionY;
    
    this.drawParticle();
  }
  
  void checkWindowCollision()
  {
    // Check if particle is on the canvas with respect to the x axis.
    if (this.x > width -1 || this.x < 1)
    {
      this.directionX *= -1;
    }
    // Check if particle is on the canvas with respect to the y axis
    if (this.y > height - 1 || this.y < 5) 
    {
      this.directionY *= -1;
    }
  }
  
  void checkMainCircleCollision()
  {
    double dx = this.x - (width / 2);
    double dy = this.y - (height / 2);
    double distance = Math.sqrt(dx * dx + dy * dy);
    
    // Check if particle is colliding with main circle
    if (distance < ((width / 2) / 2) + 5)
    {
      // Collision push left
      if (width / 2 < this.x && this.x < width - this.size * 10)
      {
        this.directionX *= -1;
      }
      // Collision push right
      if (width / 2 > this.x && this.x > this.size * 10)
      {
        this.directionX *= -1;
      }
      // Collision push up
      if (width / 2 < this.y && this.y < height - this.size * 10)
      {
        this.directionY *= -1;
      }
      // Collision push down
      if (width / 2 > this.y && this.y > this.size * 10)
      {
        this.directionY *= -1;
      }
    }
  }
}

void animate() 
{
  for (int i = 0; i < particleArr.size(); i++)
  {
    particleArr.get(i).update();
  }
  connect();
}

void initParticles()
{
  int numParticles = ((height * width) / 9000); // (height * width) / 9000
  
  // Create particles to populate particleArr with
  for (int i = 0; i < numParticles; i++) 
  {
    double size = (Math.random() * 5) + 1;
    double x = (Math.random() * ((width - size * 2) - (size * 2)) + size * 2);
    double y = (Math.random() * ((height - size * 2) - (size * 2)) + size * 2);
    double directionX = (Math.random() * 5) - 2.5;
    double directionY = (Math.random() * 5) - 2.5;
    boolean isValid = false;
    
    // Check if coordinate is valid. I.e. outside of main circle
    while(!isValid) 
    {
      double dx = x - (width / 2);
      double dy = y - (height / 2);
      double distance = Math.sqrt(dx * dx + dy * dy);
      
      // Coordinate not valid
      if (distance < ((width / 2) / 2) + 5 || y > height - 1 || y < 5)
      {
        x = (Math.random() * ((width - size * 2) - (size * 2)) + size * 2);
        y = (Math.random() * ((height - size * 2) - (size * 2)) + size * 2);
      }
      else
      {
        isValid = true;
      }
    }
    
    particleArr.add(new Particle(x, y, directionX, directionY, size, 255));
  }
}

void connect() 
{
  color currColor = #E16670;
  double opacityValue = 1;
  
  for (int i = 0; i < particleArr.size(); i++) 
  {
    for (int j = i; j < particleArr.size(); j++) 
    {
      double distance = ((particleArr.get(i).x - particleArr.get(j).x) * (particleArr.get(i).x - particleArr.get(j).x))
                          + ((particleArr.get(i).y - particleArr.get(j).y) * (particleArr.get(i).y - particleArr.get(j).y));
      if (distance < (width / 17) * (height / 17)) 
      {
        opacityValue = (1 - (distance / 20000)) * 100;
        if (fft.getBand(i) < .04 && fft.getBand(j) < .04)
        {
          currColor = #CC2936;
        }
        stroke(currColor, (float)opacityValue);
        line((float)particleArr.get(i).x, (float)particleArr.get(i).y, (float)particleArr.get(j).x, (float)particleArr.get(j).y);
      }
    }
  }
}
