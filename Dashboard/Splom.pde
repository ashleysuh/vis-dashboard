

class Splom extends frame {
  
  ArrayList<Scatterplot> plots = new ArrayList<Scatterplot>( );
  ArrayList<Scatterplot> corrPlots = new ArrayList<Scatterplot>();
  ArrayList<Scatterplot> spearPlots = new ArrayList<Scatterplot>();
  FloatList xList, yList;
  int colCount;
  float border = 5;
  int [] indices = new int[2];
    
  Splom( ArrayList<Integer> useColumns ){
    colCount = useColumns.size();
    for( int j = 0; j < colCount-1; j++ ){
      for( int i = j+1; i < colCount; i++ ){
        Scatterplot sp = new Scatterplot( table, useColumns.get(j), useColumns.get(i) );
        plots.add(sp);
      }
    }
    
    for( int j = 0; j < colCount-1; j++ ){
      for( int i = j+1; i < colCount; i++ ){
        Scatterplot sp = new Scatterplot( table, useColumns.get(j), useColumns.get(i) );
        sp.correlation = true;
        corrPlots.add(sp);
      }
    }
    
    for( int j = 0; j < colCount-1; j++ ){
      for( int i = j+1; i < colCount; i++ ){
        Scatterplot sp = new Scatterplot( table, useColumns.get(j), useColumns.get(i) );
        sp.spearman = true;
        spearPlots.add(sp);
      }
    }

    indices[0]=0;
    indices[1]=1;
  }
   
  void setPosition( int u0, int v0, int w, int h ){
    super.setPosition(u0,v0,w,h);

    int curPlot = 0;
    for( int j = 0; j < colCount-1; j++ ){
       for( int i = j+1; i < colCount; i++ ){
          Scatterplot sp = plots.get(curPlot++);
          int su0 = (int)map( j, 0, colCount-1, u0+border, u0+w-border );
          int sv0 = (int)map( i, 1, colCount, v0+border, v0+h-border );
          
          sp.setPosition( su0, sv0, (int)(w-2*border)/(colCount-1), (int)(h-2*border)/(colCount-1) );
          sp.drawLabels = false;
          sp.border = 3;
     }
    }   
    
    //super.setPosition(750, 1600/3 - 135, 450, (800 - 1600/3 - 135));
    curPlot = 0;
    for( int j = 0; j < colCount-1; j++ ){
       for( int i = j+1; i < colCount; i++ ){
          Scatterplot sp = corrPlots.get(curPlot++);
          u0 = 778;
          v0 = 535;
          w = 300;
          h = 265;
          int su0 = (int)map( j, 0, colCount-1, u0+border, u0+w-border );
          int sv0 = (int)map( i, 1, colCount, v0+border, v0+h-border );
          
          sp.setPosition( su0, sv0, (int)(w-2*border)/(colCount-1), (int)(h-2*border)/(colCount-1) );
          sp.border = 3;
     }
    }  
    
    //super.setPosition(750, 1600/3 - 135, 450, (800 - 1600/3 - 135));
    curPlot = 0;
    for( int j = 0; j < colCount-1; j++ ){
       for( int i = j+1; i < colCount; i++ ){
          Scatterplot sp = spearPlots.get(curPlot++);
          u0 = 872;
          v0 = 453;
          w = 300;
          h = 265;
          int su0 = (int)map( i, 1, colCount, u0+border, u0+w-border );
          int sv0 = (int)map( j, 0, colCount-1, v0+border, v0+h-border );
          sp.setPosition( su0, sv0, (int)(w-2*border)/(colCount-1), (int)(h-2*border)/(colCount-1) );
          sp.border = 3;
     }
    }  
  }
   
  void draw() {  
    textFont(f, 14);
    textAlign(CENTER, BOTTOM);
    fill(0);
    text("SPLOM Chart", w-125, v0+27);
    textFont(f, 12.5);
    textAlign(LEFT, BOTTOM);
    text("Click on a SPLOM to zoom view on right.", u0+125, v0+50);
    text("Hover over scatterplot point to view info.", u0+125, v0+65);
    //text("Select an axis from PCP to swap all axes.", u0+(2*w/3), v0+65);
    textAlign(CENTER, BOTTOM);
    // draw normal scatterplots
    for( Scatterplot s : plots ){
      plot = false;
      s.draw(); 
      plot = true;
    }
    
    textFont(f,18);
    fill(0);
    float x_label1 = 770;
    float x_label2 = 665;
    pushMatrix();
    translate( x_label1,x_label2 );
    rotate( -HALF_PI );        
    text( "Pearson Correlation Coefficient", 0, 0 );
    popMatrix();
    
    textFont(f, 18);
    x_label1 = 1175;
    x_label2 = 595;
    pushMatrix();
    translate( x_label1,x_label2 );
    rotate( HALF_PI );        
    text( "Spearman Correlation Coefficient", 0, 0 );
    popMatrix();
    // draw correlation matrices
    for( Scatterplot s: corrPlots ){
      s.draw();  
    }
    
    // draw spearman matrices
    for( Scatterplot s: spearPlots ){
      s.draw();
    }
    
    Scatterplot SP = new Scatterplot( table, indices[0] , indices[1] );
    SP.drawLabels = true;
    SP.setPosition(380, 440, 352, 345);
    SP.draw();
  }

  void mousePressed(){ 
    for( Scatterplot sp : plots ){
       if( sp.mouseInside() ){
           indices[0] = sp.idx0;
           indices[1] = sp.idx1;
       }    
    }
  }
}