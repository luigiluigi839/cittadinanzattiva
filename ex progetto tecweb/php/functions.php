<?php
session_start();

require_once('php/connection.class.php');



function PrepareMenu($title) {
    $menuEntry=array(
        'Home'=>'index.php',
        'Come raggiungerci'=>'come_raggiungerci.php',
        'Le nostre camere'=>'camere.php',
        'Attorno a noi'=>'dintorni.php',
        'I nostri servizi'=>'servizi.php',
        'Contattaci'=>'contatti.php',
        'Menù'=>'#naventry-home'
    );
    $tabindex = 2;
    $menu='<ul class="inner">';
    foreach($menuEntry as $index=>$link) {
        if($index==$title) {
            $menu=$menu.'<li class="menu"><a class="active">'.$index.'</a></li>';
        }
        else {
          if($link=='#naventry-home')
              $menu=$menu.'<li class="menu" id="naventry-menu">' . $index .
                '<img src="img/menu-bars-icon.png" alt="Menu bars icon" class="menu-bars-icon" /></li>';
          else{
            $menu=$menu.'<li class="menu"><a class="not-active" tabindex="'.$tabindex.'" href="'.$link.'">'.$index.'</a></li>';
            $tabindex++;
          }
        }
       
    }
    $menu=$menu.'</ul>';
    return $menu;
}

function PrepareHeader($title) {
    $btn='';
    if($title!='Home' && $title!='Prenota')
        $btn='<div class="booking-button-container"><a id="booking-button"  tabindex="7" href="prenota.php">PRENOTA ORA</a></div>';
    $header=file_get_contents("contents/header.html");
    $header=str_replace('{booking-btn}',$btn,$header);
    return $header;
}

function PrepareContent($modification,$content) {
    $page = file_get_contents($content);
    foreach($modification as $tag=>$value){
         $page = str_replace($tag,$value,$page);
    }
    return $page;
}

function PrepareMobileMenu($title) {
  $menuEntry=array(
      'Home'=>'index.php',
      'Come raggiungerci'=>'come_raggiungerci.php',
      'Le nostre camere'=>'camere.php',
      'Attorno a noi'=>'dintorni.php',
      'I nostri servizi'=>'servizi.php',
      'Contattaci'=>'contatti.php',
      'Prenota'=>'prenota.php',
  );
  $menu='<ul class="inner">';
  foreach($menuEntry as $index=>$link) {
      if($index==$title) {
          if($link=='index.php')
            $menu=$menu.'<li id="naventry-home"><a class="active" href="'.$link.'">'.$index.'</a></li>';
          else{
          $menu=$menu.'<li><a class="active">'.$index.'</a></li>';
        }
      }
      else {
        if($link=='index.php')
          $menu=$menu.'<li id="naventry-home"><a class="not-active" href="'.$link.'">'.$index.'</a></li>';
        else{
          $menu=$menu.'<li><a class="not-active" href="'.$link.'">'.$index.'</a></li>';
        }
      }
  }
  $mobilemenu=$menu.'</ul>';
  return $mobilemenu;
}

function PrepareFooter($title) {
    $btn='';
    if($title=='Pannello di Controllo') {
        if(isLogin())
            $btn='<a href="logout.php" tabindex="18">LOGOUT</a>';
    }
    else {
        $btn='<a href="cp_admin.php" tabindex="18">PANNELLO DI CONTROLLO</a>';
    }
    $footer=file_get_contents("contents/footer.html");
    $footer=str_replace('{cpanel-btn}',$btn,$footer);
    return $footer;
}

function PrepareBreadcrumb($title) {
    $breadcrumb = '<p> Home';
    if($title != "Home")
        $breadcrumb = $breadcrumb.' / '.$title.'</p>';
    else
        $breadcrumb = $breadcrumb.'</p>';

    return $breadcrumb;

}

function BuildPage($title,$content,$array=0) {
    $page=file_get_contents("contents/structure.html");
    $page=str_replace('{title}',$title,$page);
    $header=PrepareHeader($title);
    $page=str_replace('{header}',$header,$page);
    $navbar=PrepareMenu($title);
    $page=str_replace('{navbar}',$navbar,$page);
    $breadcrumb=PrepareBreadcrumb($title);
    $page=str_replace('{breadcrumb}',$breadcrumb,$page);
    if($array==1)
        $body=$content;
    else
        $body=file_get_contents($content);
    $page=str_replace('{content}',$body,$page);
    $mobilenavbar=PrepareMobileMenu($title);
    $page=str_replace('{mobilenavbar}',$mobilenavbar,$page);
    $footer=PrepareFooter($title);
    $page=str_replace('{footer}',$footer,$page);
    echo $page;

}
function isLogin() {
    if(isset($_SESSION['adminOnline'])) {
        if($_SESSION['adminOnline']==1)
            return true;
        else
            return false;
    }
    else
        return false;
}

function isAdmin($email,$pwd) {
        $res=connection::QueryRead("SELECT nome FROM amministratori WHERE email='$email' AND password=MD5('$pwd')");
        $row=mysqli_fetch_row($res);
        if($row)
            return true;
        else
            return false;
}

