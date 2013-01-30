// A sample "farming" script

void pool(int stance) {
    string result, clannie;
    int clan1, clan2;
    result = visit_url("clan_viplounge.php?preaction=poolgame&stance="+stance);
    if(contains_text(result, "You skillfully defeat")) {
        clan1=index_of(result, "defeat")+7;
        clan2=index_of(result, " and take");
        clannie = substring(result, clan1, clan2);
        print("You beat "+clannie+" at pool!");
        }
    else if(contains_text(result, "unable to defeat")) {
        clan1=index_of(result, "defeat")+7;
        clan2=index_of(result, "Ah well")-3;
        clannie = substring(result, clan1, clan2);
        print(clannie+" beat you at pool!");
        }
    else if(contains_text(result, "against yourself")) print("You played a game of pool with yourself!");
    else if(contains_text(result, "play again tomorrow") || contains_text(result, "hands in your pockets")) print("You've played enough pool for one day.", "red");
    else print("wtf, something is rotten","red");
}

void grandfather(int times) {
    int now = my_adventures();
    int target = now-times;
    while (my_adventures()>target&&my_adventures()!=0) {
        print("");
        print("Request "+(now-my_adventures()+1)+" of "+times+" in progress...");
        string encounter = visit_url("basement.php?action=1");
        
        //CHANGE THIS PART, customize the url with whatever your macro's id is
        if (my_name()=="man mobile") {
            string result=visit_url("fight.php?action=macro&macrotext=&whichmacro=50521&macro=Execute+Macro");
        }
        else if (my_name()=="eniteris") {
            string result=visit_url("fight.php?action=macro&macrotext=&whichmacro=49229&macro=Execute+Macro");
        }

        if (my_hp()==0) cli_execute("restore hp");
        cli_execute("mood execute");
    }
}



void dostasis() {
    while (my_adventures()!=0) {
        int now = my_turncount();

        string txt = get_property("relayCounters");
        matcher puller = create_matcher("(\\d+):Fortune Cookie:fortune.gif", txt);
        if (puller.find()) {
            grandfather((to_int(puller.group(1))-now));
            
            //adventures in an inaccessible location to get mafia to fetch a semirare            
            if(!adventure(1, $location[battlefield no uniform])) print("");
        }
        else {
            print("Can't find a semirare counter.", "red");
            grandfather(my_adventures());
        }
        
    }
    //cli_execute("display put * wint-o-fresh, * senior mint, * cold hots");
}

void dofarm() {
    visit_url("account.php?actions[]=priv_7&priv_7=0&pwd&action=Update");
    cli_execute("send to Buffy || 750 jingle 750 aria 750 empathy");
    cli_execute("equip pool cue");
    pool(1);
    pool(1);
    pool(1);
    cli_execute("equip reinforced beaded headband");
    if(have_effect($effect[down the rabbit hole])==0) use(1, $item["drink me" potion]);
    visit_url("rabbithole.php?action=teaparty");
    visit_url("choice.php?pwd&whichchoice=441&option=1&choiceform1=Try+to+get+a+seat");
    cli_execute("outfit Stocking");
    cli_execute("familiar stocking");
    cli_execute("equip familiar helicopter");
    cli_execute("mood stocking");
    int candies = item_amount($item[senior mints]) + item_amount($item[mr. mediocrebar]) + item_amount($item[daffy taffy]) + item_amount($item[cold hots candy]) + item_amount($item[wint-o-fresh mint]);
    dostasis();
    int gain = (item_amount($item[senior mints]) + item_amount($item[mr. mediocrebar]) + item_amount($item[daffy taffy]) + item_amount($item[cold hots candy]) + item_amount($item[wint-o-fresh mint]))-candies;
    print("You gained "+gain+" candies.");
    //cli_execute("sell * mr. mediocrebar, * daffy taffy");

}