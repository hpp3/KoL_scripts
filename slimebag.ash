void chamois() {

    if(have_effect($effect[Coated in Slime]) > 0) {
        print("Using chamois...", "blue");
        visit_url("clan_slimetube.php?action=chamois&pwd");
    }
    if(have_effect($effect[Coated in Slime]) > 0) abort("Failed to use a chamois. You'll need to find some other way to clean yourself up.");
}

void runchoice( string url, string text )
{   
    string page_text = text;
    string result;
    while( contains_text( page_text , "choice.php" ) )
    {
        // Get choice adventure number
        int begin_choice_adv_num = (index_of(page_text, "whichchoice value=") + 18);
        int end_choice_adv_num = index_of(page_text,"><input",begin_choice_adv_num);
        string choice_adv_num = substring(page_text,begin_choice_adv_num, end_choice_adv_num );
#        print("Choice adventure #" + choice_adv_num, "blue");
        string choice_adv_prop = "choiceAdventure" + choice_adv_num;
        string choice_num = get_property( choice_adv_prop );
        if( choice_num == "" ) abort( "Unsupported Choice Adventure #" + choice_adv_num +"!" );
        result = visit_url("choice.php?pwd&whichchoice=" + choice_adv_num + "&option=" + choice_num);
        page_text = visit_url(url);
    }
}

int slimedamage(int turns) {
    int raw;
    float percent;
    if(turns==0 && have_effect($effect[coated in slime]) == 0) {
        print("Estimating pwnage based on ML...");
        turns = max(1.0, 11-(ceil(numeric_modifier("monster level")+100)/100.0));
        print(turns+" turns of coated in slime predicted...");
    }
    
    if (have_effect($effect[coated in slime]) > 10) return 0;
    if(have_effect($effect[coated in slime]) == 0 ) raw = ceil(my_maxhp()*((11-turns)**2.727)/100);
    else raw = ceil(my_maxhp()*((11-have_effect($effect[coated in slime]))**2.727)/100);
    percent = elemental_resistance($element[slime]);
    print("Expected damage: "+ceil(raw - (raw * percent/100))+", current hp: "+my_hp()+", raw damage: "+raw, "green");
# debug info    +", resistance: "+resistance+", percent: "+percent
    return ceil(raw - (raw * percent/100));
}


void main(int times, boolean semi) {
    if(times == 0) times = my_adventures();
    int turns=0;
    int current=0;
    int chamoix=0, scrolls=0;
    int damage;
    int ml=0;
    boolean just_cleaned;
    cli_execute("outfit slime");
    cli_execute("familiar purse rat");
    while(current<times) {
        if(item_amount($item[tattered scrap of paper])==0) abort("Out of paper. Load paper and press OK.");
        if(my_hp() == 0) abort("Something is wrong. You are dead.");

        print("Visiting slime tube ("+(current+1)+" out of "+times+" times), "+chamoix+" chamoix used, "+scrolls+" scrolls of drastic healing used, "+ml+" ML defeated, "+floor(ml/400)+" slimes defeated", "blue");
        if(have_effect($effect[coated in slime])<4 && have_effect($effect[coated in slime])!=0) {
            chamois();
            chamoix=chamoix+1;
        }
        if(have_effect($effect[coated in slime])==0) {
            cli_execute("outfit slimebagging");
            cli_execute("familiar gibberer");
            #cli_execute("mcd 0");
            cli_execute("ccs wat");
        }
        else if((have_effect($effect[coated in slime])>0&&just_cleaned)||have_effect($effect[coated in slime])>11) {
            cli_execute("outfit slime");
            cli_execute("familiar purse rat");
            #cli_execute("mcd 10");
            cli_execute("ccs shieldbutt");
        }
        damage=slimedamage(turns);
        if(my_hp()<damage+50) {
            if(my_maxhp()<damage+50 && turns >2) abort("A strange game. The only winning move is not to play. How about a nice game of chess? (There's no way you can survive)");
            use(1, $item[scroll of drastic healing]);  
            scrolls=scrolls+1;
        }
        if(have_effect($effect[coated in slime])==0) just_cleaned=true;
        else just_cleaned=false;
        if(!semi&&have_effect($effect[coated in slime]) == 0) {
            string result = visit_url("adventure.php?snarfblat=203");
            if(contains_text(result, "Engulfed!")) runchoice("adventure.php?snarfblat=203", result);
            while(!contains_text(visit_url("fight.php?action=useitem&whichitem=1959"),"you beat feet out of there")) {
                if(my_hp()<50) abort("FUUUUUUUUuuu");
                if(item_amount($item[tattered scrap of paper])==0) abort("Out of paper. Load paper and press OK.");
                print("Repeating tatter...");
            }
        }
        else {
        ml=ml+monster_level_adjustment()+400;
        //if(have_effect($effect[superhuman sarcasm])==0||have_effect($effect[tomato power])==0||have_effect($effect[phorceful])==0) abort("Out of stat buffs.");
        adventure(1, $location[slime tube]);
        if(just_cleaned) turns = have_effect($effect[coated in slime]) + 1;
        current=current+1;
        }
    }
    print("Turns finished.");
}