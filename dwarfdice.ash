string result, one, two, three, four;
int begin1, end1, begin2, end2, begin3, end3, begin4, end4, win1, win2, win, i =1;
record data
    {
    string first;
    string second;
    string third;
    string fourth;
    string winnings;
    };

data[int] dicedata;

cli_execute("outfit mining");

while(i < 31) {
    
    result = visit_url("dwarffactory.php?action=dodice");
    begin1= (index_of(result, "they come up ")+53);
    end1= (index_of(result, "they come up ")+54);
    one= substring(result, begin1, end1);
    begin2= (index_of(result, " followed by ")+53);
    end2= (index_of(result, " followed by ")+54);
    two= substring(result, begin2, end2);
    begin3= (index_of(result, " you roll a ")+52);
    end3= (index_of(result, " you roll a ")+53);
    three= substring(result, begin3, end3);
    begin4= (index_of(result, " and a ")+47);
    end4= (index_of(result, " and a ")+48);
    four= substring(result, begin4, end4);
    
    if(contains_text(result, "The dwarf chuckles heartily")) {
        win1= (index_of(result, "heartily and takes ")+19);
        win2= (index_of(result, " meat from your pile"));
        win= 0-to_int(substring(result, win1, win2));
    }
    else {
        win1= (index_of(result, "The dwarf pushes")+15);
        win2= (index_of(result, "meat towards you"));
        win=to_int(substring(result, win1, win2));
        win =win;
    }
    
    dicedata[i].first = one;
    dicedata[i].second = two;
    dicedata[i].third = three;
    dicedata[i].fourth = four;
    dicedata[i].winnings = win;
    
    i = i +1;
}


map_to_file( dicedata, "\\dice\\diceroll.txt");
print("Done!");