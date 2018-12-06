
function login(){
	var user, pass;
	var con=true;
	var patternUSER=/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
	user = document.getElementById("email").value;
	pass = document.getElementById("password").value;
	if(pass===""){
        document.getElementById("errore_pass").innerHTML= "Inserire la password! ";
        con = false;
    }
	if(user==""){
        document.getElementById("errore_email").innerHTML= "Campo Email non può essere vuoto! ";
        return false;
    }
    else
    {
        if(!patternUSER.test(user)){
            document.getElementById("errore_email").innerHTML= "Email "+ user + " non valida! ";
            con = false;
            return;
        }
    }   
    return con;
}

function pulisci(){
    document.getElementById("errore_checkIn").innerHTML = "";
    document.getElementById("errore_checkOut").innerHTML = "";
    document.getElementById("errore_nomeCognome").innerHTML = "";
    document.getElementById("errore_email").innerHTML = "";
}

function checkNomeCognome(){
    var nomeCognome = document.getElementById("input-name");
    var patternNC = /^([a-zA-Z\xE0\xE8\xE9\xF9\xF2\xEC\x27]\s?)+$/;
    //var patternNC=/^[a-zA-Z\s]*$/;
    if(nomeCognome ==""){
        document.getElementById("errore_nomeCognome").innerHTML= "Campo dati nome e cognome vuoti! ";
        return false;
    }
    else   
        if(!patternNC.test(nomeCognome.value)){
            document.getElementById("errore_nomeCognome").innerHTML= "Errore nell'inserimento del nome ";
            return false;
        }
    return true;
}

function checkEmail(){
    var con=true;
    var email = document.getElementById("guest-email");
    var text = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    var patternEmail = /[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$/;
    if(email.value ===""){
        document.getElementById("errore_email").innerHTML= "Campo email non deve essere vuoto! ";
        return false;
        }
    else
    {
        if(!text.test(email.value)){
            document.getElementById("errore_email").innerHTML= "Email "+ email.value + " non valida! ";
            con = false;
            
        }
    }
    return true;
}

function checkData(){
    var con=true;
    var checkIn = document.getElementById("check-in");
    var checkOut = document.getElementById("check-out");
    var patternCheck = /^[0-9]{2}\-[0-9]{2}\-[0-9]{4}$/;
    if(!patternCheck.test(checkIn.value)){
        document.getElementById("errore_checkIn").innerHTML= "Data di arrivo non valida! ";
        con=false;
    }
    if(!patternCheck.test(checkOut.value)){
        document.getElementById("errore_checkOut").innerHTML= "Data di partenza non valida! ";
        con=false;
    }
    return con;
}
function checkPrenota(){
    pulisci();
    if(checkData() && checkNomeCognome() && checkEmail())
        return true;
    else
        return false;
}

/*
function emptyForm(){
    var checkIn = document.getElementById("check-in");
    var checkOut = document.getElementById("check-out");
    var nomeCognome = document.getElementById("input-name");
    var email = document.getElementById("guest-email");
    var con=true;
    if(checkIn.value===""){
        document.getElementById("errore_checkIn").innerHTML = "Data di arrivo è richiesta! ";
        con=false;
    }
    if(checkOut.value===""){
        document.getElementById("errore_checkOut").innerHTML = "Data di partenza è richiesta!";
        con=false;
    }
    if(nomeCognome.value===""){
        document.getElementById("errore_nomeCognome").innerHTML = "Il nome e cognome è richiesto! ";
        con=false;
    }
    if(email.value===""){
        document.getElementById("errore_email").innerHTML = "L'email è richiesta! ";
        con=false;
    }
    return con;
}

function checkNomeCognome(par, nome){
	var tag=document.getElementById(par);
	var ctrl=/^[a-zA-Z ]+$/;
    var string =""
	if (tag.value == null || tag.value == "" || /^[ ]+$/.test(tag.value) || tag.value.length < 3 || tag.value.length > 20)
        string += "<li>Il campo "+nome+" deve contenere tra 3 e 20 caratteri</li>";

    if(!string && !ctrl.test(tag.value))
        string += "<li>Il campo "+nome+" non possono contenere caratteri speciali</li>";
    return string;
}

function checkEmail(par){
	var tag= document.getElementById(par);
    var string="";
    var ctrl = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
    if (tag.value == "" || /^[ ]+$/.test(tag.value))
        string +=  "<li>Il campo email non può essere vuoto</li>";
    
    if(!string && !ctrl.test(tag.value))
        string+= "<li>il campo email non deve conterene caratteri speciali oltre la chiocciola e il punto</li>";

    return string;
}

function checkData(par){
    var tag = document.getElementById(par);    
    var string = "";
    var ctrl = /^([0-9]{2})\/([0-9]{2})\/([0-9]{4})$/;

    if(!ctrl.test(tag.value))
        string += "<li>Formato data non valido, il formato deve essere di tipo gg/mm/aaaa</li>";

    return string;
}

function checkPrenota(){
    if(checkData("check-in") & checkData("check-out") & checkNomeCognome("input-name") & checkEmail("guest-email")){
        document.getElementById("errori").innerHTML = "<ul>" + errori + "</ul>";
        return true;
    }
    else
        return false;
	/*var errori = checkData("check-in") + checkData("check-out") + checkNomeCognome("input-name") + checkEmail("guest-email");
	if(errori){
		document.getElementById("errori").innerHTML = "<ul>" + errori + "</ul>";
		return false;
	}
	return true;
}
*/
function valida(){
    pulisci();
    var con=true;
    var nomeCognome = document.getElementById("input-name").value;
    var email = document.getElementById("guest-mail");
    var checkIn = document.getElementById("check-in");
    var checkOut = document.getElementById("check-out");
    var patternCheck = /^[0-9]{2}\-[0-9]{2}\-[0-9]{4}$/;
    var patternNC = /^([a-zA-Z\xE0\xE8\xE9\xF9\xF2\xEC\x27]\s?)+$/;
    var patternEmail = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
    //var patternEmail = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    if(!patternCheck.test(checkIn.value)){
        document.getElementById("errore_checkIn").innerHTML= "Data di arrivo non valida! ";
        con = false;
    }
    if(!patternCheck.test(checkOut.value)){
        document.getElementById("errore_checkOut").innerHTML= "Data di partenza non valida! ";
        con = false;
    }
    if(nomeCognome===""){
        document.getElementById("errore_nomeCognome").innerHTML= "Campo nome e Cognome non può essere vuoto! ";
        con = false;
    }
    else
    {
        if(!patternNC.test(nomeCognome.value)){
            document.getElementById("errore_nomeCognome").innerHTML= "In quale universo uno si chiama cosi! ";
            con = false;
            }
        }
    if(email==="" ){
        document.getElementById("errore_email").innerHTML= "Campo Email non può essere vuoto! ";
        return false;
    }else
        if(!patternEmail.test(email.value)){
            document.getElementById("errore_email").innerHTML= "Email "+ email.value + " non valida! ";
            con = false;
            return false;
        }    
    else
        return con;
}


