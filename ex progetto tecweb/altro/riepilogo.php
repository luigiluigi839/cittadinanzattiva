<?php
  require_once('php/functions.php');
  if(!isset($_SESSION['Preventivo'])) {
    header("location: index.php");
  }
  else {
    $content="";
    $mod=$_SESSION['ArrayMod'];
    if(isset($_SESSION['Effettuata'])) {
      $content="contents/conferma.html";
      unset($_SESSION['ArrayMod']);
      unset($_SESSION['Effettuata']);
      unset($_SESSION['Preventivo']);
    }
    else {
      if(isset($_SESSION['Errore'])) {
        $content="contents/errore.html";
        unset($_SESSION['ArrayMod']);
        unset($_SESSION['Errore']);
        unset($_SESSION['Preventivo']);
      }
      else {
          if(isset($_POST['cancella'])) {
            unset($_SESSION['ArrayMod']);
            unset($_SESSION['Preventivo']);
            header("location: prenota.php");

          }
          if(isset($_POST['conferma'])) {
            $pren=insertPrenotazione($mod['{guest-name}'],$mod['{guest-mail}'],formattaData($mod['{check-in}']),formattaData($mod['{check-out}']),$mod['idStanza']);
           if($pren) {
              $_SESSION['Effettuata']=1;
              header("location: riepilogo.php");        
            }
            else {
              $_SESSION['Errore']=1;
              header("location: riepilogo.php");
            }
          }
          else {
            
            $content="contents/riepilogo.html";
          }
        }
      }
  $result=PrepareContent($mod,$content);
  BuildPage("Riepilogo",$result,1);
  }
?>
