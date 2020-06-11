
public class BarChart extends frame {
  FloatList colorRanges = new FloatList();
  FloatList ranges = new FloatList();
  FloatList yList = new FloatList();
  Table data;
  
  public BarChart( Table _data ){
    data = _data;
  }
  
  void draw(){  
    chooseAxis();
    chooseBins();
    yList = data.getFloatList(counterY);    
    drawLabels();
    drawAxis();
    
    colorRanges.clear();
    ranges.clear();
    
    // draw std dev and mean
    float mean = 0;
    for( float f: yList ){
      mean += f;
    }
    mean = mean / yList.size();
    
    float std_dev = 0;
    for( float f: yList ){
      std_dev += sq(f - mean);
    }
    std_dev = sqrt( std_dev / yList.size() );
    
    textFont(fb, 13);
    textAlign(LEFT, BOTTOM);
    text("mean: " + String.format("%.2f", mean), u0+5, v0+h+28);
    textAlign(RIGHT, BOTTOM);
    text("std. dev.: " + String.format("%.2f",std_dev), w-5, v0+h+28);
    textAlign(CENTER, BOTTOM);
      
    for( int i = 0; i < table.getRowCount(); i++ ){
      strokeWeight(1);
      // map positions from u0->w
      float xPos = map(i, 0, table.getRowCount(), u0+5, w-5);
      float yPos = map(yList.get(i), yList.min(), yList.max(), v0+h-10, v0+10); 
      float rw = ((w-10)-(u0+10))/table.getRowCount();
      float colorRange = map(yList.get(i), yList.min(), yList.max(), 255, 0);
      fill(100, colorRange, 255);
      colorRanges.append(colorRange);
      ranges.append(yList.get(i));
      
      // check if hovering over a bar, then highlight for everything
      if( hoveredValue == i ){
        stroke(100, colorRange, 255);
        strokeWeight(3);
        fill(100, colorRange, 255);
        rect( xPos, yPos, rw, h+v0-yPos);
      }
      else if( (mouseX >= xPos && mouseX <= xPos+rw) && (mouseY >= yPos && mouseY <= v0+h) ){
        stroke(100, colorRange, 255);
        strokeWeight(3);
        fill(100, colorRange, 255);
        rect( xPos, yPos, rw, h+v0-yPos );
        hoveredValue = i;
      }
      else{
        strokeWeight(0.1);
        fill(100, colorRange, 255);
        stroke(255);
        rect( xPos, yPos, rw, h+v0-yPos);
      }
      strokeWeight(1);
    }
    drawLegend();
  }
  
  void drawLabels(){
    textFont(f, 13);
    text("Bar Chart (top)", u0+w+5, v0+15);
    text("Line Chart (bot)", u0+w+5, v0+30);
    
    textFont(f, 14);
    stroke(0);
    fill(0);    
    
    if( hoveredValue > -1 )
      text("x-value: " + hoveredValue + ", y-value: " + yList.get(hoveredValue), (w+u0)/2, v0+15);
    
    textFont(fb, 12); 
    float x_label1 = u0-30;
    float x_label2 = (h+v0)/2;
    pushMatrix();
    translate( x_label1,x_label2 );
    rotate( -HALF_PI );        
    textFont( fb, 12 );
    text( "y-axis: " + table.getColumnTitle(counterY) + " value", 0, 0 );
    popMatrix(); 
  }
  
  void drawLegend(){
    colorRanges.sort();
    ranges.sort();
    
    // create legend for barchart & linechart
    strokeWeight(1);
    textFont(fb, 12);
    fill(0);
    text("Legend:", u0+w, 75);
    
    textFont(f, 11);
    text(String.format("%.2f",ranges.get(ranges.size() - 1)), u0+w, 95);
    stroke(0);
    fill(100, colorRanges.get(0), 255);
    rect(u0+w-35, 80, 15, 15);
   
    fill(0);
    text(String.format("%.2f",ranges.get(2*(ranges.size()-1)/3)), u0+w, 115);
    stroke(0);
    fill(100, colorRanges.get((colorRanges.size()-1)/4), 255);
    rect(u0+w-35, 100, 15, 15);
   
    fill(0);
    text(String.format("%.2f",ranges.get((ranges.size()-1)/2)), u0+w, 135);
    stroke(0);
    fill(100, colorRanges.get((colorRanges.size()-1)/2), 255);
    rect(u0+w-35, 120, 15, 15);

    fill(0);
    text(String.format("%.2f",ranges.get((ranges.size()-1)/4)), u0+w, 155);
    stroke(0);
    fill(100, colorRanges.get(2*(colorRanges.size()-1)/3), 255);
    rect(u0+w-35, 140, 15, 15);
   
    fill(0);
    text(String.format("%.2f",ranges.get(0)), u0+w, 175);
    stroke(0);
    fill(100, colorRanges.get(colorRanges.size() - 1), 255);
    rect(u0+w-35, 160, 15, 15);
   
    noFill();
    stroke(0);
    strokeWeight(1);
  }
  
