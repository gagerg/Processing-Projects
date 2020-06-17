//Gage Gutmann
//CPSC 313
//HW4
//2/27/20

PImage img;
Table table;

int [] year = new int[1];
float [] mag = new float[1];
float [] lat = new float[1];
float [] lon = new float[1];
float [] fixLat = new float[1];
float [] fixLon = new float[1];
int currentYear = 0;
int yearPosition = 0;
int earthquakeCount = 0;
float avgMag = 0;
color c1, c2,c3,c4,c5,c6,c7;



void setup(){
  size(1800,900);
  img = loadImage("editedEquirectangular.jpg");
  table = loadTable("centennial.csv", "header");
  
  //c1 = color(#F3EAAB);
  //c2 = color(#D61D00);
  c3 = color(#FCF257);
  //c4 = color(#4977FF);
  c5 = color(#C60901);
  //c6 = color(#FBF9F5);
  //c7 = color(#FF9419);
  
  year = new int[table.getRowCount()];
  mag = new float[table.getRowCount()];
  lat = new float[table.getRowCount()];
  lon = new float[table.getRowCount()];
  
  int counter = 0;
  
  for(TableRow row: table.rows()){
    year[counter] = row.getInt("yr");
    mag[counter] = row.getFloat("mag");
    lat[counter] = row.getFloat("glat");
    lon[counter] = row.getFloat("glon");
    println(year[counter] + " " + mag[counter] + " " + lat[counter] + " " + lon[counter]);
    counter++;
    
  }
  
  fixLat = new float[lat.length];
  fixLon = new float[lon.length];
  fixCoordinates();
  
  currentYear = year[0]; //Start at first year
  yearPosition = getYearPosition();
  earthquakeCount = numberEarthquakes();
  avgMag = limitPercentage(getAvgMag(yearPosition, earthquakeCount));
  
}

void draw(){
  background(255);
  image(img,0,0);
  createGradient(1600, 100, 80,540, c5, c3);
  drawEarthquakes();
  legendValues();
  displayValues();
  
}

void fixCoordinates(){
  float imgWidth = 1500;//Width of the image
  float imgHeight = 756;//Height of the image
  float xScale = imgWidth/360; //Full side to side longitude equals 360
  float yScale = imgHeight/180;//FUll top to bottom latitude equals 180
  float xDifferential = 180; //maximum value of longitude
  float yDifferential = 90;// maximum value of latitude
  
  for(int i = 0; i < fixLat.length; i++){
    fixLon[i] = ((lon[i] + xDifferential) * xScale);
    fixLat[i] = (((lat[i] * -1) + yDifferential) * yScale);
  }
  
}

//
void drawEarthquakes(){
  for(int i = yearPosition; i < (yearPosition + earthquakeCount); i++){
    color circleColor = changeColor(mag[i]);
    fill(circleColor);
    stroke(0);
    circle(fixLon[i],fixLat[i],7);
  }
  
}

//Find the starting position of the current year in the array of years
int getYearPosition(){
  
  for(int i = 0; i < year.length; i++){
    if(year[i] == currentYear){
      return i;
    }
  }
  
  return -1;
}

//Count the number of earthquakes in a given year
int numberEarthquakes(){
  int counter = 0;
  
  for(int i = 0; i < year.length; i++){
    if(year[i] == currentYear){
      counter++;
    }
  }
  
  return counter; 
}

//Get the average magnitude of the year
float getAvgMag(int yearPosition, int earthquakeCount){
  float avg = 0;
  for(int i = yearPosition; i < (yearPosition + earthquakeCount); i++){
    avg += mag[i];
  }
  
  return avg/earthquakeCount;
}

//Increment or decrement the year
void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT && currentYear != year[year.length - 1]) {
      currentYear++;
      yearPosition = getYearPosition();
      earthquakeCount = numberEarthquakes();
      avgMag = limitPercentage(getAvgMag(yearPosition, earthquakeCount));
      
    } else if (keyCode == LEFT && currentYear != year[0]) {
      currentYear--;
      yearPosition = getYearPosition();
      earthquakeCount = numberEarthquakes();
      avgMag = limitPercentage(getAvgMag(yearPosition, earthquakeCount));
    } 
  } 
}

//Create the gradient value by interpolating between 2 colors
//Based on example from Processing documentation example: https://processing.org/examples/lineargradient.html
void createGradient(int x, int y, float w, float h, color c1, color c2){
  
  noFill();
  
  for (int i = y; i <= y+h; i++) {
    float inter = map(i, y, y+h, 0, 1);
    color c = lerpColor(c1, c2, inter);
    stroke(c);
    line(x, i, x+w, i);
  }
}

//Change the value of the color based on passed in value
//Based on example from Processing documentation example: https://processing.org/examples/lineargradient.html
color changeColor(float mag){
  color c;
  if(mag <= 5.0){//Account for magnitude below 5
    c = c3;
  }else if(mag >= 9.0){//Account for magnitude above 9
    c = c5;
  }else{
    float inter = map(mag, 5, 9, 0, 1);//5 to 9 because of Magnitude
    c = lerpColor(c3, c5, inter);
  }
  
  return c;
}

//Limit the decimal place to avoid going off screen
float limitPercentage(float number){
  int decimal = 3;
  number = number * pow(10, decimal);
  number = number + .5;
  int retainer = int(number);
  number = retainer / pow(10, decimal);
  return number;
  
}

//Print the values of the gradient bar
void legendValues(){
  textSize(15);
  fill(0);
  text("EarthQuake Magnitude", 1550, 50);
  float startingMag = 5.0;
  float avgBarHeight = 540/4;
  float startYPosition = 645;
  float startXPosition = 1680;
  for(int i = 0; i < 5; i++){
    text("- " + startingMag, startXPosition, startYPosition);
    startingMag += 1.0;
    startYPosition -= avgBarHeight;
  }
}

//Display the values of the year, including the year, number of earthquakes, and the average magnitude
void displayValues(){
  textSize(20);
  fill(0);
  text("Year: " + currentYear, 50, 800);
  text("# Earthquakes: " + earthquakeCount, 200, 800);
  text("Avg. Magnitude: " + avgMag, 450, 800);
  text("Earthquake Data", 250,850);
  
  noFill();
  strokeWeight(3);
  rect(0,760,750,height);
  strokeWeight(1);//Reset Stroke
  
  
}
