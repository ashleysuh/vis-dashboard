
class Scatterplot extends frame {
   
  float minX, maxX;
  float minY, maxY;
  int idx0, idx1;
  int border = 10;
  boolean drawLabels = true;
  float spacer = 10;
  FloatList colorRanges = new FloatList();
  FloatList ranges = new FloatList();
  boolean correlation = false;
  boolean spearman = false;
  
   Scatterplot( Table data, int idx0, int idx1 ){
     
     this.idx0 = idx0;
     this.idx1 = idx1;
     
     minX = min(data.getFloatColumn(idx0));
     maxX = max(data.getFloatColumn(idx0));
     
     minY = min(data.getFloatColumn(idx1));
     maxY = max(data.getFloatColumn(idx1));
   }
   
   void draw(){
     
     if( correlation ){
       stroke(0);
       noFill();
       strokeWeight(1);
       textFont(f, 16);
       
       FloatList xf = table.getFloatList(idx0);
       FloatList yf = table.getFloatList(idx1);
       
       float meanXF = 0;
       float meanYF = 0;
       float stdXF = 0;
       float stdYF = 0;
       float cov = 0;
        
       // find mean for idx0 and idx1 columns 
       for( Float f: xf ){
         meanXF += f;
       }
       
       for( Float f: yf ){
         meanYF += f;  
       }
       
       meanXF = meanXF / xf.size();
       meanYF = meanYF / yf.size();
       
       // find std deviation for both columns
       for( Float f: xf ){
         stdXF += sq(f- meanXF);  
       }
       
       for( float f: yf ){
         stdYF += sq(f - meanYF );  
       }
       
       stdXF = sqrt( stdXF / xf.size() );
       stdYF = sqrt( stdYF / yf.size() );
       
       // use mean and std dev to find covariance
       for( int i = 0; i < table.getRowCount(); i++ ){
         float currentX = xf.get(i);
         float currentY = yf.get(i);
         cov += (currentX - meanXF) * (currentY - meanYF);
       }
       
       // use covariance to find pearson correlation
       cov /= (table.getRowCount() - 1);
       float pearson = cov / (stdXF * stdYF);
       
       if( mouseX > u0 && mouseX < u0 + w && mouseY > v0 && mouseY < v0+h ){
           textFont(f, 14);
           fill(0);
           textAlign(LEFT, BOTTOM);
           text( table.getColumnTitle(idx0) + " & " + table.getColumnTitle(idx1), u0+5, v0+h-2);
           textAlign(CENTER,BOTTOM);
           strokeWeight(2);
           noFill();
         }
       else
           strokeWeight(1);
       float red = 0;
       float blue = 0;
       if( pearson < 0 ){
         red = map( pearson, -1, 0, 0, 255 );
       }
       else{
         blue = map( pearson, 0, 1, 0, 255 );
       }
       // color as blue positive and red negative colors
       fill(red, 0, blue, 100); 
       rect( u0+border,v0+border, w-2*border, h-2*border);      
       
       fill(0);
       textAlign(CENTER, BOTTOM);
       textFont(f, 18);
       text(String.format("%.3f", pearson), u0+(w/2), v0+(h/2)+10);
     }
     
     else if( spearman ){
       stroke(0);
       noFill();
       strokeWeight(1);
       
       // using 2nd formula from wikipedia page
       Table data_sorted = table;
       
       // sort through table for idx0 and idx1 columns
       FloatList xf_sorted = data_sorted.getFloatList(idx0);
       FloatList yf_sorted = data_sorted.getFloatList(idx1);
       xf_sorted.sort();
       yf_sorted.sort();

       HashMap<Float, FloatList> xMap = new HashMap<Float, FloatList>();
       HashMap<Float, FloatList> yMap = new HashMap<Float, FloatList>();
       
       // uses a hashmap to map many ranks to a single (row) value so no duplicate ranks
       for( int i = 0; i < xf_sorted.size(); i++ ){
         if( xMap.containsKey( xf_sorted.get(i) )){
           FloatList temp = new FloatList();
           temp = xMap.get( xf_sorted.get(i) );
           temp.append( (float)(i+1));
           xMap.put(xf_sorted.get(i), temp);
         }
         else{
           FloatList temp = new FloatList();
           temp.append((float)(i+1));
           xMap.put(xf_sorted.get(i), temp);
         }
       }
       
       for( int i = 0; i < yf_sorted.size(); i++ ){
         if( yMap.containsKey( yf_sorted.get(i) )){
           FloatList temp = new FloatList();
           temp = yMap.get( yf_sorted.get(i) );
           temp.append( (float)(i+1));
           yMap.put(yf_sorted.get(i), temp);
         }
         else{
           FloatList temp = new FloatList();
           temp.append((float)(i+1));
           yMap.put(yf_sorted.get(i), temp);
         }
       }
       
       HashMap<Float, Float> xRank = new HashMap<Float, Float>();
       for( Float f: xMap.keySet() ){
         FloatList temp = new FloatList();
         temp = xMap.get( f );
         
         if( temp.size() == 1 ){
           float value = temp.get(0);
           xRank.put(f, value);
         }
         else{
           float value = 0;
           for( Float fx : temp ){
             value += fx;
           }
           value /= temp.size();
           xRank.put(f, value);
         }
       }
       
       HashMap<Float, Float> yRank = new HashMap<Float, Float>();
       for( Float f: yMap.keySet() ){
         FloatList temp = new FloatList();
         temp = yMap.get( f );
         
         if( temp.size() == 1 ){
           float value = temp.get(0);
           yRank.put(f, value);
         }
         else{
           float value = 0;
           for( Float fx : temp ){
             value += fx;
           }
           value /= temp.size();
           yRank.put(f, value);
         }
       }
       
       FloatList xf = table.getFloatList(idx0);
       FloatList yf = table.getFloatList(idx1);
       float d_squared = 0;
       
       for( int i = 0; i < xf.size(); i++ ){
         float currX = xf.get(i);
         float rankX = xRank.get(currX);
         
         float currY = yf.get(i);
         float rankY = yRank.get(currY);
         
         d_squared += sq(rankX - rankY);
       }
       
       float spearman = 1 - ( (6 * d_squared) / ( xf.size() * ( sq(xf.size()) - 1 ) ));
       
       if( mouseX > u0 && mouseX < u0 + w && mouseY > v0 && mouseY < v0+h ){
           textFont(f, 14);
           fill(0);
           textAlign(RIGHT, BOTTOM);
           text( table.getColumnTitle(idx0) + " & " + table.getColumnTitle(idx1), u0+w-5, v0+h-2);
           textAlign(CENTER,BOTTOM);
           strokeWeight(2);
           noFill();
         }
       else
           strokeWeight(1);
       
       float red = 0;
       float blue = 0;
       if( spearman < 0 ){
         red = map( spearman, -1, 0, 0, 255 );
       }
       else{
         blue = map( spearman, 0, 1, 0, 255 );
       }

       fill(red, 0, blue, 100);
       rect( u0+border,v0+border, w-2*border, h-2*border);          
       
       fill(0);
       textAlign(CENTER, BOTTOM);
       textFont(f, 18);
       text(String.format("%.3f", spearman), u0+(w/2), v0+(h/2)+10);
     }
     
     else{
       if( plot ){
         for( int i = 0; i < 11; i++ ){
           textFont(f,8);
           stroke(153);
           strokeWeight(0.5);
           
           // x-axis (horizontal line)
           float xMap = map(i, 0, 10, u0, u0+w);
           line(xMap, v0, xMap, v0+h);
           
           // y-axis (vertical line)
           float yMap = map(i, 0, 10, v0+h, v0);
           line(u0, yMap, u0+w, yMap);
          
           // values to map x-y range tick marks
           float xValue = map(i, 0, 10, minX, maxX);
           float yValue = map(i, 0, 10, maxY, minY);
           fill(0);
           // text is a little tricky to get aligned
           text(String.format("%.2f",yValue), u0-12, v0+7+(i*((h)/10)));
           text(String.format("%.2f",xValue), u0-4+(i*((w-5)/10)), v0+h+15);
         }
       }
       
       for( int i = 0; i < table.getRowCount(); i++ ){
          TableRow r = table.getRow(i);
          
          float x = map( r.getFloat(idx0), minX, maxX, u0+spacer, u0+w-spacer );
          float y = map( r.getFloat(idx1), minY, maxY, v0+h-spacer, v0+spacer );
          float colorRange = map(r.getFloat(idx0) + r.getFloat(idx1), (minX + minY), (maxX + maxY), 255, 0);
          colorRanges.append(colorRange);
          ranges.append(r.getFloat(idx0) + r.getFloat(idx1));
          
          if( plot ){ // full zoomed version
            if( hoveredValue == i ){
              strokeWeight(0.5);
              stroke(0);
              fill(100, colorRange, 255);
              ellipse(x, y, 15, 15);
            }
            else if( mouseX >= x-7.5 && mouseX <= x+7.5 && mouseY >= y-7.5 && mouseY <= y+7.5 ){
              strokeWeight(0.5);
              stroke(0);
              fill(100, colorRange, 255);
              ellipse(x, y, 15, 15);
              hoveredValue = i;
            }
            else{
              strokeWeight(0.5);
              stroke(0);
              fill(100, colorRange, 255);
              ellipse(x, y, 10, 10);
            }
          }
          else{ // mini plots for scatter matrix
            if( hoveredValue == i ){
              strokeWeight(1.5);
              stroke(0);
              fill(100, colorRange, 255);
              ellipse( x, y, 7, 7 );
            }
            else{
              strokeWeight(0.2);
              stroke(0);
              fill(100, colorRange, 255);
              ellipse( x, y, 4, 4 );
            }
          }
          if( hoveredValue == i ){
            strokeWeight(3);
            stroke(100, colorRange, 255);
          }
       }
       
       if( plot ){
         colorRanges.clear();
         ranges.clear();
         for( int i = 0; i < table.getRowCount(); i++ ){
            TableRow r = table.getRow(i);
            float colorRange = map(r.getFloat(idx0) + r.getFloat(idx1), (minX + minY), (maxX + maxY), 255, 0);
            colorRanges.append(colorRange);
            ranges.append(r.getFloat(idx0) + r.getFloat(idx1));
         }
         colorRanges.sort();
         ranges.sort();
         
         // create legend for scatterplot
         strokeWeight(1);
         textFont(f, 11);
         fill(0);
         text(String.format("%.2f",ranges.get(ranges.size() - 1)), 318, 573);
         stroke(100, colorRanges.get(0), 255);
         fill(100, colorRanges.get(0), 255);
         rect(280, 555, 15, 20);
         
         fill(0);
         text(String.format("%.2f",ranges.get(2*(ranges.size()-1)/3)), 318, 593);
         stroke(100, colorRanges.get((colorRanges.size()-1)/4), 255);
         fill(100, colorRanges.get((colorRanges.size()-1)/4), 255);
         rect(280, 575, 15, 20);
         
         fill(0);
         text(String.format("%.2f",ranges.get((ranges.size()-1)/2)), 318, 613);
         stroke(100, colorRanges.get((colorRanges.size()-1)/2), 255);
         fill(100, colorRanges.get((colorRanges.size()-1)/2), 255);
         rect(280, 595, 15, 20);
    
         fill(0);
         text(String.format("%.2f",ranges.get((ranges.size()-1)/4)), 318, 633);
         stroke(100, colorRanges.get(2*(colorRanges.size()-1)/3), 255);
         fill(100, colorRanges.get(2*(colorRanges.size()-1)/3), 255);
         rect(280, 615, 15, 20);
         
         fill(0);
         text(String.format("%.2f",ranges.get(0)), 318, 653);
         stroke(100, colorRanges.get(colorRanges.size() - 1), 255);
         fill(100, colorRanges.get(colorRanges.size() - 1), 255);
         rect(280, 635, 15, 20);
         
         noFill();
         stroke(0);
         strokeWeight(1);
         // box around colors
         rect(280, 555, 15, 100);
         // box around legend
         
         textFont(fb, 10);
         fill(0);
         text("(x+y) range", 308, 550);
      }
       
       stroke(0);
       noFill();
       strokeWeight(0.5);
       if( !plot ){
         strokeWeight(1);
         if( mouseInside() ){
           textFont(f, 16);
           fill(0);
           textAlign(LEFT, BOTTOM);
           text( table.getColumnTitle(idx0) + " & " + table.getColumnTitle(idx1), u0+5, v0+h-2);
           textAlign(CENTER,BOTTOM);
           strokeWeight(2);
           noFill();
         }
         else
           strokeWeight(1);
         rect( u0+border,v0+border, w-2*border, h-2*border);       
       }
     }
   }
  
  void mousePressed(){}  
}