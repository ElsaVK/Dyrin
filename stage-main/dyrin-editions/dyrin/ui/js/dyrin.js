
//début zotero pop-up
//function openPopup(target, x, y, w, h) {
//    var win = window.open(target, 'popup', 'height=' + h + ', width=' + w + ', top=' + y + ', left=' + x + ', toolbar=no, menubar=no, location=no, resizable=yes, scrollbars=yes, status=no');
//    win.window.focus();
//    return false;
//}
//fin zotero pop-up

//début zotero pop-up
function openPopup(target, x, y, w, h) {
    var win = window.open(target, 'popup', 'height=' + h + ', width=' + w + ', top=' + y + ', left=' + x + ', toolbar=no, menubar=no, location=no, resizable=yes, scrollbars=yes, status=no');
    win.window.focus();
    return false;
}
//fin zotero pop-up

// rendre caché-décaché le tableau de la tradition et la Dissertation

 var coll = document.getElementsByClassName("collapsible");
 var i;
 for (i = 0; i < coll.length; i++) {
     coll[i].addEventListener("click", function() {
         this.classList.toggle("active");
         var content = this.nextElementSibling;
         if (content.style.display === "block") {
             content.style.display = "none";
        } else {
             content.style.display = "block";
        }
    });
 }
