class  PointOfInterest {

  PVector location; // PVector for current cities  

  PVector scrnPnt = new PVector(); // pvector for displaying all cities based on PVector «location» 
  PVector scrnPntFut = new PVector();

  Float lat, lon;
  Float latFut, lonFut;
  String name;
  String nameFut;
  PVector locationFut;
  Float anMeTemp; 
  Float fuAnMeTemp; 
  Float maxTemp;
  Float fuMaxTemp; 
  Float minTemp;
  Float fuMinTemp; 
  Float anPre;
  Float fuAnPre;
  Float WetMoPre;
  Float fuWetMoPre; 
  Float radius;
  int i;

  PointOfInterest(   // function Parameters, see multiple POI function, 13 parameters
    float _latitude, 
    float _longitude, 
    String _name, 
    float _latFut, 
    float _lonFut, 
    String _nameFut, 
    Float _anMeTemp, 
    Float _fuAnMeTemp, 
    Float _maxTemp, 
    Float _fuMaxTemp, 
    Float _minTemp, 
    Float _fuMinTemp, 
    Float _anPre, 
    Float _fuAnPre, 
    Float _WetMoPre, 
    Float _fuWetMoPre, 
    float _r, 
    int _i) {


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
    // z = R * sin(latitude in radians)

    lat = _latitude;
    lon = _longitude;
    radius = _r +0.5; // with 10 units away from earth's surface
    // defining the 3d coordinate PVector using Latitude + Longitude from currentLocation array
    location = new PVector( 
      radius* cos (radians(_latitude)) * cos(radians(_longitude)), 
      radius * cos(radians(_latitude)) * sin(radians(_longitude)), 
      radius * sin(radians(_latitude))
      );

    name = _name;

    latFut = _latFut;
    lonFut = _lonFut;
    // defining the 3d coordinate PVector using Latitude + Longitude from futureLocation array
    locationFut = new PVector( 
      radius* cos (radians(latFut)) * cos(radians(lonFut)), 
      radius * cos(radians(latFut)) * sin(radians(lonFut)), 
      radius * sin(radians(latFut))
      );
    nameFut = _nameFut;
    anMeTemp = _anMeTemp;
    fuAnMeTemp = _fuAnMeTemp;
    maxTemp = _maxTemp;
    fuMaxTemp = _fuMaxTemp;
    minTemp = _minTemp;
    fuMinTemp = _fuMinTemp;
    anPre = _anPre;
    fuAnPre = _fuAnPre;
    WetMoPre = _WetMoPre;
    fuWetMoPre = _fuWetMoPre;
    i = _i;
  }

  void update(PGraphics _canvas) { 
    scrnPntFut.set(  // translate the current «3d» coordinates to «Screen» coordinates
      _canvas.screenX(-locationFut.x, locationFut.y, locationFut.z), 
      _canvas.screenY(-locationFut.x, locationFut.y, locationFut.z), 
      _canvas.screenZ(-locationFut.x, locationFut.y, locationFut.z)
      );

    scrnPnt.set( // translate the «3d» Future coordinates to «Screen» coordinates
      _canvas.screenX(-location.x, location.y, location.z), 
      _canvas.screenY(-location.x, location.y, location.z), 
      _canvas.screenZ(-location.x, location.y, location.z)
      );
  }

  void display3D(PGraphics _canvas) {
    // Big dots settings 
    _canvas.strokeWeight(10);
    _canvas.stroke(0, 0, 0); // black
    _canvas.point(-location.x, location.y, location.z);
  }

  void display2D() {
    // Typeface settings
    fill(255, 255, 255);

    // Small dots parameters
    stroke(0, 0, 255); //  blue
    strokeWeight(0); // invisible
    point(scrnPnt.x, scrnPnt.y);
  }

  void interact(PVector _human) {
    // collision detection radius / more than three is critical because of proximity error
    if (_human.dist(scrnPnt)< 3) { 

      float lx = scrnPnt.x;    // current city 2d drawing coordinates
      float ly = scrnPnt.y;
      float ex = scrnPntFut.x; // future city 2d drawing coordinates
      float ey = scrnPntFut.y;

      // Year / Time specific Projection value calculation using start- & endyear / current & future data
      println(fuAnMeTemp);
      println(anMeTemp);

      float ProAnMeTemp = map(Time, 2020, 2050, anMeTemp, fuAnMeTemp);
      float ProMaxTemp = map(Time, 2020, 2050, maxTemp, fuAnMeTemp);
      float ProMinTemp = map(Time, 2020, 2050, minTemp, fuMinTemp);
      float ProAnPre = map(Time, 2020, 2050, anPre, fuAnPre);
      float ProWetMoPre = map(Time, 2020, 2050, WetMoPre, fuWetMoPre);
      
      strokeWeight(3);  // info window 
      stroke(255, 255, 255, 255);  
      fill(0, 0, 0, 255);       
      rect(width-450, scrnPnt.y - 50, 425, 250, 20, 20, 20, 20); 
      
      // INFO TEXT
      fill(255, 255, 255, 255);   
      noStroke(); 
      textFont(myFontH1); // Description Info //font herarchy
      text(name + " " + Time, width-400, scrnPnt.y+10);
      textFont(myFontH2);
      // text("lat : " + lat + "lon : " + lon, width-400, scrnPnt.y+40);
      text(int(ProAnMeTemp) + "° mean Temperature / year", width-400, scrnPnt.y+40);
      text(int(ProMaxTemp) + "° max Temperature", width-400, scrnPnt.y+70);
      text(int(ProMinTemp) + "° min Temperature", width-400, scrnPnt.y+100);
      text(int(ProAnPre) + " mm Preciptation / year", width-400, scrnPnt.y+130);
      text(int(ProWetMoPre) + " mm  Preciptation / Wettest Month", width-400, scrnPnt.y+160);

      strokeWeight(6);      // Cur_Info_connecing line // info_circle
      strokeWeight(3); 
      line(lx, ly, width - 450, scrnPnt.y); //white shadow
      ellipse(width - 450, scrnPnt.y, 20, 20); 
      stroke(0, 0, 0, 255);  
      line(lx, ly, width - 450, scrnPnt.y); //black line
       
      strokeWeight(3);      // style attributes
      stroke(0, 0, 0, 255);    // lines -> black
      fill(0, 0, 0, 0);        // typo -> White

      line(lx, ly, ex, ey);    // Cur_Fut_connecting line
      
      ellipse(scrnPnt.x, scrnPnt.y, 20, 20); // current_circle
      ellipse(scrnPntFut.x, scrnPntFut.y, 20, 20); // future_circle

      fill (255, 0, 0);
      point(scrnPnt.x, scrnPnt.y, scrnPnt.z);

      fill(255, 255, 255);  // typo -> White

      textFont(myFont); // font herarchy
      text(name, 25, 180); // Debugging Info
      text("screen coords : " + scrnPnt.x + " ,  " + scrnPnt.y +  " , " + scrnPnt.z, 25, 200); // screen coordinate display
      text("3D coords : "  + -location.x + " ,  " + location.y +  " , " + location.z, 25, 220); // 3d coordinate display

      if (mousePressed && enableFocus) {
        cam.lookAt(-location.x, location.y, location.z);
      }
    }
  }
}
