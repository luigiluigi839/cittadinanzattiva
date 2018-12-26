			<?php
				$name = $surname = $data = $indirizzo = $civico = "";
				$paese = $provincia = $telefono = $cellulare = $email = "";

				if ($_SERVER["REQUEST_METHOD"] == "POST") {		
					$name = test_input($_POST["nome"]);
					$surname = test_input($_POST["cognome"]);
					$data = test_input($_POST["bdata"]);
					$indirizzo = test_input($_POST["via"]);
					$civico = test_input($_POST["civico"]);
					$paese = test_input($_POST["paese"]);
					$provincia = test_input($_POST["provincia"]);
					$telefono =  test_input($_POST["numero_telefono"]);
					$cellulare = test_input($_POST["numero_cellulare"]);
					$email = test_input($_POST["email"]);
				}

				function test_input($data) {
					$data = trim($data);
					$data = stripslashes($data);
					$data = htmlspecialchars($data);
					return $data;
				}
					echo "$name\n";
					echo "<br />";
					echo "$surname\n";
					echo "<br />";
					echo "$data\n";
					echo "<br />";
					echo "$indirizzo\n";
					echo "<br />";
					echo "$civico\n";
					echo "<br />";
					echo "$paese\n";
					echo "<br />";
					echo "$provincia\n";
					echo "<br />";
					echo "$telefono\n";
					echo "<br />";
					echo "$cellulare\n";
					echo "<br />";
					echo "$email\n";
				?>