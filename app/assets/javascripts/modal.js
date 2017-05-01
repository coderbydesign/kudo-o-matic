$(document).ready(function() {
    // Open welcome modal if there are changes made to id 'version'
    var currentRelease = document.getElementById("version").innerHTML;
    var currCookie = localStorage.getItem('modalShown');
    setTimeout(function () {
        if(!currCookie || currCookie != currentRelease) {
            $(".welcome-modal").fadeIn(250).css("display", "flex");
            localStorage.setItem('modalShown', currentRelease);
        }
    }, 500);

    // Close welcome modal
    $('.close-welcome').on('click', function () {
        $('.welcome-modal').fadeOut(250).css("display", "none");
    });

    // Open guideline modal
    $('.guidelines').on('click', function () {
        $('.guideline-modal').fadeIn(250).css("display", "flex");
    });

    // Close guideline modal
    $('.close-guidelines').on('click', function () {
        $('.guideline-modal').fadeOut(250).css("display", "none");
    });
});