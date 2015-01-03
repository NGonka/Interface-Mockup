


PFont font;
PImage grid;

int numValues = 1;    // number of input values or sensors

int[] values   = new int[numValues];
int[]   min      = new int[numValues];
int[]   max      = new int[numValues];
color[] valColor = new color[3];
float[] oldY = new float[numValues];
int oldX =0; 
int[] maxValue = new int[numValues];
int[] minValue = new int[numValues];

float partH;          // partial screen height


int minimum = -6000;
int maximum = 6000;

int xPos = 0;
int yPos = 0;
String inString="";
boolean clear = false;
boolean startPvT=true;
boolean startPvP=true;




void setup(){
    
    size(700,300,JAVA2D);
    font = createFont("Arial",12);
    textFont(font);
    emptyPeakArray();
    partH = (height*1)/ numValues;
     
    values[0] = 0;
    min[0] = minimum;
    max[0] = maximum;  // 8-bit (0-255) example
    valColor[0] = color(255, 0, 0); // red
    valColor[1] = color(0, 255, 0); // green
    valColor[2] = color(0, 0, 255); // blue
    //println(width);
    //println(height);
    background(0,0,0,0);
    
    for (int i=0;i<numValues;i++)
  {
      oldY[0]=partH*(i+1)/2;
  }
}

void draw(){
    //background(0);
    

}

void drawPointVsTime(int Point,int timePoint){
    if(startPvT){
        drawPvTdivLines();
        startPvT=false;
    }

    
    
    inString = Point+","+timePoint;
    if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);
 
    // split the string on the delimiters and convert the resulting substrings into an float array:
    //int[] valuesTemp = int(splitTokens(inString, ", \t"));
    values = int(splitTokens(inString, ", \t"));    // delimiter can be comma space or tab
    //println("inString: ",inString);
    //println(values);
    // if the array has at least the # of elements as your # of sensors, you know
    // you got the whole data packet.  Map the numbers and put into the variables:
    if (values.length >= numValues) {
      for (int i=0; i<1 ; i++) {
        //values[i] = float(valuesTemp[i]);
        //print(i + ": " + values[i]);
        // print values:
        //println(values[numValues]);
        //Peak detection
        if(values[i]>maxValue[i])
        {
        maxValue[i]=values[i];
        }
        if(values[i]<minValue[i])
        {
        minValue[i]=values[i];
        }
        

        
        //little Textbox upper left corner
        textAlign(LEFT);
        fill(50);
        //noStroke();
        stroke(255,0,0);
        strokeWeight(1);
        rect(width-200, partH*i+1, 200, 24);
        fill(255);
        text(int(values[i]), width-200+10, partH*i+6+12);
        fill(128);
        text(minValue[i]+", "+maxValue[i], width-200+80, partH*i+6+12);
        

        /*
        if (Save)
        {
        newRow.setInt(column[i+1],values[i]);
        recording = true;
        }*/
        // map to the range of partial screen height:
        float mappedVal = map(values[i], min[i], max[i], 0, partH);

 
        // draw lines:
        stroke(valColor[0]);
        strokeWeight(1);
        if(!clear){
        xPos=int(oldX)+int(ceil(values[numValues]/1000));
        
        line(oldX, oldY[i], xPos, partH*(i+1) - mappedVal);

        oldY[i] = partH*(i+1) - mappedVal;
        }
        else{
            background(0,0,0,0);
            xPos=0;
            oldY[i]=partH*(i+1)/2;
            clear=false;
            emptyPeakArray();
            drawPvTdivLines();
                
        }
        

        
        //println("\t"+mappedVal);   // <- uncomment this to debug values
        
       
      }
      /*
       //println(str(values[values.length-1]));
      if(Save)
      {
        newRow.setInt(column[0],values[values.length-1]);
        recording=true;
      }
      */
     
      //println("Values: ",values);                   // <- uncomment this to debug values
 
      // if at the edge of the screen, go back to the beginning:
      if (xPos >= width) {
        //noLoop();
        
        xPos = 0;
        oldX=0;
        // two options for erasing screen, i like the translucent option to see "history"
        background(0,0,0,0);
        emptyPeakArray();
        drawPvTdivLines();
      }
      else {
        oldX = xPos;
        //xPos+=2;                    // increment the graph's horizontal position
    
      }
     
    
    }
    
  }
    
}



