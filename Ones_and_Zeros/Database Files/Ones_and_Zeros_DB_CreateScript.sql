
use Ones_and_Zeros;

drop table if exists AccountOwnsCard;
drop table if exists DeckMadeOfCard;
drop table if exists PackContainsCard;
drop table if exists AccountHasDeck;
drop table if exists Account;
drop table if exists Card;
drop table if exists Deck;
drop table if exists Pack;

create table Account (
	account_id INT NOT NULL AUTO_INCREMENT,
	username varchar(100) NOT NULL,
	passwd TEXT NOT NULL,
	FName TEXT NOT NULL,
	LName TEXT NOT NULL,
	NumCoins INT NOT NULL,
	EMail varchar(100) NOT NULL,
	Salt varchar(100) NOT NULL,

	CONSTRAINT Account_AccountID_PK PRIMARY KEY (account_id),
	CONSTRAINT Account_username_Unique UNIQUE (username),
	CONSTRAINT Account_EMail_Unique UNIQUE (EMail)
);

create table Card (
	card_id INT NOT NULL AUTO_INCREMENT,
	Name TEXT,
	CardImageSCN_URL TEXT,
	CardImageStatic_URL TEXT,
	CharacterImageURL TEXT,
	Attack INT,
	Health INT,
	Burden INT,

	CONSTRAINT Card_CardID_PK PRIMARY KEY (card_id)
);

create table Deck (
	deck_id INT NOT NULL AUTO_INCREMENT,
	Name TEXT,

	CONSTRAINT Deck_DeckID_PK PRIMARY KEY (deck_id)
);

create table Pack (
	pack_id INT NOT NULL AUTO_INCREMENT,
	Name TEXT,
	Cost INT,

	CONSTRAINT Pack_PackID_PK PRIMARY KEY (pack_id)
);

create table  AccountHasDeck (
	account_id INT NOT NULL,
	deck_id INT NOT NULL,

	CONSTRAINT Create_AccountIDDeckID_PK PRIMARY KEY (account_id, deck_id),
	CONSTRAINT Create_AccountID_FK FOREIGN KEY (account_id) REFERENCES Account(account_id) ON DELETE CASCADE,
	CONSTRAINT Create_DeckID_FK FOREIGN KEY (deck_id) REFERENCES Deck(deck_id) ON DELETE CASCADE,
	CONSTRAINT Create_DeckID_Unique	UNIQUE (deck_id)
);


create table AccountOwnsCard (
	account_id INT NOT NULL,
	card_id INT NOT NULL,
	counter INT NOT NULL,

	CONSTRAINT Own_AccountIDCardID_PK PRIMARY KEY (account_id, card_id),
	CONSTRAINT Own_AccountID_FK FOREIGN KEY (account_id) REFERENCES Account(account_id) ON DELETE CASCADE,
	CONSTRAINT Own_CardID_FK FOREIGN KEY (card_id) REFERENCES Card(card_id) ON DELETE CASCADE
);

create table DeckMadeOfCard (
	deck_id INT NOT NULL,
	card_id INT NOT NULL,
	counter INT NOT NULL,

	CONSTRAINT MadeOf_DeckIDCardID_PK PRIMARY KEY (deck_id, card_id),
	CONSTRAINT MadeOf_DeckID_FK FOREIGN KEY (deck_id) REFERENCES Deck(deck_id) ON DELETE CASCADE,
	CONSTRAINT MadeOf_CardID_FK FOREIGN KEY (card_id) REFERENCES Card(card_id) ON DELETE CASCADE
);

create table PackContainsCard (
	card_id INT NOT NULL,
	pack_id INT NOT NULL,

	CONSTRAINT Contains_CardIDPackID_PK PRIMARY KEY (card_id, pack_id),
	CONSTRAINT Contains_CardID_FK FOREIGN KEY (card_id) REFERENCES Card(card_id) ON DELETE CASCADE,
	CONSTRAINT Contains_PackID_FK FOREIGN KEY (pack_id) REFERENCES Pack(pack_id) ON DELETE CASCADE
);
