//Gage Gutmann
//HW2
//CPSC 313
//2/18/20

Table table1;
Table table2;
int currentTeam = 0;
String currentName = "";
float padding = 10;
float paddingTop;
float paddingBottom;
float paddingRight;
float paddingLeft;
float rx = 0;
float ry = 0;
int [][] teamWins = new int[162][162];
int [][] teamLosses = new int [162][162];
float[][] teamAverage = new float[162][162];
String [] teamNames = new String[30];

void setup(){
  size(1024, 768);
  fill(0);
  background(255);
  //load tables
  table1 = loadTable("wins.csv");
  table2 = loadTable("losses.csv");
  
  //Set up 2D arrays
  teamWins = new int[table1.getRowCount()][table1.getColumnCount() - 1];
  teamLosses = new int[table2.getRowCount()][table2.getColumnCount() - 1];
  teamNames = new String[table1.getRowCount()];
  
  //Get the team names
  int counter = 0;
  for(TableRow row: table1.rows()){
    teamNames[counter] = row.getString(0);
    counter++;
  }
  
  currentName = teamNames[0];
  
  //Remove the names from the 1 column 
  table1.removeColumn(0);
  
  //Get win values
  counter = 0;
  for(TableRow row: table1.rows()){
    print(teamNames[counter] + " ");
    for(int j = 0; j < table1.getColumnCount(); j++){
      teamWins[counter][j] = row.getInt(j);
      print(teamWins[counter][j] + " ");
    }
    counter++;
    println();
  }
  
  table2.removeColumn(0);
  
  //Get losses values
  counter = 0;
  for(TableRow row: table2.rows()){
    print(teamNames[counter] + " ");
    for(int j = 0; j < table2.getColumnCount(); j++){
      teamLosses[counter][j] = row.getInt(j);
      print(teamLosses[counter][j] + " ");
    }
    counter++;
    println();
  }
  
  teamAverage = new float[table1.getRowCount()][table1.getColumnCount()];
  
  //Compute the average of each day based on wins and losses
  for(int i = 0; i < table1.getRowCount(); i++){
    print(teamNames[i] + " ");
    for(int j = 0; j < table1.getColumnCount(); j++){
      float gamesPlayed = teamWins[i][j] + teamLosses[i][j];
      if(gamesPlayed == 0.0){
        teamAverage[i][j] = 0;
      }else{
      teamAverage[i][j] = teamWins[i][j] / gamesPlayed;
      }
      print(teamAverage[i][j] + " ");
    }
    println();
  }
 
}

void draw(){
  background(255);
  textSize(100);
  changeColor(currentTeam);
  text(currentName, 700, paddingBottom);
  textSize(50);
  
  //Account for the percentage. If below .500, mark red, if above mark green
  if(teamAverage[currentTeam][table1.getColumnCount()-1] >=.5){
    fill(0,255,0);
  }else{
    fill(255,0,0);
  }
  
  //Get percentage 
  float percentage = limitPercentage(teamAverage[currentTeam][table1.getColumnCount()-1]);
  
  
  //Print the percentages, along with special cases
  if(currentTeam ==11){//Houston Astros Cheated
    text("*Win Percentage: " + percentage, 400, 100);
    fill(0);
    text("*Cheaters" , 400, 200);
    
  }else if(currentTeam ==29){//Wahington Nationals won the World Series
    text("**Win Percentage: " + percentage, 400, 100);
    fill(0);
    text("**2019 Champions" , 400, 200);
  }else{
    text("Win Percentage: " + percentage, 400, 100);
  }
  fill(0);
  drawLines();
}

void drawLines(){
  paddingTop = padding;
  paddingBottom = height - padding;
  paddingRight = width - padding;
  paddingLeft = padding;
  rx = paddingLeft;
  ry = paddingBottom;
  float scale = height - padding;
  
  float lineWidth = (paddingRight - paddingLeft) / table1.getColumnCount();
  
  for(int i = 0; i < table1.getRowCount(); i++){
    changeColor(i);
    noFill();
    beginShape();
    for(int j = 0; j < table1.getColumnCount(); j++){
      if(currentTeam == i){
      strokeWeight(5); //Emphasize the line if selected team
      vertex(rx, ry - (teamAverage[i][j]*scale));
      rx += lineWidth;
      
      }else{
      strokeWeight(1);
      vertex(rx, ry - (teamAverage[i][j]*scale));
      rx += lineWidth;
      }
    }
    endShape();
    rx = paddingLeft;
    stroke(0);
    fill(0);
    
  }
}

