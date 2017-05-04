$(document).ready(function() {
    // Open welcome modal if there are changes made to id 'version'
    var currentRelease = document.getElementById("version").innerHTML;
    var currCookie = localStorage.getItem('modalShown');
    setTimeout(function () {
        if(!currCookie || currCookie != currentRelease) {
            $(".welcome-modal").addClass('show-modal');
            localStorage.setItem('modalShown', currentRelease);
        }
    }, 500);

    // Close welcome modal
    $('.close-welcome').click(function () {
        $('.welcome-modal').removeClass('show-modal');
    });

    // Open guideline modal
    $('.btn-guideline-info').click(function () {
        $('.guideline-modal').addClass('show-modal');
        return false
    });

    // Close guideline modal
    $('.close-guidelines').click(function () {
        $('.guideline-modal').removeClass('show-modal');
    });
});