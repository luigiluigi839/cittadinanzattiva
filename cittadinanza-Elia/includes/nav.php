<?php
	function nav($page){
		if ($page == 'home'){
			$page = 'Home';
			echo '<p id="breadcrumb">Ti trovi in: Home</p>';
			echo "\r\n\t\t\t\t";
			echo '<ul>
					<li id="activeLink">Home</li>
					<li>
						<a href="../service.php">Servizi</a>
					</li>
					<li>
						<a href="../news.php">News</a>
					</li>
					<li>
						<a href="../contatti.php">Contatti</a>
					</li>
				</ul>';
			echo "\r\n";
		}
		if ($page == 'service'){
			$page = 'Servizi';
			echo '<p id="breadcrumb">Ti trovi in: Home &gt; ' . "$page" . '</p>';
			echo "\r\n\t\t\t\t";
			echo '<ul>
					<li>
						<a href="../index.php">Home</a>
					</li>
					<li id="activelink">Servizi</li>
					<li>
						<a href="../news.php">News</a>
					</li>
					<li>
						<a href="../contatti.php">Contatti</a>
					</li>
				</ul>';
			echo "\r\n";
		}
		if ($page == 'news'){
			$page = 'News';
			echo '<p id="breadcrumb">Ti trovi in: Home &gt; ' . "$page" . '</p>';
			echo "\r\n\t\t\t\t";
			echo '<ul>
					<li>
						<a href="../index.php">Home</a>
					</li>
					<li>
						<a href="../service.php">Servizi</a>
					</li>
					<li id="activeLink">News</li>
					<li>
						<a href="../contatti.php">Contatti</a>
					</li>
				</ul>';
			echo "\r\n";
		}
		if ($page == 'contatti'){
			$page = 'Contatti';
			echo '<p id="breadcrumb">Ti trovi in: Home &gt; ' . "$page" . '</p>';
			echo "\r\n\t\t\t\t";
			echo '<ul>
					<li>
						<a href="../index.php">Home</a>
					</li>
					<li>
						<a href="../service.php">Servizi</a>
					</li>
					<li>
						<a href="../news.php">News</a>
					<li id="activeLink">Contatti</li>
				</ul>';
			echo "\r\n";
		}
		if ($page == 'signup'){
			$page = 'Registrati';
			echo '<p id="breadcrumb">Ti trovi in: Home &gt; ' . "$page" . '</p>';
			echo "\r\n\t\t\t\t";
			echo '<ul>
					<li>
						<a href="../index.php">Home</a>
					</li>
					<li id="activeLink">Registrati</li>
					<li>
						<a href="../service.php">Servizi</a>
					</li>
					<li>
						<a href="../news.php">News</a>
					</li>
					<li>
						<a href="../contatti.php">Contatti</a>
					</li>
				</ul>';
			echo "\r\n";
		}
	}
?>