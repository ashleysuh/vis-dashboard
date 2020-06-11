
public class HistogramChart extends frame {

  int idx;
  FloatList yList = new FloatList();
  int [] binCounter;
  Table data;
  HashMap<Integer, Integer> binRange = new HashMap<Integer,Integer>();
  
  public HistogramChart(Table _data, int _idx ){
    idx = _idx;
    data = _data;
  }
  
  void draw(){  
    // draws labels, axis lines
    drawLabels();
    binRange.clear();
    yList = table.getFloatList(idx);
    // calculate how many items are in each bin
    calculateBins();
    
    //println(bins);
    
    for( int i = 0; i < binCounter.length; i++ ){
      int numItems = binCounter[i];
      //println(numItems);
      float xPos = map(i, 0, bins, u0, w );
      float yPos = map(numItems, min(binCounter), max(binCounter), v0+h-15, v0);
      float rw = (w-u0)/bins;
     
      fill(0);
      
      if( mouseX > xPos && mouseX < xPos+rw && mouseY > yPos && mouseY < h+v0 ){
        //text(numItems, xPos+(rw/2), yPos+10);  
        strokeWeight(2);
      }
      else
        strokeWeight(1);
        
      fill(100,149,237,50);
      rect( xPos, yPos, rw, h+v0-yPos);
      fill(0);
      if( mouseX > xPos && mouseX < xPos+rw && mouseY > yPos && mouseY < h+v0 )
        text(numItems, xPos+(rw/2), yPos+15);  
        
      strokeWeight(1);
    }

    drawAxis();
    
  }
  
  void drawAxis(){
    strokeWeight(1);
    fill(0);
    stroke(0);
    line( u0-1, v0, u0-1, h+v0); // y-axis line
    line( u0, h+v0+1, w, h+v0+1 ); // x-axis line
    
    for( int i = 0; i < bins+1; i++ ){    
      stroke(0);
      textFont(f,9);
      float xTick = map(i, 0, bins, u0, w);

      if( i == bins ){
        line(xTick, v0+h, xTick, v0);
      }
      else
        line(xTick, v0+h-5, xTick, v0+h+3);
      
      // text for axes
      text(i, xTick, v0+h+15);
      textAlign(CENTER, BOTTOM);
    }
    
    for( int i = 0; i < 11; i++ ){    
      stroke(0);
      textFont(f,9);
      
      // y-axis (horizontal lines)
      stroke(0);
      float yTick = map(i, 0, 10, v0+h-15, v0);
      
      if( i == 10 ){
        line(u0-4, yTick, w, yTick );
      }
      else{
        line(u0-4, yTick, u0, yTick );
      }
      
      // values to map x-y range tick marks
      float yValue = map(i, 0, 10, min(binCounter), max(binCounter));
      
      // text for axes
      if( i == 10 ){
        text(round(yValue), u0-15, yTick+9);
      }
      else if( i == 0 ){
        text(round(yValue), u0-15, yTick+2);
      }
      else{
        text(round(yValue), u0-15, yTick+5);
      }
    }
  }
  
  void calculateBins(){
    yList = table.getFloatList(idx);
    
    for( int i = 0; i < bins; i++ ){
      binRange.put(i, i);
    }
      
    // container to hold how many items are in each bin
    binCounter = new int[bins];
    for( int i = 0; i < binCounter.length; i++ ){
      binCounter[i] = 0;  
    }
    
    // iterate over each row to put into correct bin
    for( int i = 0; i < table.getRowCount(); i++ ){
      float binVal = floor( bins * (yList.get(i) - yList.min()) / (yList.max() - yList.min()));
      
      // start case by case to see which bin this item belongs to
      for( int k: binRange.keySet() ){
        if( binVal <= binRange.get(k) ){
          // successul find, value is inside this bin   
          int counter = binCounter[k];
          binCounter[k] = ++counter;
          break;
        }
      } 
    }  
  }
  
  void drawLabels(){
    textFont(f, 14);
    strokeWeight(1.2);
    stroke(0);
    fill(0); 
    
    float x_label1 = u0-25;
    float x_label2 = (h+(2*v0))/2;
    pushMatrix();
    translate( x_label1,x_label2 );
    rotate( -HALF_PI );        
    textFont( fb, 12 );
    text( "frequency", 0, 0 );
    popMatrix();
    
    textFont(fb, 12);
    text(table.getColumnTitle(idx) + " ranges by bin", (w+u0)/2, v0+h+30);
  }
  
  void mousePressed(){}
}