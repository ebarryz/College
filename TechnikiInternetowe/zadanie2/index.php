﻿<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>CRAWLER</title>
	<link rel="stylesheet" type="text/css" href="style_crawler.css">
</head>
<body>
	<div id = "internal">
		<h1> Crawler </h1>
		<form action = "" method = "GET">
			<input type = "text" name = "page_url">
			<p></p>
			<input type = "submit" value = "Crawl!" id = "crawl">
			<p></p>
		</form>
	</div>
	<div id = "anwser">
		<?php
			$url = "";
			if(isset($_GET['page_url'])){
				$url = $_GET["page_url"];
				// po podaniu adresu tworzony jest paragraf, w ktorym zostanie wyswietlona informacja o poprawnosci wprowadzonego adresu
				echo "<p style = 'padding: 3px 0 3px 0;'>";
					echo "<span style='font-weight: bold;'>PODANY ADRES: </span>", $url, "<br>";
					if (filter_var($url, FILTER_VALIDATE_URL)) {
						echo("<span style='color:green; font-weight: bold;'> JEST POPRAWNY :) </span>");
					} else {
						echo("<span style='color: red; font-weight: bold;'> NIE JEST POPRAWNY :(  </span>");
					}
				echo "</p>";
			}

			error_reporting(E_ERROR | E_PARSE);
			get_links($url);
			
			// http://php.net/manual/en/class.domdocument.php
			function get_links($url) { 
				// stworzenie pustego DOM Documentu, który przechowuje strukture strony
				$xml = new DOMDocument(); 
				// zaladowanie do DOMDocument'u podanej witryny
				$xml -> loadHTMLFile($url);
				$counter = 0; // do zliczania wystąpień tagu a 
				// z zaladowanej struktury strony pobieramy zniaczniki 'a'
				foreach($xml->getElementsByTagName('a') as $link) {
					// zliczanie ilosci wsytapien tagu a
					$counter = $counter + 1;
					// pobieranie adres strony
					echo '<input type = "submit" value = " ', $link->getAttribute('href'),'">';// '<br>';
					// w co trzeba kliknac aby zostac przekierowanym na strone
					//echo '<span style="font-weight: bold;"> nodeValue </span>= > ', $link->nodeValue, '<br>'; 
				}
			echo '<br><br>Znaleziono: ', $counter, ' znacznikow';
			}
		?>
	</div>
</body>
</html> 