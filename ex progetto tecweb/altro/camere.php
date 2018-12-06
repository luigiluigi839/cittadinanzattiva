<?php
    require_once('php/functions.php');
    $mod=array('{dispA}' => '','{dispB}' => '','{dispC}' => '','{dispC}' => '');
    $disp = getDisp("A");
    $mod['{dispA}'] = '<span class="costo">Dal: '.formattaData($disp[0]).' </span>
    <span class="costo">Al: '.formattaData($disp[1]). '</span>' ;
    $disp = getDisp("B");
    $mod['{dispB}'] = '<span class="costo">Dal: '.formattaData($disp[0]).' </span>
    <span class="costo">Al: '.formattaData($disp[1]). '</span>' ;
    $disp = getDisp("C");
    $mod['{dispC}'] = '<span class="costo">Dal: '.formattaData($disp[0]).' </span>
    <span class="costo">Al: '.formattaData($disp[1]). '</span>' ;
    $disp = getDisp("D");
    $mod['{dispD}'] = '<span class="costo">Dal: '.formattaData($disp[0]).' </span>
    <span class="costo">Al: '.formattaData($disp[1]). '</span>' ;


    $result=PrepareContent($mod,"contents/camere.html");
    BuildPage("Le nostre camere",$result,1);
    
?>