//Gage Gutmann
//CPSC 313
//Final_Project


PImage img;
Table table;

String current_airport_code = "ATL";
String current_airport_name = "Atlanta, GA: Hartsfield-Jackson Atlanta International";

String [] airport_code = new String[1];
String [] airport_name = new String[1];

String [] time_label = new String[1];
int [] time_month = new int[1];
String [] time_month_name = new String[1];
int [] time_year = new int[1];

int [] num_delays_carrier = new int[1];
int [] num_delays_late_aircraft = new int[1];
int [] num_delays_NAS = new int[1];
int [] num_delays_security = new int[1];
int [] num_delays_weather = new int[1];

int [] flights_cancelled = new int[1];
int [] flights_delayed = new int[1];
int [] flights_diverted = new int[1];
int [] flights_onTime = new int[1];
int [] flights_total = new int[1];


String [] airport_code_single = new String[1];
String [] airport_name_single = new String[1];

//Airport X/Y positions on map
float [] airportX = {720,905,815,825,830,375,460,715,870,820,840,515,870,160,95,850,785,630,815,550,630,90,835,220,115,115,50,235,770};
float [] airportY = {415,185,275,360,285,285,460,200,255,560,300,530,215,330,370,200,515,265,595,180,240,105,250,410,405,65,290,255,540};

float dotSize = 8.0;//Can change to accomodate map  

void setup(){
  size(1920,1080);
  background(255);
  img = loadImage("u.s_map_resized.jpg");
  table = loadTable("airlines.csv", "header");
  
  
  //airport arrays
  airport_code = new String[table.getRowCount()];
  airport_name = new String[table.getRowCount()];
  
  //time arrays
  time_label = new String[table.getRowCount()];
  time_month = new int[table.getRowCount()];
  time_month_name = new String[table.getRowCount()];
  time_year = new int[table.getRowCount()];
  
  //num_delays arrays
  num_delays_carrier = new int[table.getRowCount()];
  num_delays_late_aircraft = new int[table.getRowCount()];
  num_delays_NAS = new int[table.getRowCount()];
  num_delays_security = new int[table.getRowCount()];
  num_delays_weather = new int[table.getRowCount()];
  
  //flights arrays
  flights_cancelled = new int[table.getRowCount()];
  flights_delayed = new int[table.getRowCount()];
  flights_diverted = new int[table.getRowCount()];
  flights_onTime = new int[table.getRowCount()];
  flights_total = new int[table.getRowCount()];
  
  //min_delayed arrays - never used, but can be for the future
  int [] min_delayed_carrier = new int[table.getRowCount()];
  int [] min_delayed_late_aircraft = new int[table.getRowCount()];
  int [] min_delayed_NAS = new int[table.getRowCount()];
  int [] min_delayed_security = new int[table.getRowCount()];
  int [] min_delayed_weather = new int[table.getRowCount()];
  int [] min_delayed_total = new int[table.getRowCount()];
  
  int counter = 0;
  
  //Get all data
  for(TableRow row: table.rows()){
    airport_code[counter] = row.getString("Airport.Code");
    airport_name[counter] = row.getString("Airport.Name");
    
    time_label[counter] = row.getString("Time.Label");
    time_month[counter] = row.getInt("Time.Month");
    time_month_name[counter] = row.getString("Time.Month Name");
    time_year[counter] = row.getInt("Time.Year");
    
    num_delays_carrier[counter] = row.getInt("Statistics.# of Delays.Carrier");
    num_delays_late_aircraft[counter] = row.getInt("Statistics.# of Delays.Late Aircraft");
    num_delays_NAS[counter] = row.getInt("Statistics.# of Delays.National Aviation System");
    num_delays_security[counter] = row.getInt("Statistics.# of Delays.Security");
    num_delays_weather[counter] = row.getInt("Statistics.# of Delays.Weather");
    
    flights_cancelled[counter] = row.getInt("Statistics.Flights.Cancelled");
    flights_delayed[counter] = row.getInt("Statistics.Flights.Delayed");
    flights_diverted[counter] = row.getInt("Statistics.Flights.Diverted");
    flights_onTime[counter] = row.getInt("Statistics.Flights.On Time");
    flights_total[counter] = row.getInt("Statistics.Flights.Total");
    
    min_delayed_carrier[counter] = row.getInt("Statistics.Minutes Delayed.Carrier");
    min_delayed_late_aircraft[counter] = row.getInt("Statistics.Minutes Delayed.Late Aircraft");
    min_delayed_NAS[counter] = row.getInt("Statistics.Minutes Delayed.National Aviation System");
    min_delayed_security[counter] = row.getInt("Statistics.Minutes Delayed.Security");
    min_delayed_weather[counter] = row.getInt("Statistics.Minutes Delayed.Weather");
    min_delayed_total[counter] = row.getInt("Statistics.Minutes Delayed.Total");
    
    counter++;
  }
  
  //Find number of airports
  String airport_code_check = airport_code[0];
  counter = 1;
  while(!airport_code[counter].equals(airport_code_check)){
    counter++;
  }
  
  //Arrays with non-repeated airports
  airport_code_single = new String[counter];
  airport_name_single = new String[counter];
  
  for(int i = 0; i< airport_code_single.length; i++){
    airport_code_single[i] = airport_code[i];
    airport_name_single[i] = airport_name[i];
    println(airport_code_single[i] + " " + airport_name_single[i]);
  }
  
}

