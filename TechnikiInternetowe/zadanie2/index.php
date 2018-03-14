<!DOCTYPE html>
<html>
<head>
<title>
CRAWLER
</title>
<style>
html,body{
text-align: center;
}
#main{
background-color: gray;
}
input[type=submit]{
background-color: red;
}
</style>
</head>
<body>
<div id="main">
<a href="www.google.com">Go there</a>
<h1> Tutaj wpisz adres strony: </h1>
<form action = "" method = "GET">
	<input type = "text" name = "url_address"><br>
	<input type = "submit" value = "Crawl!"><br>
</form>
</div>
<?php
$url = '';
if(isset($_GET['url_address'])){
	$url = $_GET["url_address"];

	$url = $_GET["url_address"];
	echo 'Przeszukujesz strone: ', $url, "<br>";

	if (filter_var($url, FILTER_VALIDATE_URL)) {
    		echo("$url JEST adresem poprawnym");
	} else {
    		echo("$url NIE JEST poprawnym adresem");
	}
}
/*
 

//SPRAWDZIC TO ROZWIAZANIA Z DOKUMENTACJI
// http://php.net/manual/en/class.domdocument.php
    // Create a new DOM Document to hold our webpage structure
    $xml = new DOMDocument();

    // Load the url's contents into the DOM
    $xml->loadHTMLFile($url);

    // Empty array to hold all links to return
    $links = array();

    //Loop through each <a> tag in the dom and add it to the link array
    foreach($xml->getElementsByTagName('a') as $link) {
        $links[] = array('url' => $link->getAttribute('href'), 'text' => $link->nodeValue);
    }

    //Return the links
    return $links; 
*/
?>
</body>
</html> 