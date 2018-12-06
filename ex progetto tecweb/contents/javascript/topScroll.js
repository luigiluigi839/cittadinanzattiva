window.onscroll = scrollFunction;

function scrollFunction() {
    if (document.body.scrollTop > 1000 || document.documentElement.scrollTop > 1000) {
        document.getElementById("topScrollButton").style.display = "block";
    } else {
        document.getElementById("topScrollButton").style.display = "none";
    }
}

window.onload = function() {
  var topScrollButton = document.getElementById("topScrollButton");
  topScrollButton.addEventListener("click", function() {
  	window.scrollTo(0, 0);
  });
  handleMobileMenu();
}
