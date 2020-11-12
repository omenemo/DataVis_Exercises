// written by nd3svt for BA Interaction Design zhdk
// data literacy and visualization inputs
// october - november 2020, Berlin

//modified and commented by Nemo Brigatti

// reference to Spherical Coordinate System
// https://en.wikipedia.org/wiki/Spherical_coordinate_system
// how to calculate x y z in an spherical coordinate system

import peasy.*; // peasy cam library

PShape earth;
PImage surftex1;
PImage surftex2;

PFont myFont, myFontH2, myFontH1; // font class definition

PGraphics3D g3;
PeasyCam cam;
PMatrix3D currCameraMatrix;

// images containing GeoTIFF Data Sets
PImage co2;
PImage reforest;

float r = 400;
boolean easycamIntialized =false;

int rX = -90;
int rY = 0;
int rZ = 0;
PGraphics canvas;
// examples of manually added points

PVector human  = new PVector(); // mouse position vector 

// for loading data from future cities database
Table futureCities;
ArrayList<String> cities  = new ArrayList<String>(); // names of the cities
ArrayList<PVector> geoCoords = new ArrayList<PVector>();
ArrayList<String> futCities = new ArrayList<String>(); // names of the future cities
ArrayList<PVector> futGeoCoords = new ArrayList<PVector>();
ArrayList<Float> anMeTemps = new ArrayList<Float>();
ArrayList<Float> fuAnMeTemps = new ArrayList<Float>();
ArrayList<Float> maxTemps = new ArrayList<Float>();
ArrayList<Float> fuMaxTemps = new ArrayList<Float>();
ArrayList<Float> minTemps = new ArrayList<Float>();
ArrayList<Float> fuMinTemps = new ArrayList<Float>();
ArrayList<Float> anPres = new ArrayList<Float>();
ArrayList<Float> fuAnPres = new ArrayList<Float>();
ArrayList<Float> WetMoPres = new ArrayList<Float>();
ArrayList<Float> fuWetMoPres = new ArrayList<Float>();

float angle = 0;

void setup() {
  size(displayWidth, displayHeight, P2D);
  canvas = createGraphics(width, height, P3D);
  cam = new PeasyCam(this, 800);
  cam.setWheelScale(0.05);
  myFont =  createFont("Helvetica", 15);
  myFontH2 = createFont("Helvetica", 20);
  myFontH1 = createFont("Helvetica", 30);

  frameRate(60);

  if (!easycamIntialized) {
    cam.setMinimumDistance(20);
    cam.setMaximumDistance(r*600);
    easycamIntialized=true;
  }

  //loading texture map for the earth
  // surftex1 =loadImage("data/earth_sat.jpg"); 
  surftex1 =loadImage("data/earth_min_02.jpg");

  // loading images containing simplified GeoTIFF data
  co2 = loadImage("data/co2_emissions.png");
  co2.resize(width/8, height/8);

  reforest= loadImage("data/geodata_ref_potential.png");
  reforest.resize(width/8, height/8);

  canvas.sphereDetail(32);
  canvas.noStroke();
  earth = canvas.createShape(SPHERE, r);
  earth.setTexture(surftex1);

  loadData();
  // turning Data from Image (grayscale) into an ArrayList containing CO2 data in 3D Geo Coordinates
  //dataFromTIFFtoArray(co2, pntsFTIFF_co2, 1.0, color(0,0,0));
  //dataFromTIFFtoArray(reforest, pntsFTIFF_reforest, 0.25, color(0,255,0));
}

