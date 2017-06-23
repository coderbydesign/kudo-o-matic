$(document).ready(function () {
   $('.btn-filter').click(function () {
       $('.filter-content').toggleClass('slide-menu');
       $('.filter-content .menu-tooltip').toggleClass('show-tooltip');
   });

    var $ajaxpreloader = $('.ajax-preloader');

    $('.my-transactions').click(function () {
        $ajaxpreloader.addClass('show-preloader');
        $.ajax({
            type:'GET',
            url: "/transactions.js?filter=mine", complete: function (result) {
                $ajaxpreloader.removeClass('show-preloader');
            }, succes: function () {
                $('.btn-filter').html('My total transactions');
                $('.delete-filter').addClass('show-delete');
            }
        });
        return false
    });

    $('.send-transactions').click(function () {
        $ajaxpreloader.addClass('show-preloader');
        $.ajax({
            type:'GET',
            url: "/transactions.js?filter=send", complete: function (result) {
                $ajaxpreloader.removeClass('show-preloader');
            }, succes: function () {
                $('.btn-filter').html('My given transactions');
                $('.delete-filter').addClass('show-delete');
            }
        });
        return false
    });

    $('.received-transactions').click(function () {
        $ajaxpreloader.addClass('show-preloader');
        $.ajax({
            type:'GET',
            url: "/transactions.js?filter=received", complete: function (result) {
                $ajaxpreloader.removeClass('show-preloader');
            }, succes: function () {
                $('.btn-filter').html('My received transactions');
                $('.delete-filter').addClass('show-delete');
            }
        });
        return false
    });

    $('.all-transactions, .delete-filter').click(function () {
        $ajaxpreloader.addClass('show-preloader');
        $.ajax({
            type:'GET',
            url: "/transactions.js?filter=all", complete: function (result) {
                $ajaxpreloader.removeClass('show-preloader');
            }, succes: function () {
                $('.btn-filter').html('All transactions');
                $('.delete-filter').removeClass('show-delete');
            }
        });
        return false
    });

    $('.filter-content .menu-content').click(function () {
        $('.filter-content').removeClass('slide-menu');
        $('.filter-content .menu-tooltip').removeClass('show-tooltip');
    });
});