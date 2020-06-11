/*
  Author: Ashley Suh
  Project #7: 4/9/2018
  CIS 4930: Data Visualization

  README: 
  
  1. You can hover over the barchart, linechart, or zoomed in scatterplot to view data info
  2. You can hover over histogram bars to see precise frequency number
  3. Click on a scatterplot matrix to see a zoomed in version in the bottom right corner.
     Every click will also update the legend correctly.
  4. Hovering over a scatterplot matrix will show the axes (x-axis & y-axis, respectively).
  5. You can (+) or (-) the "choose bins" to change how many bins the histogram shows [2, 20] range 
  
  Datasets to use: srsatact.csv, iris.csv
*/

Table table; 
PFont f, fb;
int counterY = 0;
int clickBuffer = 2;
int bins = 5;
boolean plot = false;
int hoveredValue = -1;

frame BC = null;
frame LC = null;
frame [] HCs;
frame ScatterMatrix = null;
frame ScatterPlot = null;

void setup(){
  size(1200, 800);
  smooth(8);
  selectInput("Select an input file to view", "loadData");
  f = createFont("Arial", 16, true);
  fb = createFont("Arial Bold", 14, true);
  textAlign(CENTER, BOTTOM);
}

void draw(){
  background( 255 );
  
  if( BC != null ){
    BC.setPosition(50, 15, 635, 800/3 - 90);
    BC.draw();
  }
  
  if( LC != null ){
    LC.setPosition(50, 800/3 - 45, 635, 800/3-80 );  
    LC.draw();
  }

  if( HCs != null ){
    HCs[0].setPosition(785, 15, 960, 800/3-100);
    HCs[0].draw();
    
    HCs[1].setPosition(1015, 15, 1190, 800/3-100);
    HCs[1].draw();
    
    HCs[2].setPosition(785, 800/3-35, 960, 800/3-100);
    HCs[2].draw();
    
    HCs[3].setPosition(1015, 800/3-35, 1190, 800/3-100);
    HCs[3].draw();
  }
  
  if( ScatterMatrix != null ){
    ScatterMatrix.setPosition(0, 1300/3, 360, 1120/3 - 5);
    ScatterMatrix.draw();
  }
  
  // draws borders
  line(355, 1300/3, 355, 800);
  
  // draws borders for histogram
  line(740, 800/3 - 50, 1200, 800/3 - 50);
  line(975, 13, 975, 1300/3);
  
  strokeWeight(2);
  line(740, 1300/3, 1200, 1300/3);
  line(0, 1300/3, 740, 1300/3);
  line(740, 0, 740, 800);
  strokeWeight(1);
}

abstract class frame {
  int u0, v0, w, h;
  void setPosition( int u0, int v0, int w, int h ){
    this.u0 = u0;
    this.v0 = v0;
    this.w = w;
    this.h = h;
  }
  abstract void draw();
  abstract void mousePressed();
  
  boolean mouseInside(){
    return (u0-clickBuffer < mouseX) && (u0+w+clickBuffer)>mouseX && (v0-clickBuffer)< mouseY && (v0+h+clickBuffer)>mouseY; 
  }
}

void mousePressed(){
  ScatterMatrix.mousePressed();  
  BC.mousePressed();
}

void loadData(File selection) {
  if( selection == null ) {
    println("Window was closed or the user hit cancel.");
    selectInput("Select a file to process:", "fileSelected");
  } 
  else {
    println( "User selected " + selection.getAbsolutePath() );
    table = loadTable( selection.getAbsolutePath(), "header" );
    
    ArrayList<Integer> allColumns = new ArrayList<Integer>();
    for(int i = 0; i < table.getColumnCount(); i++){
      if( !Float.isNaN( table.getRow( 0 ).getFloat(i) ) ){
        allColumns.add(i);
      }
      else{
      }
    }
    BC = new BarChart(table);
    LC = new LineChart(table);
    HCs = new HistogramChart[4];
    for( int i = 0; i < 4; i++ ){
      frame HC = new HistogramChart(table, i);
      HCs[i] = HC;
    }
    
    //PCPlot = new ParallelCoord( table, allColumns );
    ScatterMatrix = new Splom( allColumns );
    ScatterPlot = new Scatterplot( table, 0, 1 );
  }
}