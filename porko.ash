int [int, int] game;
float [int, int] value;


float value_of(int y, int x);


void main(int turns) {
    boolean quest = false;
    string result, line;
    int previous, max, suma=0;
    float maxv, sumv=0;
    if (turns == 0) turns = my_adventures();
    for a from 1 upto turns {
        if (have_effect($effect[transpondent])==0) abort("Out of Transpondent.");
        if (item_amount($item[lunar isotope])==0) abort("You are too poor to play this game. You need at least one lunar isotope.");
        result = visit_url("spaaace.php?action=playporko&pwd");
        previous = 0;
        for i from 0 upto 15 {
            for j from 0 upto 8 {
                if (!(i%2 == 1 && j == 8)) {
                    int where = index_of(result, "title=\"peg style ", previous);
                    game[i, j] = to_int(substring(result, where+17, where+18));
                    previous = where+19;
                }
                value[i, j] = -1;
            }
        }
        /*
        for y from 0 upto 15 {
            if (y%2==0) {
                line = "";
                for x from 0 upto 8 {
                    line = line + " " + game[y][x];
                }  
            }
            else {
                line = " ";
                for x from 0 upto 7 {
                    line = line + " " + game[y][x];
                }  
            }
            logprint(line);
        }
        */
       
        if (!quest){
            previous = 0;
            for i from 0 upto 8 {
                int where = index_of(result, "blank\">x", previous);
                value[16, i] = to_int(substring(result, where+8, where+9));
                previous = where+10;
            }
        }
        else {
            for i from 0 upto 8 {
                if (i!=4) value[16, i] = 0;
                else value[16, i] = 100;
            }
        }
        max=0; maxv=0;
        for i from 0 upto 8 {
            if (value_of(0, i)>maxv) {
                maxv = value_of(0, i);
                max = i;
            }
        }
        /*
        for y from 0 upto 16 {
            if (y%2==0) {
                line = "";
                for x from 0 upto 8 {
                    line = line + " " + value[y][x];
                }  
            }
            else {
                line = " ";
                for x from 0 upto 7 {
                    line = line + " " + value[y][x];
                }  
            }
            logprint(line);
        }
        */
        print("Adventure "+a+" out of "+turns+" (expected: "+ sumv+ ", actual: "+suma+"): ", "blue");
        print("Payout expected: "+maxv+", with choice "+(max+1));
        if (maxv == 3.0) print("MAX PAYOUT!", "blue");
        if (!quest) {
            for b from 1 upto 3 {
                sumv=sumv+maxv;
                result = visit_url("choice.php?whichchoice=537&pwd&option="+(max+1));
                previous = index_of(result, "This nets you a payout of ")+26;
                print("Attempt "+b+" of 3: You win "+substring(result, previous, previous+1)+" isotopes.");
                suma=suma+to_int(substring(result, previous, previous+1));
            }
        }
        else {
            result = visit_url("choice.php?whichchoice=540&pwd&option="+(max+1));
            visit_url("spaaace.php?place=grimace");
        }

    }
}

float value_of(int y, int x) {
    if (value[y, x] != -1) return value[y, x];
    float foo;
    
    if (y%2==1) {
        if (game[y,x]==1) foo = value_of(y+1, x+1);
        if (game[y,x]==2) foo = value_of(y+1, x);
        if (game[y,x]==3) foo = ((value_of(y+1, x)+value_of(y+1, x+1))/2);
    }
    
    else {
        if (x==0) foo = value_of(y+1, x);
        else if (x==8) foo = value_of(y+1, x-1);
        else {
            if (game[y,x]==1) foo = value_of(y+1, x);
            if (game[y,x]==2) foo = value_of(y+1, x-1);
            if (game[y,x]==3) foo = ((value_of(y+1, x)+value_of(y+1, x-1))/2);
        }
    }
    value[y,x] = foo;
    return foo;
}   