boolean showCO2;
boolean showDebug=true;
boolean showReforest;
boolean enableRotation;
boolean enableFocus;
int Time = 2020;

void keyPressed(){
  if(key == 'c' || key == 'C'){
    
    showCO2 = !showCO2;
  }
  if(key == 'd' || key == 'D'){
    
    showDebug = !showDebug;
  }
  if(key == 'g' || key == 'G'){
   
    showReforest = !showReforest;
  }
  if(key == 'r' || key == 'R'){
   
    enableRotation = !enableRotation;
  }
  if(key == 'f' || key == 'F'){
    enableFocus = !enableFocus;
  }
    if(keyCode == UP && Time >= 2020 && Time <= 2049){
    Time ++;
    }
   if(keyCode == DOWN && Time <= 2050 && Time >= 2021){ 
    Time --;
   }
}