void draw(){
  background(#FFFFED);
  image(img,0,0); //(960,668)
  fill(0);
  text("x: "+mouseX+" y: "+mouseY, 10, 15);
  drawAirports(airport_code_single, airport_name_single);
  drawData();
  drawAirports(airport_code_single, airport_name_single); //This makes sure the graphs don't cover up the pop-ups on the map

}

//Draws the airports to the map in the form of circle
void drawAirports(String [] airport_code, String [] airport_names){
  
  fill(0);
  //Draws airports. If hovered over, enlarge size
  for(int i = 0; i < airportX.length; i++){
    if((mouseX <= (airportX[i] + dotSize)) && (mouseX >= (airportX[i] - dotSize)) && (mouseY <= (airportY[i] + dotSize)) && (mouseY >= (airportY[i] - dotSize))){
      circle(airportX[i],airportY[i],dotSize * 3);//Change size
      fill(255);
      rect(airportX[i] + 30, airportY[i] - 30, 375,30);
      fill(0);
      text(airport_code[i] + ", " + airport_names[i], airportX[i] + 50, airportY[i]-10);

    }else{
      circle(airportX[i],airportY[i],dotSize);//normal size
    }
  }
  
  
  //Hard Code Values. Use for Reference
  /*
  circle(720,415,dotSize);//ATL
  circle(905,185,dotSize);//BOS
  circle(815,275,dotSize);//BWI
  circle(825,360,dotSize);//CLT
  circle(830,285,dotSize);//DCI
  circle(375,285,dotSize);//DEN
  circle(715,200,dotSize);//DFW
  circle(870,255,dotSize);//EWR
  circle(820,560,dotSize);//FLL
  circle(840,300,dotSize);//IAD
  circle(515,530,dotSize);//IAH
  circle(870,215,dotSize);//JFK
  circle(160,330,dotSize);//LAS
  circle(95,370,dotSize);//LAX
  circle(850,200,dotSize);//LGA
  circle(785,515,dotSize);//MCO
  circle(630,265,dotSize);//MDW
  circle(815,595,dotSize);//MIA
  circle(550,180,dotSize);//MSP
  circle(630,240,dotSize);//ORD
  circle(90,105,dotSize);//PDX
  circle(835,250,dotSize);//PHL
  circle(220,410,dotSize);//PHX
  circle(115,405,dotSize);//SAN
  circle(115,65,dotSize);//SEA
  circle(50,290,dotSize);//SFO
  circle(235,255,dotSize);//SLC
  circle(770,540,dotSize);//TPA
  */
  
  
}


//Used to change the airport information into global variable 
void mouseClicked(){
  
 for(int i = 0; i < airportX.length; i++){
  if((mouseX <= (airportX[i] + dotSize)) && (mouseX >= (airportX[i] - dotSize)) && (mouseY <= (airportY[i] + dotSize)) && (mouseY >= (airportY[i] - dotSize))){
    current_airport_code = airport_code_single[i];
    current_airport_name = airport_name_single[i];
    }
  }
 }
 


//Extracts data to focus on one airport, makes calculations, and draws the data to the screen
void drawData(){
  String testCode = current_airport_code;//Set equal to the global variable
  int count = 0;
  for(int i = 0; i < airport_code.length; i++){
    if(airport_code[i].equals(testCode)){
      count++;
    }
  }
  //println(count); //Length 152
  
  String[] current_time_label = new String[count];
  int [] current_time_month = new int[count];
  String [] current_time_month_name = new String[count];
  int [] current_time_year = new int[count];
  
  int [] current_num_delays_carrier = new int[count];
  int [] current_num_delays_late_aircraft = new int[count];
  int [] current_num_delays_NAS = new int[count];
  int [] current_num_delays_security = new int[count];
  int [] current_num_delays_weather = new int[count];
  
  int [] current_flights_cancelled = new int[count];
  int [] current_flights_delayed = new int[count];
  int [] current_flights_diverted = new int[count];
  int [] current_flights_onTime = new int[count];
  int [] current_flights_total = new int[count];
  
  int j = 0;
  
  for(int i = 0; i < airport_code.length; i++){
    if(airport_code[i].equals(testCode)){
      
      current_time_label[j] = time_label[i];
      current_time_month_name[j] = time_month_name[i];
      current_time_month[j] = time_month[i]; 
      current_time_year[j] = time_year[i];
      
      current_num_delays_carrier[j] = num_delays_carrier[i];
      current_num_delays_late_aircraft[j] = num_delays_late_aircraft[i];
      current_num_delays_NAS[j] = num_delays_NAS[i];
      current_num_delays_security[j] = num_delays_security[i];
      current_num_delays_weather[j] = num_delays_weather[i];
      
      current_flights_cancelled[j] = flights_cancelled[i];
      current_flights_delayed[j] = flights_delayed[i];
      current_flights_diverted[j] = flights_diverted[i];
      current_flights_onTime[j] = flights_onTime[i];
      current_flights_total[j] = flights_total[i];
  
      j++;
    }
  }
  
  int total_delays_carrier = 0;
  int total_delays_late = 0;
  int total_delays_NAS = 0;
  int total_delays_security = 0;
  int total_delays_weather = 0;
  
  int total_flights_cancelled = 0; //Never used
  int total_flights_delayed = 0;
  int total_flights_diverted = 0; //Never used
  int total_flights_onTime = 0;
  int total_flights_total = 0;
  
  for(int i = 0; i < current_time_label.length; i++){
    
    total_delays_carrier += current_num_delays_carrier[i];
    total_delays_late += current_num_delays_late_aircraft[i];
    total_delays_NAS += current_num_delays_NAS[i];
    total_delays_security += current_num_delays_security[i];
    total_delays_weather += current_num_delays_weather[i];
    
    total_flights_cancelled += current_flights_cancelled[i];
    total_flights_delayed += current_flights_delayed[i];
    total_flights_diverted += current_flights_diverted[i];
    total_flights_onTime += current_flights_onTime[i];
    total_flights_total += current_flights_total[i];
    
  }
  
  //Take the number of years
  int numYears = current_time_year[current_time_year.length - 1] - current_time_year[0] + 1; //Last minus first plus 1 to include first
  
  
  //Draw important information to the screen
  textSize(22);
  text("Airport: " + current_airport_code + " : " + current_airport_name, 70, 700);
  textSize(16);
  text("Showing: " + current_time_year[0] + " - " + current_time_year[current_time_year.length-1], 350,730);
  textSize(18);
  text("Delays Information", 90, 780);
  textSize(14);
  text("#-Delays by Carrier: " + total_delays_carrier, 90,820);
  text("#-Delays by Late Aircraft: " + total_delays_late, 90,840);
  text("#-Delays by NAS: " + total_delays_NAS, 90,860);
  text("#-Delays by Security: " + total_delays_security, 90,880);
  text("#-Delays by Weather: " + total_delays_weather, 90, 900);
  text("#-Delays Total: " + total_flights_delayed, 90, 920);
  
  textSize(18);
  text("On-Time Information", 600,780);
  textSize(14);
  text("On-Time Flights: " + total_flights_onTime, 600,820);
  text("Total Flights: " + total_flights_total, 600, 840);
  
  textSize(12);
  text("*Instructions: Hover over map and click to view data. For charts, hover over to view information", 70, 980);
  text("**Information for 2016 only contains the month of January",70, 1000);
  textSize(14);
  

  
  //Draw the Bar Graph for total delays by Year
  float xPadding = 20;
  float yPadding = 40;
  float yaxisHeight = (height/2) - (yPadding*2); //Never used
  float xaxisWidth = (width - 960) - (xPadding*2);//Never used

  fill(255);
  rect(width - (width-960), height/2, width - 960 - xPadding, height/2 - yPadding);
  
  //Draw x axis line
  line(width - (width-960) + xPadding, height - yPadding*3, width - xPadding * 2, height  - yPadding*3); 
  //Draw y axis line
  line(width - (width-960) + xPadding, height/2 + yPadding, width - (width-960) + xPadding, height - yPadding*3);


  
  float xBarLeft = width - (width-960) + xPadding;
  float xBarRight = width - xPadding * 2;
  float yBarTop = height/2 + yPadding;
  float yBarBottom = height - yPadding*3;
  
  //println(xBarLeft);
  
  float xScale = xBarRight - xBarLeft;
  float yScaleBar = (yBarBottom - yBarTop)*8;
  
  //x axis title
  fill(0);
  text("# Delays Per Year",xBarLeft + .4 *(xScale), height - yPadding*2);
  
  
  
  fill(255);
  //Draw Line Chart percentage of on time flights 
  
  rect(width - (width-960), 0, width - 960 - xPadding, height/2 - yPadding);
  
  //Draw x axis line
  line(width - (width-960) + xPadding, height/2 - yPadding*3, width - xPadding * 2, height/2  - yPadding*3); 
  //Draw y axis line
  line(width - (width-960) + xPadding, 0 + yPadding, width - (width-960) + xPadding, height/2 - yPadding*3);
  
  float xLineLeft = width - (width-960) + xPadding;
  float xLineRight = width - xPadding * 2; //Never used
  float yLineTop = 0 + yPadding; //Never used
  float yLineBottom = height/2 - yPadding*3;
  
  fill(0);
  text("On-Time Average Per Year",xLineLeft + .4 *(xScale), height/2 - yPadding*2);
  
  
  
  
  
  //Find Delays, On TimeFlights by Year, Total Flights by Year, and List of Years
  int [] delays_by_year = new int[numYears];
  int [] onTime_flights_by_year = new int[numYears];
  int [] total_flights_by_year = new int [numYears];
  String [] list_year = new String[numYears];
  
  //String of list of years
  for(int i = 0; i < list_year.length; i++){
    list_year[i] = "" + (current_time_year[0] + i);
  }
  
  int year = current_time_year[0];
  
  int step = 0;
  
  for(int i = 0; i < current_time_year.length;i++){
    if(year == current_time_year[i]){
      delays_by_year[step] += current_flights_delayed[i];
      onTime_flights_by_year[step] = current_flights_onTime[i];
      total_flights_by_year[step] = current_flights_total[i];
      //list_year[step] = year;
    }else{
      step++;
      year = current_time_year[i];
      delays_by_year[step] += current_flights_delayed[i];
      onTime_flights_by_year[step] = current_flights_onTime[i];
      total_flights_by_year[step] = current_flights_total[i];
      //list_year[step] = year;
    }
    
  }
    
  //Cook delays with yScaleBar
  float [] cooked_delays = new float[delays_by_year.length];
  
  for(int i = 0; i < delays_by_year.length; i++){
    cooked_delays[i] = ((delays_by_year[i]*1.0)/total_flights_delayed)*yScaleBar;
  }
  
  
  
  float positionX = xBarLeft;
  fill(90,20,60);//Bar color - purple
  stroke(0);
  float positionY = yBarBottom;
  float endX = xBarRight;
  float barWidth = (endX - positionX)/cooked_delays.length;
  float gap = (1.0/cooked_delays.length) * barWidth;
  barWidth = barWidth - gap;
  
  
  //Draws bars. Highlights if the mouse is over it
  for(int i = 0; i < cooked_delays.length; i++){
    if((mouseX <= positionX + barWidth) && (mouseX >= positionX) && (mouseY <= positionY) && (mouseY >=positionY - cooked_delays[i])){
      strokeWeight(4);
      rect(positionX, positionY-cooked_delays[i], barWidth, cooked_delays[i]);
      fill(255);
      rect(width - (barWidth*4) - xPadding, height/2, barWidth*4, 30);
      strokeWeight(1);
      fill(0);
      text("Flight Delays in " + list_year[i] + " = " + delays_by_year[i], width - (barWidth*4) - xPadding + 10, height/2 + 20);
      
    }else{
      strokeWeight(1);
      rect(positionX, positionY-cooked_delays[i], barWidth, cooked_delays[i]);
    }
    fill(0);
    text(list_year[i], positionX, yBarBottom + 15);
    fill(90,20,60);
    positionX += gap + barWidth;
  }
    
  
  //cooked average on time flights with total flights and scaling
  float yScaleLine = (yBarBottom - yBarTop);
  float[] cooked_flights = new float[onTime_flights_by_year.length];
  
  for(int i = 0; i < onTime_flights_by_year.length; i++){
    cooked_flights[i] = ((onTime_flights_by_year[i]*1.0)/total_flights_by_year[i]) * yScaleLine;
    println((i+1) + ": " + cooked_flights[i]);
  }
  
  
  //draw the vertexs and dots for the line graph. Expand if hovered over.
  positionX = xLineLeft;
  noFill();
  beginShape();
  strokeWeight(3);
  for(int i = 0; i < cooked_flights.length; i++){
    vertex(positionX, yLineBottom - cooked_flights[i]);
    fill(0);
    if((mouseX <= positionX + dotSize) && (mouseX >= positionX - dotSize) && (mouseY <= yLineBottom - cooked_flights[i] +dotSize) && (mouseY >= yLineBottom - cooked_flights[i]-dotSize) ){
      circle(positionX, yLineBottom - cooked_flights[i], dotSize * 3);
      fill(255);
      //rect(positionX - (barWidth/2), yLineBottom - cooked_flights[i]- 30, barWidth * 4,30);
      rect(width - (barWidth*4) - xPadding, 0, barWidth*4, 30);
      fill(0);
      text("Percent Average for: " + list_year[i] + " = " + (limitPercentage(((onTime_flights_by_year[i]*1.0)/total_flights_by_year[i]))*100) + "%", width - (barWidth*4) - xPadding + 10, 20);
    }else{
      circle(positionX, yLineBottom - cooked_flights[i], dotSize);
    }

    text(list_year[i], positionX, yLineBottom + 15);
    noFill();
    positionX += barWidth;
  }
  endShape();
  stroke(0);
  strokeWeight(1);
  fill(0);
  
  //Compute and Output Averages
  float average_delay_per_year = 0.0;
  
  for(int i = 0; i < delays_by_year.length; i++){
    average_delay_per_year += delays_by_year[i];
  }
  
  average_delay_per_year = (average_delay_per_year/(delays_by_year.length));
  
  text("Average Delays per Year: " + average_delay_per_year, 90,940);
  
  
  
  float average_onTime_per_year = 0.0;
  
  for(int i = 0; i < onTime_flights_by_year.length; i++){
    average_onTime_per_year += onTime_flights_by_year[i];
  }
  
  average_onTime_per_year = average_onTime_per_year/ onTime_flights_by_year.length;
  
  text("Average On-Time Flights per Year: " + average_onTime_per_year, 600, 880);
  
  float percent_average_total = 0.0;
  
  for(int i = 0; i < total_flights_by_year.length; i++){
    percent_average_total += (onTime_flights_by_year[i]*1.0)/total_flights_by_year[i];
  }
  
  percent_average_total = (limitPercentage((percent_average_total/ total_flights_by_year.length)) * 100);
  
  text("Percent Average on Total Years: " + percent_average_total + "%", 600,860);

}

//Limit the decimal place to avoid going off screen
float limitPercentage(float number){
  int decimal = 2;
  number = number * pow(10, decimal);
  number = number + .5;
  int retainer = int(number);
  number = retainer / pow(10, decimal);
  return number;
  
}
