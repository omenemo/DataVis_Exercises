// written by nd3svt for BA Interaction Design zhdk
// data literacy and visualization inputs
// october - november 2020, Berlin


// reference to Spherical Coordinate System
// https://en.wikipedia.org/wiki/Spherical_coordinate_system
// how to calculate x y z in an spherical coordinate system

import peasy.*;

PShape earth;
PImage surftex1;
PImage surftex2;

PFont myFont, myFontH;

PeasyCam cam;
PMatrix3D currCameraMatrix;

float r = 400;
boolean easycamIntialized =false;

int rX=-90;
int rY=0;
int rZ=0;
PGraphics canvas;
// examples of manually added points
PointOfInterest pOI_0, pOI_1, pOI_2, pOI_3,pOI_4;
PVector human  = new PVector();

// for loading data from future cities database
Table futureCities;
ArrayList<String> cities  = new ArrayList<String>(); // names of the cities
ArrayList<PVector> geoCoords = new ArrayList<PVector>();
ArrayList<String> futCities = new ArrayList<String>(); // names of the future cities
ArrayList<PVector> futGeoCoords = new ArrayList<PVector>();

void setup() {
  size(displayWidth,displayHeight,P2D);
  canvas = createGraphics(width, height, P3D);
  cam = new PeasyCam(this, 800);
  cam.setWheelScale(0.05);
  myFont = createFont("Helvetica", 12);
  myFontH = createFont("Helvetica", 64);
  
  frameRate(60);
  pOI_0 = new PointOfInterest(19.395175071159112, -99.16421378630378, "CDMX", r, 0);
  pOI_1 = new PointOfInterest(55.66174835669238, 12.513764710947195, "Copenhagen", r,1);
  pOI_2 = new PointOfInterest(-33.89517888896039, -58.656823360705175, "Buenos Aires",r, 2);
  pOI_3 = new PointOfInterest(48.868755553906496, 2.3463870250755137, "Paris",r, 3);
  pOI_4 = new PointOfInterest(47.37578791948954, 8.531219466080843, "Zürich",r, 4);


  if(!easycamIntialized){

    cam.setMinimumDistance(20);
    cam.setMaximumDistance(r*600);
    easycamIntialized=true;
  }

  // surftex1 =loadImage("data/earth_sat.jpg"); 
  surftex1 =loadImage("data/earth_min_01.jpg"); //Map image


  canvas.sphereDetail(32);
  canvas.noStroke();
  earth = canvas.createShape(SPHERE, r);
  earth.setTexture(surftex1);

  loadData();

}

void draw() {
  human.set(mouseX,mouseY);
  // Even if we draw a full screen image after this, it is recommended to use
  // background to clear the screen anyways, otherwise A3D will think
  // you want to keep each drawn frame in the framebuffer, which results in 
  // slower rendering.
  canvas.beginDraw();
  canvas.background(20); //Background color

  // Disabling writing to the depth mask so the 
  // background image doesn't occlude any 3D object.
  canvas.hint(DISABLE_DEPTH_MASK);
  canvas.hint(ENABLE_DEPTH_MASK);
  /*canvas.directionalLight(250, 250, 250, -10, -10, -10);
  canvas.directionalLight(250, 250, 250, 0,0,10);
  canvas.directionalLight(250, 250, 250, 0,10,0);
  canvas.directionalLight(250, 250, 250, 10,-10,-10);*/
  // this rotation is applied to correct the rotation of the texture according to 
  canvas.push();
  canvas.rotateX(radians( rX));
  canvas.rotateY(radians(rY));
  canvas.rotateZ(radians(rZ));
  canvas.shape(earth);
  canvas.pop();
  //pOI_0.display3D(canvas);
  //pOI_1.display3D(canvas);
  //pOI_2.display3D(canvas);
  //pOI_3.display3D(canvas);
  //pOI_4.display3D(canvas);
  displayMultiplePOI3D();

  cam.beginHUD();
  // example to draw stuff on 2D outside the 3D context
  // fill(255,0,0);
  // textSize(12);
  // text("fps : " +frameRate,100,100);
  // text(" rx :  " + rX,100,115);
  // text(" ry :  " + rY,100,130);
  // text(" rz :  " + rZ,100,145);
  cam.endHUD();
 
  canvas.endDraw();
  cam.getState().apply(canvas);
  image(canvas, 0, 0);

  //pOI_0.update(canvas);
  //pOI_0.display2D();
  //pOI_0.interact(human);
  //pOI_1.update(canvas);
  //pOI_1.display2D();
  //pOI_1.interact(human);
  //pOI_2.update(canvas);
  //pOI_2.display2D();
  //pOI_2.interact(human);
  //pOI_3.update(canvas);
  //pOI_3.display2D();
  //pOI_3.interact(human);
  //pOI_4.update(canvas);
  //pOI_4.display2D();
  //pOI_4.interact(human);
  // if(frameCount%120 == 0) println(frameRate);

  displayMultiplePOI2D();

}


