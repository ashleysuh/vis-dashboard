

class LineChart extends frame {
  Table data, data_sorted;
  FloatList yList = new FloatList();
  
  public LineChart ( Table _data ){
    data = _data;
    data_sorted = _data;
  }
  
  void draw(){  
    yList = data.getFloatList(counterY);

    
    textAlign(CENTER, BOTTOM);
    textFont(f, 14);
    strokeWeight(1.2);
    stroke(0);
    fill(0);    
    
    if( hoveredValue > -1 )
      text("x-value: " + hoveredValue + ", y-value: " + yList.get(hoveredValue), (w+u0)/2, v0+15);
    
    textFont(fb, 12);
    text("x-axis: row ID value", (w+u0)/2, v0+h+25);
    
    float x_label1 = u0-30;
    float x_label2 = 1.5*(h+v0)/2;
    pushMatrix();
    translate( x_label1,x_label2 );
    rotate( -HALF_PI );        
    textFont( fb, 12 );
    text( "y-axis: " + table.getColumnTitle(counterY) + " value", 0, 0 );
    popMatrix();
    
    fill(0);
    stroke(153);
    
    line( u0, v0, u0, h+v0); // y-axis line
    line( u0, h+v0, w, h+v0 ); // x-axis line
    
    for( int i = 0; i < 11; i++ ){    
      stroke(0);
      textFont(f,9);
      float xTick = map(i, 0, 10, u0+5, w-5);

      if( i == 10 ){
        stroke(0,0,0,50);
        line(xTick+5, v0+h, xTick+5, v0);
        stroke(0);
      }
      line(xTick, v0+h-5, xTick, v0+h+3);
      
      // y-axis (horizontal lines)
      stroke(0);
      float yTick = map(i, 0, 10, v0+h-10, v0+10);
      if( i == 10 ){
       stroke(0,0,0,50);
       line(u0, v0, w, v0);
       stroke(0);
      }
      line(u0-3, yTick, u0+3, yTick );
      
      // values to map x-y range tick marks
      float xValue = map(i, 0, 10, 0, table.getRowCount());
      float yValue = map(i, 0, 10, yList.min(), yList.max());
      
      // text for axes
      text(String.format("%.1f",yValue), u0-17, yTick+5);
      if( i == 10 )
        textAlign(RIGHT, BOTTOM);
      else if( i == 0 )
        textAlign(LEFT, BOTTOM);
      text(String.format("%.0f",xValue), xTick, v0+h+15);
      textAlign(CENTER, BOTTOM);
    }
    
    for( int i = 0; i < table.getRowCount(); i++ ){
      fill(0);
      float x = map(i, 0, table.getRowCount(), u0+5, w-5);
      float y = map( yList.get(i), yList.min(), yList.max(), v0+h-10, v0+10 );
      float colorRange = map(yList.get(i), yList.min(), yList.max(), 255, 0);
      
      if( i < table.getRowCount() - 1 ){
        stroke(0, 0, 0, 100);
        strokeWeight(1);
        float y2 = map( yList.get(i+1), yList.min(), yList.max(), v0+h-10, v0+10 );
        float x2 = map(i+1, 0, table.getRowCount(), u0+5, w-5);
        line(x, y, x2, y2);
      }
      
      //float rw = w/table.getRowCount();
      if( i == hoveredValue ){
        stroke(100, colorRange, 255);
        strokeWeight(2);
        fill(100, colorRange, 255);
        ellipse(x, y, 8, 8);
        stroke(0);
      } 
      else if( (mouseX >= x-5 && mouseX <= x+5) && (mouseY >= y-5 && mouseY <= y+2) ){
        stroke(100, colorRange, 255);
        strokeWeight(2);
        fill(100, colorRange, 255);
        ellipse(x, y, 8, 8);
        hoveredValue=i;
        stroke(0);
      }
      else{
        stroke(0,0,125);
        fill(100, colorRange, 255);
        strokeWeight(0.3);
        ellipse(x, y, 5, 5);
        stroke(0);
        fill(0);
      }
    }
  }
  
  void mousePressed(){}
}