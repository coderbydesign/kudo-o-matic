$(document).ready(function () {

    // Chart Functionality
    $.fn.setChart = function() {
        return this.each(function() {
            // Variables
            var chart = $(this),
                path = $('.chart__foreground path', chart),
                dashoffset = path.get(0).getTotalLength(),
                goal = chart.attr('data-goal'),
                consumed = chart.attr('data-count');

            $('.chart__foreground', chart).css({
                'stroke-dashoffset': Math.round(dashoffset - ((dashoffset / goal) * consumed))
            });
        });
    }; // setChart()

    // Count
    $.fn.count = function() {
        return this.each(function() {
            $(this).prop('Counter', 0).animate({
                Counter: $(this).attr('data-count')
            }, {
                duration: 1000,
                easing: 'swing',
                step: function(now) {
                    $(this).text(Math.ceil(now));
                }
            });
        });
    }; // count()

    $(window).load(function() {
        $('.js-chart').setChart();
        $('.js-count').count();
    });

    $('.see-more').click(function () {
        $('.container-right').addClass('visible-as-modal');
    });

    $('.close-button, .kudo-counter-background').click(function () {
        $('.container-right').removeClass('visible-as-modal');
    });

});