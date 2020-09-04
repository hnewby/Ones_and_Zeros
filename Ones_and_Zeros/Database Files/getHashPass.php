<?php
// Author: 			Hannah Newby
// File: 			getHashPass.php
// Date:			Nov 28, 2017
// Class:			CS 445	
// Project: 		flight Finder
// Description:     Gets Password of admin

   
	function getHashPass($dbh, $username)
	{
		$sth = $dbh -> prepare("SELECT passwd From Account WHERE 
            Account.username = :username");

		 $sth->bindValue(":username", $username);
	
        //	 run the query
		$sth -> execute();
		
		//$data = implode("|",$sth -> fetch());
		//$data = implode($sth -> fetch());
		$data = $sth -> fetch();

		return $data;
	}
?>
