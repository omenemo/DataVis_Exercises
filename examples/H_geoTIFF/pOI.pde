class  PointOfInterest{

  PVector location; // PVector for current cities
  float radius;
  PVector scrnPnt = new PVector(); // pvector for displaying all cities based on PVector «location» 
  String name;
  int i;
  float lat, lon;
  PointOfInterest(float latitude, float longitude, String _name, float _r, int _i){

  // some explanation on Geo Coordinates to an spheric system
  // lat long to > x y for vis in 2D
  // x = output_start + ((output_end - output_start) / (input_end - input_start)) * (input - input_start)
  // x = 0 + ((width - 0) / (180 - (-180))) * (longitude - (-180))
  // PVector location = new PVector(
  //   map(longitude, -180,180,0,width),
  //   map(latitude,90,-90,0,height)
  // );

  // lat long to > x y z for visualization in 3D
  // R is radius, phi = latitude in radians , theta = longitude in radians
  // x = R * cos(phi) * cos(theta);
  // y = R * cos(phi) * sin(theta);
  // z = R * sin(phi);

  // note if you want to add altitude instead of using radius alone
  // add the altitude to the R
  // R = R + altitude;
  // x = R* cos (latitude in radians) * cos(longitude in radians);
  // y = R * cos(latitude in radians) * sin(longitude in radians);
  // z = R * sin(latitude in radians )
  
    lat = latitude;
    lon = longitude;
    radius = _r +0.5; // with 10 units away from earth's surface
    location = new PVector( // defining the 3d coordinate PVector using Latitude + Longitude from location array
      radius* cos (radians(latitude)) * cos(radians(longitude)),
      radius * cos(radians(latitude)) * sin(radians(longitude)),
      radius * sin(radians(latitude))
    );
    name = _name;
    i = _i;
  }

  void update(PGraphics _canvas){ // function to translate the «3d» coordinates to «Screen» coordinates
    scrnPnt.set(
      _canvas.screenX(-location.x,location.y,location.z),
      _canvas.screenY(-location.x,location.y,location.z),
      _canvas.screenZ(-location.x,location.y,location.z)
    );
  }
  
  void display3D(PGraphics _canvas){
    // Big dots settings 
    _canvas.strokeWeight(10);
    _canvas.stroke(0,0,0); // black
    _canvas.point(-location.x,location.y,location.z);
  }

  void display2D(){
    // Typeface settings
    fill(255,255,255);
    strokeWeight(0.5);
    //stroke(255,255,255,100); //Outlining type WTF? #typeretards!!!
    
    // Small dots parameters
    stroke(0,0,255); //  blue
    strokeWeight(0); // invisible
    point(scrnPnt.x,scrnPnt.y); 
  }
  
  void interact(PVector _human){
    if(_human.dist(scrnPnt)< 7){ // collision detection with cities
      strokeWeight(0.5);
      stroke(0,0,0,100); // Line Color
      float lx = scrnPnt.x;
      float ly = scrnPnt.y;
      // float ex = scrnPnt.x;
      // float ey = scrnPnt.y;
      line(lx,0,lx,height);
      line(0,ly,width,ly);
      textFont(myFont);
      text(name, 25,180);
      text("screen coords : " + scrnPnt.x + " ,  " + scrnPnt.y +  " , " + scrnPnt.z, 25,200); // screen coordinate display
      text("3D coords : "  + -location.x + " ,  " + location.y +  " , " + location.z, 25,220); // 3d coordinate display
      textFont(myFontH);
      text(name, width-300,scrnPnt.y+10);
      textFont(myFont);
      text("lat : " + lat + "lon : " + lon, width-300,scrnPnt.y+50);
      stroke(0,0,0,100); // Line Color
      strokeWeight(2); // Interaction cirle
      fill(255,255,255,0);
      ellipse(scrnPnt.x, scrnPnt.y, 20, 20);
      //line(lx, ly, ex, ey);

      if(mousePressed && enableFocus){
         cam.lookAt(-location.x,location.y,location.z);
      }
    }
  }
  
}
