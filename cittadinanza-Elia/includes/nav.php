<?php
	function nav($page){
		if ($page == 'home'){
			$page = 'Home';
			echo '<p id="breadcrumb">Ti trovi in: Home</p>';
			echo "\r\n\t\t\t\t";
			echo '<ul>
					<li id="activeLink" tabindex="3">Home</li>
					<li>
						<a href="../service.php" tabindex="4">Servizi</a>
					</li>
					<li>
						<a href="../news.php" tabindex="5">News</a>
					</li>
					<li>
						<a href="../contatti.php" tabindex="6">Contatti</a>
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
						<a href="../index.php" tabindex="4">Home</a>
					</li>
					<li id="activelink" tabindex="5">Servizi</li>
					<li>
						<a href="../news.php" tabindex="6">News</a>
					</li>
					<li>
						<a href="../contatti.php" tabindex="7">Contatti</a>
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
						<a href="../index.php" tabindex="4">Home</a>
					</li>
					<li>
						<a href="../service.php" tabindex="5">Servizi</a>
					</li>
					<li id="activeLink" tabindex="6">News</li>
					<li>
						<a href="../contatti.php" tabindex="7">Contatti</a>
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
						<a href="../index.php" tabindex="4">Home</a>
					</li>
					<li id="activeLink" tabindex="5">Registrati</li>
					<li>
						<a href="../service.php" tabindex="6">Servizi</a>
					</li>
					<li>
						<a href="../news.php" tabindex="7">News</a>
					</li>
					<li>
						<a href="../contatti.php" tabindex="8">Contatti</a>
					</li>
				</ul>';
			echo "\r\n";
		}
		if ($page == 'welcome'){
			$page = 'Benvenuto';
			echo '<p id="breadcrumb">Ti trovi in: Home &gt; ' . "$page" . '</p>';
			echo "\r\n\t\t\t\t";
			echo '<ul>
					<li>
						<a href="../index.php" tabindex="4">Home</a>
					</li>
					<li>
						<a href="../service.php" tabindex="6">Servizi</a>
					</li>
					<li>
						<a href="../news.php" tabindex="7">News</a>
					</li>
					<li>
						<a href="../contatti.php" tabindex="8">Contatti</a>
					</li>
				</ul>';
			echo "\r\n";
		}
	}
?>
