

import de.bezier.guido.*;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined
public final static int NUM_ROWS= 20;
public final static int NUM_COLUMNS = 20;
public final static int NUM_BOMBS = 20;
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLUMNS];
    for(int y = 0 ; y < NUM_ROWS;y++){
      for(int x = 0 ; x < NUM_COLUMNS; x++){
        buttons[y][x]= new MSButton(y,x);
        
      }
    }
    bombs = new ArrayList<MSButton>();
    for(int i = 0; i < NUM_BOMBS; i++)
    setBombs();
}
public void setBombs()
{
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLUMNS);
     if(!bombs.contains(buttons[row][col]))
        bombs.add(buttons[row][col]);
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    int hola =0;
    for(MSButton bomb : bombs){
     if(bomb.isMarked())
       hola++;
     if(hola==NUM_BOMBS)
       return true;
    }
    return false;
}
public void displayLosingMessage()
{
   int hello = 0;
   String lose = "LOSER";
   for(int e = 5 ; e < 13 ; e++){
     buttons[10][e].setLabel(lose.substring(hello,hello+1));
     hello++;
   }
}
public void displayWinningMessage()
{
    int hello = 0;
    String win = "WINNER";
    for(int e = 5 ; e < 13 ; e++){
     buttons[10][e].setLabel(win.substring(hello,hello+1));
     hello++;
   }
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLUMNS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT){
           marked = !marked;
            if(isWon())
                displayWinningMessage();
            if(marked == false)
                clicked = false;
        }
        else if(bombs.contains(this)) {
            for(MSButton bomb : bombs)
                bomb.clicked = true;
            displayLosingMessage();
        }
        else if(countBombs(r, c) > 0)
            setLabel("" + countBombs(r, c));
        else
            for(int i = -1; i <= 1; i++)
                for(int j = -1; j <= 1; j++)
                    if(isValid(r+i, c+j) && !buttons[r+i][c+j].isClicked())
                        buttons[r+i][c+j].mousePressed();
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
         else if( clicked && bombs.contains(this) ) 
           fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill(175,238,238);

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
      if(r >= NUM_ROWS || r < 0)
        return false;
      else if(c >= NUM_COLUMNS || c < 0)
        return false;
      return true;
    }
    public int countBombs(int row, int col)
    {
       int hola = 0;
        for(int i = -1; i <= 1; i++)
            for(int j = -1; j <= 1; j++)
                if((i == 0 && j == 0) == false)
                    if(isValid(row+i, col+j) && bombs.contains(buttons[row+i][col+j]))
                        hola++;
        return hola;
    }
}
