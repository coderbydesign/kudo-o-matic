$(document).ready(function () {
    // Open welcome modal if there are changes made to id 'version'
    var currentRelease = document.getElementById("version").innerHTML;
    var currCookie = localStorage.getItem('modalShown');
    setTimeout(function () {
        if(!currCookie || currCookie != currentRelease) {
            $(".welcome-modal").addClass('show-modal');
            $('.welcome-modal-background').addClass('visible-as-modal');
            localStorage.setItem('modalShown', currentRelease);
        }
    }, 500);

    // Close welcome modal
    $('.close-welcome').click(function () {
        $('.welcome-modal').removeClass('show-modal');
        $('.welcome-modal-background').removeClass('visible-as-modal');
    });

    $(document).keyup(function(e) {
        if (e.keyCode === 27) { // esc
            $('.welcome-modal').removeClass('show-modal');
            $('.welcome-modal-background').removeClass('visible-as-modal');
        }
    });

    $('.welcome-modal-background').click(function () {
        $('.welcome-modal').removeClass('show-modal');
        $('.welcome-modal-background').removeClass('visible-as-modal');
    })
});