void draw() {
  updateTime();
  angle =0.0005;
  human.set(mouseX, mouseY);
  // Even we draw a full screen image after this, it is recommended to use
  // background to clear the screen anyways, otherwise A3D will think
  // you want to keep each drawn frame in the framebuffer, which results in 
  // slower rendering.
  canvas.beginDraw();
  canvas.background(175);// background color

  // Disabling writing to the depth mask so the 
  // background image doesn't occludes any 3D object.
  canvas.hint(DISABLE_DEPTH_MASK);
  canvas.hint(ENABLE_DEPTH_MASK);
  // this rotation is applied to correct the rotation of the texture according to 
  canvas.push();
  canvas.rotateX(radians( rX));
  canvas.rotateY(radians(rY));
  canvas.rotateZ(radians(rZ));
  canvas.shape(earth);
  canvas.pop();

  // displaying Points of Interest (cities inside future cities data set)
  displayMultiplePOI3D();

  // displaying co2
  if (showCO2) {
    if (pntsFTIFF_co2.size()>0) {
      canvas.push();
      for (PntFTIFF point : pntsFTIFF_co2) {
        point.display(canvas);
      }
      canvas.pop();
    }
  }

  //displaying reforest
  if (showReforest) {
    if (pntsFTIFF_reforest.size()>0) {
      canvas.push();
      for (PntFTIFF point : pntsFTIFF_reforest) {
        point.display(canvas);
      }
      canvas.pop();
    }
  }

  cam.beginHUD();
  // example to draw stuff on 2D outside the 3D context
  // fill(255,0,0);
  // textSize(12);
  // text("fps : " +frameRate,100,100);
  // text(" rx :  " + rX,100,115);
  // text(" ry :  " + rY,100,130);
  // text(" rz :  " + rZ,100,145);
  cam.endHUD();
  // 
  if (enableRotation) {
    cam.rotateX(angle);
    cam.rotateY(angle*1.25);
    cam.rotateZ(angle* (-1.25));
  }

  canvas.endDraw();
  cam.getState().apply(canvas);
  image(canvas, 0, 0);

  //image(co2,mouseX,mouseY,200,100);
  // if(frameCount%120 == 0) println(frameRate);

  displayMultiplePOI2D();
  if (showDebug) {
    debugInfo();
  }

  //println (Time);
}

PointOfInterest [] pOIs;
void loadData() {

  futureCities = loadTable("data/future_cities_data.csv", "header");
  println(futureCities.getRowCount() + " total rows in table");

  for (TableRow row : futureCities.rows()) { // writing into Futurecities table
    // println(city, longitude, latitude );
    cities.add(row.getString("current_city"));
    geoCoords.add(new PVector(row.getFloat("Longitude"), row.getFloat("Latitude")));
    futCities.add(row.getString("future_city_1_source"));
    futGeoCoords.add(new PVector(row.getFloat("future_long"), row.getFloat("future_lat")));

    anMeTemps.add(row.getFloat("Annual_Mean_Temperature"));
    fuAnMeTemps.add(row.getFloat("future_Annual_Mean_Temperature"));
    maxTemps.add(row.getFloat("Max_Temperature_of_Warmest_Month"));
    fuMaxTemps.add(row.getFloat("future_Max_Temperature_of_Warmest_Month"));
    minTemps.add(row.getFloat("Min_Temperature_of_Coldest_Month"));
    fuMinTemps.add(row.getFloat("future_Min_Temperature_of_Coldest_Month"));
    anPres.add(row.getFloat("Annual_Precipitation"));
    fuAnPres.add(row.getFloat("future_Annual_Precipitation"));
    WetMoPres.add(row.getFloat("Precipitation_of_Wettest_Month"));
    fuWetMoPres.add(row.getFloat("future_Precipitation_of_Wettest_Month"));
  }
  pOIs = new PointOfInterest[cities.size()];
  multiplePOI();
}

void multiplePOI() {
  for (int i=0; i<cities.size(); i++) {

    pOIs[i] = new PointOfInterest(

      geoCoords.get(i).y, 
      geoCoords.get(i).x, 
      cities.get(i), 
      futGeoCoords.get(i).y, 
      futGeoCoords.get(i).x, 
      futCities.get(i), 
      anMeTemps.get(i), 
      fuAnMeTemps.get(i), 
      maxTemps.get(i), 
      fuMaxTemps.get(i), 
      minTemps.get(i), 
      fuMinTemps.get(i), 
      anPres.get(i), 
      fuAnPres.get(i), 
      WetMoPres.get(i), 
      fuWetMoPres.get(i), 
      400, 
      i);
  }
}

void displayMultiplePOI2D() { // loading all 2d visible points of interest
  for (int i=0; i<cities.size(); i++) {
    pOIs[i].update(canvas);
    pOIs[i].display2D();
    pOIs[i].interact(human);
  }
}

void displayMultiplePOI3D() { // showing 3d points of interest
  for (int i=0; i<cities.size(); i++) {
    pOIs[i].display3D(canvas);
  }
}

void debugInfo() {
  textFont(myFont);
  fill(255);
  text("fps : " + frameRate, 20, 20);
  text("> press 'C' for showing CO2 emissions", 20, 40);
  text("> press 'G' for showing reforestation potential", 20, 60);
  text("> press 'R' for stop rotation", 20, 80);
  text("> press 'D' for hide/show debugging information", 20, 100);
  text("> press 'arrow Up /Down' for Timeline", 20, 120);
  text("> press 'F' for dis/en/abling focussing on click at specific location", 20, 140);
  text("> double mouse click for focussing back to the center of the sphere", 20, 160);
}