function getAdminName($email,$pwd) {
        $result = connection::QueryRead("SELECT nome FROM amministratori WHERE email='$email' AND password=MD5('$pwd')");
        $row = mysqli_fetch_row($result);
        return $row[0];
}

function getPrenotazioni() {
    $result = connection::QueryRead("SELECT * FROM prenotazioni");
    return $result;

}
function getNomeStanza($TipoStanza) {
    $result = connection::QueryRead("SELECT nomeStanza FROM appartamenti WHERE idStanza='$TipoStanza'");
    $row = mysqli_fetch_row($result);
    return $row[0];
}

function getStanze() {
    $result = connection::QueryRead("SELECT * FROM appartamenti ");
    
    return $result;
}

function getDisp($TipoStanza) {
    $result = connection::QueryRead("SELECT da, a FROM prezzi_disponibilita WHERE idStanza='$TipoStanza'");
    $row = mysqli_fetch_row($result);
    return $row;
}

function getCostoStanza($TipoStanza) {
    $result = connection::QueryRead("SELECT costoGiornaliero FROM prezzi_disponibilita WHERE idStanza='$TipoStanza'");
    $row = mysqli_fetch_row($result);
    return $row[0];
}
function getCostoTotale($TipoStanza,$stringda,$stringa) {
    $da = new DateTime($stringda);
    $a = new DateTime($stringa);
    $giorni=$da->diff($a)->days;
    return $giorni*getCostoStanza($TipoStanza);
}

function formattaData($string) {
    $date = explode("-", $string);
    $result = $date[2] . "-" . $date[1] . "-". $date[0];
    return $result;
}
function getMaxStanze($idStanza) {
    $result = connection::QueryRead("SELECT maxStanze FROM prezzi_disponibilita WHERE idStanza='$idStanza'");
    $row = mysqli_fetch_row($result);
    return $row[0];
}
function getStanzeOccupate($data_inizio,$data_fine,$idStanza) {
    $result = connection::QueryRead("SELECT * FROM prenotazioni
    WHERE (('$data_inizio' BETWEEN data_arrivo AND data_partenza)
    OR (data_arrivo BETWEEN '$data_inizio' AND '$data_fine'))
    AND tipoStanza = '$idStanza'");
    $row = mysqli_num_rows($result);
    return $row;
}

function checkData($string) {
    $date = explode("-", $string);
    if(sizeof($date) >= 3) {
        return checkdate($date[1], $date[0], $date[2]);
    }
    else
        return false;
}

function checkDatas($stringda,$stringa){
    $da = new DateTime($stringda);
    $a = new DateTime($stringa);
    return $a>$da;
}
function rimuoviPrenotazione($idPrenotazione){
    $query="DELETE FROM prenotazioni WHERE id='$idPrenotazione'";
    return connection::QueryWrite($query);
}

function checkDateLibere($data_inizio,$data_fine,$appartamento) {
    //false il periodo è ok, true il periodo è occupato
    $query = "SELECT * FROM prenotazioni
    WHERE (('$data_inizio' BETWEEN data_arrivo AND data_partenza)
    OR (data_arrivo BETWEEN '$data_inizio' AND '$data_fine'))
    AND tipoStanza = '$appartamento'";
    $result = connection::QueryRead($query);
    return (mysqli_fetch_row($result));
}

function checkBoundDate($data_inizio,$data_fine,$appartamento) {
    //ritorna vero se la prenotazione è all'interno delle date prenotabili
    $query = "SELECT * FROM prezzi_disponibilita
    WHERE (('$data_inizio' BETWEEN da AND a)
    AND ('$data_fine' BETWEEN da AND a))
    AND idStanza = '$appartamento'";
    $result = connection::QueryRead($query);
    return (mysqli_fetch_row($result));
}
function insertPrenotazione($guestName,$guestMail,$da,$a,$tipoStanza) {
    $query = "INSERT INTO `prenotazioni` (`nomeUtente`, `email`, `data_arrivo`, `data_partenza`, `tipoStanza`) VALUES
    ('$guestName', '$guestMail', '$da', '$a', '$tipoStanza')";
    return connection::QueryWrite($query);
}

function checkIfCurrentDate($data) {
    $arrivo = new DateTime($data);
    $attuale = new DateTime(date("Y-m-d"));
    return $arrivo>=$attuale;
}

function buildStanzaSelector($tipoStanza) {
    $page= '<select name="TipoStanza" id="TipoStanza" tabindex="10">';
    $res= getStanze();
    while($rows = mysqli_fetch_row($res)){
        if($rows[0]==$tipoStanza)
            $page = $page.'<option value="'.$rows[0].'" selected> '.$rows[1].' </option>';
        else
            $page = $page.'<option value="'.$rows[0].'" > '.$rows[1].' </option>';
    }
    $page=$page.'</select>';

    /*'<option value="A"> Singola classica </option>
    <option value="B"> Doppia classica </option>
    <option lang="en" value="C"> Superior </option>
    <option lang="en" value="D"> Suite </option>
    </select>;'*/
    return $page;

}
?>
