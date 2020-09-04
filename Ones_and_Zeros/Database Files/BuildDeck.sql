select * from AccountHasDeck;
select * from Account;
select * from DeckMadeOfCard;
select * from Card;
select * from Deck;

SELECT card_id FROM DeckMadeOfCard WHERE 
            deck_id = 2;
            SELECT counter FROM DeckMadeOfCard WHERE 
            deck_id = 2;
            
            SELECT * FROM Card WHERE 
            Card.card_id  = 1;
            SELECT * FROM Card;
            SELECT deck_id from Deck where Name = "starterDeck";

insert into DeckMadeOfCard values (5, 1, 5);
insert into DeckMadeOfCard values (5, 2, 5);
insert into DeckMadeOfCard values (5, 3, 5);
insert into DeckMadeOfCard values (5, 4, 5);
insert into DeckMadeOfCard values (5, 5, 5);
insert into DeckMadeOfCard values (5, 6, 5);

insert into DeckMadeOfCard values (1, 1, 10);

insert into AccountHasDeck values (2, 4);
insert into AccountHasDeck values (1, 5);

insert into Deck values (NULL, 'Game Winning Deck');
insert into Deck values (NULL, 'Double Decker');
-- shereen
-- ryand

-- acount 1 has deck 1

-- deck 1 has card 1 1 TIME
-- deck 2 has card 1 10 TIMES
-- card 1 
-- deck 1 and deck 2