  void drawAxis(){
    strokeWeight(1);
    noFill();
    stroke(0);
    line( u0-1, v0, u0-1, h+v0); // y-axis line
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
      //else
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
  }
  
  void chooseAxis(){     
    noFill();
    // axis choice 1
    if( counterY == 0 ){
      fill( 165, 165, 165 );
      rect(u0+w-35, 235, 15, 15); 
    }
    else{
      noFill();
      rect(u0+w-35, 235, 15, 15); 
    }
    if( counterY == 1 ){
      fill( 165, 165, 165 );
      rect(u0+w-35, 255, 15, 15);  
    }
    else{
      noFill();
      rect(u0+w-35, 255, 15, 15);  
    }
    
    if( counterY == 2 ){
      fill( 165, 165, 165 );
      rect(u0+w-35, 275, 15, 15); 
    }
    else{
      noFill();
      rect(u0+w-35, 275, 15, 15); 
    }
    
    if( counterY == 3 ){
      fill( 165, 165, 165 );
      rect(u0+w-35, 295, 15, 15);
    }
    else{
      noFill();
      rect(u0+w-35, 295, 15, 15);
    } 
    
    if( mouseX >= u0+w-35 && mouseX <= u0+w-15 ){
      if( mouseY >= 235 && mouseY <= 250 ){
        strokeWeight(2);
        if( mousePressed ){
          counterY = 0; 
          yList.clear();
        }
        noFill();
        rect(u0+w-35, 235, 15, 15); 
        strokeWeight(1);
      }
      else if( mouseY >= 255 && mouseY <= 270 ){
        strokeWeight(2);
        if( mousePressed ){
          counterY = 1;  
          yList.clear();
        }
        noFill();
        rect(u0+w-35, 255, 15, 15); 
        strokeWeight(1);
      }
      else if( mouseY >= 275 && mouseY <= 290 ){
        strokeWeight(2);
        if( mousePressed ){
          counterY = 2;  
          yList.clear();
        }
        noFill();
        rect(u0+w-35, 275, 15, 15); 
        strokeWeight(1);
      }
      else if( mouseY >= 295 && mouseY <= 310 ){
        strokeWeight(2);
        if( mousePressed ){
          counterY = 3;  
          yList.clear();
        }
        rect(u0+w-35, 295, 15, 15);
        strokeWeight(1);
      }
    }
    
    fill(0);
    textFont(fb, 12);
    text("Switch axis:", u0+w+5, 230);
    
    textFont(f, 11);
    textAlign(LEFT, BOTTOM);
    text(table.getColumnTitle(0), u0+w-15, 250);
    text(table.getColumnTitle(1), u0+w-15, 270);
    text(table.getColumnTitle(2), u0+w-15, 290);
    text(table.getColumnTitle(3), u0+w-15, 315);
    textAlign(CENTER, BOTTOM);
  }
  
  void chooseBins(){
    fill(0);
    textFont(fb, 12);
    text("Choose bins:", u0+w+5, 345);
    textFont(f, 11);
    
    textAlign(LEFT, BOTTOM);
    text("Hover over a bar or point in barchart/linechart to highlight details", u0, v0);
    text("Hover over histogram for more info, or change # of bins in legend", 785, v0);
    text("Hover over the corrgram to view axis labels", 785, 450);
    textAlign(CENTER, BOTTOM);
    
    noFill();
    rect(u0+w-35, 350, 15, 15);
    rect(u0+w-35, 370, 15, 15 );
    
    if( mouseX >= u0+w-35 && mouseX <= u0+w-15 ){
      // check if plus bins
      if( mouseY >= 350 && mouseY <= 365 ){
        strokeWeight(2);
        if( mousePressed ){
          if( bins < 20 ){
            bins++;  
          }
          else{
            textFont(f, 12);
            fill(255, 0, 0);
            text("max is 20!", u0+w+5, 400);  
            fill(0);
          }
        }
      }
      noFill();
      rect(u0+w-35, 350, 15, 15);
      strokeWeight(1);
      if( mouseY >= 370 && mouseY <= 385 ){
        strokeWeight(2);
        if( mousePressed ){
          if( bins > 2 ){
            bins--;
          }
          else{
            textFont(f, 12);
            fill(255, 0, 0);
            text("min is 2!", u0+w+5, 400);  
            fill(0);
          }
        }
      }
      noFill();
      rect(u0+w-35, 370, 15, 15 );
      strokeWeight(1);
    }

    
    textFont(fb, 16);
    text("+", u0+w-27, 368);
    textFont(fb, 24);
    text("-", u0+w-28, 388);
    
    textFont(f, 14);
    text("k = " + bins, 690, 375);
    
  }  
  
  void mousePressed(){}
}