//Increment or decrement the team, and reset values with white before changing
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP && currentTeam != teamNames.length - 1) {
      fill(255);
      stroke(255);
      textSize(100);
      text(currentName, 700, paddingBottom);
      textSize(50);
      text("Win Percentage: " + teamAverage[currentTeam][table1.getColumnCount()-1], 400, 100);
      currentTeam++;
      currentName = teamNames[currentTeam];
      fill(0);
      stroke(0);
    } else if (keyCode == DOWN && currentTeam != 0) {
      fill(255);
      stroke(255);
      textSize(100);
      text(currentName, 700, paddingBottom);
      textSize(50);
      text("Win Percentage: " + teamAverage[currentTeam][table1.getColumnCount()-1], 400, 100);
      currentTeam--;
      currentName = teamNames[currentTeam];
      fill(0);
      stroke(0);
    } 
  } 
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


//Changes the color of the line and fill based on team
//RGB colors found at https://teamcolorcodes.com/
void changeColor(int number){
  
  if(number == 0){//ANA
    stroke(186,0,33);
    fill(186,0,33);
  }else if(number == 1){//ARI
    stroke(95, 37, 159);
    fill(95, 37, 159);
  }else if(number == 2){//ATL
    stroke(19, 39, 79);
    fill(19, 39, 79);
  }else if(number == 3){//BAL
    stroke(223,70,1);
    fill(223,70,1);
  }else if(number == 4){//BOS
    stroke(189, 48, 57);
    fill(189, 48, 57);
  }else if(number == 5){//CHA
    stroke(196,206,212);
    fill(196,206,212);
  }else if(number == 6){//CHN
    stroke(14,51,134);
    fill(14,51,134);
  }else if(number == 7){//CIN
    stroke(198,1,31);
    fill(198,1,31);
  }else if(number == 8){//CLE
    stroke(12,35,64);
    fill(12,35,64);
  }else if(number == 9){//COL
    stroke(51,0,111);
    fill(51,0,111);
  }else if(number == 10){//DET
    stroke(12,35,64);
    fill(12,35,64);
  }else if(number == 11){//HOU
    stroke(244,145,30);
    fill(244,145,30);
  }else if(number == 12){//KCA
    stroke(189,155,96);
    fill(189,155,96);
  }else if(number == 13){//LAN
    stroke(0,90,156);
    fill(0,90,156);
  }else if(number == 14){//MIA
    stroke(0,163,224);
    fill(0,163,224);
  }else if(number == 15){//MIL
    stroke(19,41,75);
    fill(19,41,75);
  }else if(number == 16){//MIN
    stroke(211,17,69);
    fill(211,17,69);
  }else if(number == 17){//NYA
    stroke(12,35,64);
    fill(12,35,64);
  }else if(number == 18){//NYN
    stroke(252,89,16);
    fill(252,89,16);
  }else if(number == 19){//OAK
    stroke(17,87,64);
    fill(17,87,64);
  }else if(number == 20){//PHI
    stroke(232,24,40);
    fill(232,24,40);
  }else if(number == 21){//PIT
    stroke(253,184,39);
    fill(253,184,39);
  }else if(number == 22){//SDN
    stroke(0,45,98);
    fill(0,45,98);
  }else if(number == 23){//SEA
    stroke(0,92,92);
    fill(0,92,92);
  }else if(number == 24){//SFN
    stroke(253,90,30);
    fill(253,90,30);
  }else if(number == 25){//SLN
    stroke(196,30,58);
    fill(196,30,58);
  }else if(number == 26){//TBA
    stroke(9,44,92);
    fill(9,44,92);
  }else if(number == 27){//TEX
    stroke(192,17,31);
    fill(192,17,31);
  }else if(number == 28){//TOR
    stroke(0,107,166);
    fill(0,107,166);
  }else if(number == 29){//WAS
    stroke(171,0,3);
    fill(171,0,3);
  }else{
    stroke(0);
  }
}