PointOfInterest [] pOIs;
void loadData() {


  futureCities = loadTable("data/future_cities_data.csv", "header");
  println(futureCities.getRowCount() + " total rows in table");

  int entriesCount =0;
  for (TableRow row : futureCities.rows()) {
    String city = row.getString("current_city");
    float longitude = row.getFloat("Longitude");
    float latitude = row.getFloat("Latitude");

    String futureCity = row.getString("future_city_1_source");

    float longFut = row.getFloat("future_long");
    float latFut = row.getFloat("future_lat");

    if (city.length()>0) {
      // println(city, longitude, latitude );
      cities.add(city);
      geoCoords.add(new PVector(longitude, latitude));

      futCities.add(futureCity);
      futGeoCoords.add(new PVector(longFut, latFut));
    }
  }
  pOIs = new PointOfInterest[cities.size()];
  multiplePOI();
}

void multiplePOI(){

   for (int i=0; i<cities.size(); i++) {

    pOIs[i] = new PointOfInterest(geoCoords.get(i).y,geoCoords.get(i).x, cities.get(i), 400, i);

   }
}

void displayMultiplePOI2D(){
  for (int i=0; i<cities.size(); i++) {
    pOIs[i].update(canvas);
    pOIs[i].display2D();
    pOIs[i].interact(human);
  }
}

void displayMultiplePOI3D(){
  for (int i=0; i<cities.size(); i++) {

    pOIs[i].display3D(canvas);

  }
}


class  PointOfInterest{

  PVector location;
  float radius;
  PVector scrnPnt =new PVector();
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
    location = new PVector(
      radius* cos (radians(latitude)) * cos(radians(longitude)),
      radius * cos(radians(latitude)) * sin(radians(longitude)),
      radius * sin(radians(latitude))
    );
    name = _name;
    i = _i;
  }

  void update(PGraphics _canvas){
    scrnPnt.set(
      _canvas.screenX(-location.x,location.y,location.z), 
      _canvas.screenY(-location.x,location.y,location.z),
      _canvas.screenZ(-location.x,location.y,location.z)
    );
  }
  void display3D(PGraphics _canvas){
    // Big dots settings 
    _canvas.strokeWeight(10);
    _canvas.stroke(0,0,0); // red
    _canvas.point(-location.x,location.y,location.z);
    
  }

  void display2D(){
    // Typeface settings
    fill(255,255,255); 
    strokeWeight(0.5);
    //stroke(255,255,255,100);
    
    // Small dots setting
    stroke(0,0,255); //  blue
    strokeWeight(0); // invisible
    point(scrnPnt.x,scrnPnt.y); 
  }
  
  void interact(PVector _human){
    if(_human.dist(scrnPnt)< 7){
      strokeWeight(2);
      stroke(0,0,0,100); // Line Color
      float lx = scrnPnt.x;
      float ly = scrnPnt.y;
      float ex = futurePnt.x;
      float ex = futurePnt.y;
      line(lx,0,lx,height);
      line(0,ly,width,ly);
      line(lx,ly,ex,ey);
      textFont(myFont);
      text(name, 25,180);
      text("screen coords : " + scrnPnt.x + " ,  " + scrnPnt.y +  " , " + scrnPnt.z, 25,200);
      text("3D coords : "  + -location.x + " ,  " + location.y +  " , " + location.z, 25,220);
      textFont(myFontH);
      text(name, width-300,scrnPnt.y+10);
      textFont(myFont);
      text("lat : " + lat + "lon : " + lon, width-300,scrnPnt.y+50);
      stroke(0,0,0,100); // Line Color
      strokeWeight(2); // Interaction cirle
      fill(255,255,255, 0); 
      ellipse(scrnPnt.x, scrnPnt.y, 20, 20);
      

      if(mousePressed){
        // cam.lookAt(-location.x,location.y,location.z);
      }
    }

  }


}
