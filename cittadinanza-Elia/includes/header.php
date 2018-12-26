<?php
	function head($page){
		if($page != 'home'){
			echo '<h1>
				<a href="../index.php">
					<span id="green">Citta</span>
					<span id="white">dinz</span>
					<span id="red">Attiva</span>
				</a>
			</h1>';
			echo "\r\n";
		}
		else {
			echo '<h1>
				<span id="green">Citta</span>
				<span id="white">dinz</span>
				<span id="red">Attiva</span>
			</h1>';
			echo "\r\n";
		}
	}
?>