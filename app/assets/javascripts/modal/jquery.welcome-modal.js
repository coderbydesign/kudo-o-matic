$(document).ready(function () {
    // Open welcome modal if there are changes made to id 'version'
    var currentRelease = document.getElementById("version").innerHTML;
    var currCookie = localStorage.getItem('modalShown');
    setTimeout(function () {
        if(!currCookie || currCookie != currentRelease) {
            $(".welcome-modal").addClass('show-modal');
            localStorage.setItem('modalShown', currentRelease);
        }
    }, 500);

    $('.what-new').click(function () {
        $(".welcome-modal").addClass('show-modal');
        return false;
    });

    $('.toggle-side-message').click(function () {
       $('.side-message').toggleClass('slide-out');
        $('.side-message').find('.toggle-side-message').toggleClass('fa-chevron-left fa-chevron-right')
    });

    // Close welcome modal
    $('.close-welcome').click(function () {
        $('.welcome-modal').removeClass('show-modal');
    });

    $(document).keyup(function(e) {
        if (e.keyCode === 27) { // esc
            $('.welcome-modal').removeClass('show-modal');
        }
    });
});