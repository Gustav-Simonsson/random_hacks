-module(mhp).
-compile(export_all).

t() ->
    NumGames = 10000,
    Games = [game() || _ <-lists:seq(1,NumGames)],
    
    FirstChoiceWinsPercentage =
        length(lists:filter(fun({car,_}) -> true; (_) -> false end,
                            Games)) / NumGames,
    
    SwitchWinsPercentage =
        length(lists:filter(fun({_,car}) -> true; (_) -> false end,
                            Games)) / NumGames,

    io:format("First choice wins ~p%, switch door wins: ~p% ~n",
              [FirstChoiceWinsPercentage, SwitchWinsPercentage]),
    ok.

game() ->
    %% grab some entropy into process dict
    {A,B,C} = now(),
    random:seed(A,B,C),

    %% Assumption A: one car, two goats.
    Possibilities = [car, goat, goat],

    PickOneOf = fun(List) -> Element = lists:nth(random:uniform(length(List)), List),
                             {Element, lists:delete(Element, List)}
                end,

    %% Assumption B: The car and goat's are randomly shuffled behind the doors    
    {Door1, Rest}  = PickOneOf(Possibilities),
    {Door2, Rest2} = PickOneOf(Rest),
    [Door3] = Rest2,
    Doors = [Door1, Door2, Door3],
    
    %% Assumption C: The player picks a random door
    PlayerFirstChoice = lists:nth(random:uniform(3), Doors),

    %% Assumption D: Game host always opens one of the doors with a goat.
    %% Assumption F: Game host always opens a door different from the one
    %% choosen by the player!
    Choices = lists:delete(car, lists:delete(PlayerFirstChoice, Doors)),
    GameHostChoice = lists:nth(random:uniform(length(Choices)), Choices),

    %% Scenario A: Player switches door
    [PlayerSwitchedChoice] =
        lists:delete(PlayerFirstChoice, lists:delete(GameHostChoice, Doors)),

    {PlayerFirstChoice, PlayerSwitchedChoice}.
