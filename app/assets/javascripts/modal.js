$(document).ready(function() {
    // Open welcome modal if there are changes made to id 'version'
    var currentRelease = document.getElementById("version").innerHTML;
    var currCookie = localStorage.getItem('modalShown');
    var test = 'text';
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
        $('.clipboard-guideline').removeClass('show-clipboard');
    });

    // Open emoji modal
    $('.fa-smile-o').click(function () {
        $('.emoji-modal').addClass('show-modal');
        return false
    });

    var smiley = document.getElementsByClassName('emoji-container');
    var clipboard = new Clipboard(smiley);

    clipboard.on('success', function(e) {
        $('.clipboard-emoji').html("Copied: '" + e.text +"'");
    });

    // Close emoji modal
    $('.close-emoji').click(function () {
        $('.emoji-modal').removeClass('show-modal');
        $('.clipboard-emoji').removeClass('show-clipboard');
    });

    $('.emoji-container').click(function () {
        $('.clipboard-emoji').removeClass('show-clipboard');
        setTimeout(function () {
            $('.clipboard-emoji').addClass('show-clipboard');
        }, 0)
    });

    var guideline = document.getElementsByClassName('guideline-list');
    new Clipboard(guideline);

    $('.guideline-list').click(function () {
        $('.clipboard-guideline').removeClass('show-clipboard');
        setTimeout(function () {
            $('.clipboard-guideline').addClass('show-clipboard');
        }, 0)
    });
});