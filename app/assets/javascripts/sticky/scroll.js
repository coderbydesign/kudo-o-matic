// create a scene
$(document).ready(function () {

    function debounce(func, wait, immediate) {
        var timeout;
        return function() {
            var context = this, args = arguments;
            var later = function() {
                timeout = null;
                if (!immediate) func.apply(context, args);
            };
            var callNow = immediate && !timeout;
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
            if (callNow) func.apply(context, args);
        };
    }
    function throttle(callback, limit) {
        var wait = false;
        return function() {
            if (wait) {
                return;
            }
            callback.call();
            wait = true;
            setTimeout(function() {
                wait = false;
            }, limit);
        };
    }

    function stickySideBars() {
        var $fixedDivLeft = $('.fixed-div-left');
        var $fixedDivRight = $('.fixed-div-right');

        var $windowPort = $(window).outerHeight();

        var divLeftHeight = $fixedDivLeft.outerHeight();
        var divRightHeight = $fixedDivRight.outerHeight();

        var divOffset = $fixedDivLeft.offset().top;

        var divLeftTotal = divLeftHeight + divOffset;
        var divRightTotal = divRightHeight + divOffset;

        if ($windowPort < divLeftTotal) {
            $fixedDivLeft.unstick()
        } else {
            $fixedDivLeft.sticky({getWidthFrom: '.fixed-div-left', topSpacing: 8})

        }

        if ($windowPort < divRightTotal) {
            $fixedDivRight.unstick()
        } else {
            $fixedDivRight.sticky({getWidthFrom: '.fixed-div-right', topSpacing: 8})
        }
    }

    stickySideBars();

    if ('classList' in document.documentElement && 'addEventListener' in window) {
        window.addEventListener("resize", debounce(stickySideBars, 100));
        window.addEventListener("resize", throttle(stickySideBars, 100));
    }
});