void drawPointVsPoint(int PointX, int PointY){    
    if(startPvP||clear){
        drawPvPdivLines();
        startPvP=false;
        clear=false;
    }
    inString = PointX+","+PointY;
    if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);
 
    // split the string on the delimiters and convert the resulting substrings into an float array:
    //int[] valuesTemp = int(splitTokens(inString, ", \t"));
    values = int(splitTokens(inString, ", \t"));    // delimiter can be comma space or tab
    //println("inString: ",inString);
    //println(values);
    // if the array has at least the # of elements as your # of sensors, you know
    // you got the whole data packet.  Map the numbers and put into the variables:
    
        //little Textbox upper left corner
        textAlign(LEFT);
        fill(50);

        stroke(0);
        strokeWeight(1);
        rect(width-200, 1, 200, 24);
        fill(255);
        text("Volt: " + PointX,width-200+ 10, 6+12);
        text ("mV, Current: ",width-200+70,6+12);
        text(PointY,width-200+140,6+12 );
        text ("mA",width-200+175,6+12);
        xPos=values[0];    
        yPos=height-values[1];


        if (xPos >= width) {
            xPos = width;
        }
        else if (xPos<=0){
            xPos=0;   
        }
        if (yPos >= height) {
            yPos = height;
        }
        else if (yPos<=0){
            yPos=0;    
        }
        
        // draw Points
        stroke(valColor[2]);
        strokeWeight(1);
        strokeWeight(5);
        point(xPos,yPos);
            


            

    }


}
    
void emptyPeakArray(){
  for (int i=0;i<numValues;i++)
  {
      minValue[i]=0;
      maxValue[i]=0;
  
  }
}

void clearPositions(){
    background(0,0,0,0);
    clear =true;

}


void drawMarkers(int length, char orientation, int midPointX,int midPointY){
    int[] grid = new int[length/100];
    for (int i=1; i<= length/50;i++){
        grid[i-1]=i*50;     
        
    }
    if (orientation=='y'){
        stroke (0);
        strokeWeight (1);
        textAlign(LEFT);
        float normalY;        
        for (int i=0; i<grid.length; i++) {
            normalY = partH-(grid[i]);
            line (midPointX, normalY, midPointX+10, normalY);
            fill (0);
            text (int(grid[i]), midPointX+10, normalY+6);
        }
    }
    else if( orientation=='x'){
        stroke (0);
        
        textAlign(CENTER);
        float normalX;        
        for (int i=0; i<grid.length; i++) {
            normalX = grid[i];
            strokeWeight (1);
            line (normalX,midPointY,normalX,midPointY-10);
            fill (0);
            strokeWeight (0.1);
            text (int(grid[i]),  normalX, midPointY-12);
        }
    }

}


void drawPvTdivLines(){
    // draw dividing lines:
    // vertical
    strokeWeight(1);
    stroke(0);
    line(0, 0, 0, height);
    // horizontal
    stroke(0);
    strokeWeight(1);
    line(0,height/2,width,height/2);
    
    drawMarkers(width, 'x',height,height/2 );
    drawMarkers(height,'y',0,height/2);
    
    
}

void drawPvPdivLines(){
    // draw dividing lines:
    // vertical

    strokeWeight(0.5);
    stroke(0);
    line(0, 0, 0, height);
    // horizontal
    stroke(0);
    line(0,height,width, height);
    drawMarkers(width, 'x',height,height );
    drawMarkers(height,'y',0,0);
    
}

