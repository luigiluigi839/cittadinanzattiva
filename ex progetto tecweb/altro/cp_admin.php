<?php
    require_once('php/functions.php');
    $content="";
    $mod=array('{list}' => '','{admin}' => '');
    if(isLogin()) {
        if(isset($_GET['deleteId'])) {
            rimuoviPrenotazione($_GET['deleteId']);
        }
        $content="contents/cp_admin.html";
        $mod['{admin}']=$_SESSION['adminName'];
        $res=getPrenotazioni();
        while($row=mysqli_fetch_row($res)) {
            $mod['{list}'] = $mod['{list}']. '<tr>
            <td headers="c1">'.$row[1].'</td>
            <td headers="c2">'.$row[2].'</td>
            <td headers="c3">'.getNomeStanza($row[6]).'</td>
            <td headers="c4">'.$row[5].'</td>
            <td headers="c5">'.$row[3].'</td>
            <td headers="c6">'.$row[4].'</td>
            <td headers="c7"><a href="?deleteId='.$row[0].'">Elimina</a></td>
            
            </tr>';  
        }
        
    }
    else {
        $content="contents/login_form.html";
        if(isset($_POST['accedi'])) {
            if(isAdmin($_POST['email'],$_POST['password'])) {
                $_SESSION['adminOnline']=1;
                $_SESSION['adminName']=getAdminName($_POST['email'],$_POST['password']);
                header("location: cp_admin.php");
            }
        }
    }
    $result=PrepareContent($mod,$content);
    BuildPage("Pannello di Controllo",$result,1);
?>