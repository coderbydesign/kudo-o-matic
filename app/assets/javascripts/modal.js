$(document).ready(function() {
    var currentRelease = document.getElementById("version").innerHTML;
    var currCookie = Cookies.get('modalShown');
    setTimeout(function () {
        if(!currCookie || currCookie != currentRelease) {
            $("#myModal").modal('show');
            Cookies.set('modalShown', currentRelease);
        } else {
            alert('You already saw the modal')
        }
    }, 1000);
});