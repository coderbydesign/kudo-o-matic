$(document).ready(function () {
    var $filterContent = $('.filter-content');
    var team = $filterContent.data('team');
    var $filterContenTooltip = $('.filter-content .menu-tooltip')
    var $ajaxpreloader = $('.ajax-preloader');
    var $btnFilter = $('.btn-filter');
    var $deleteFilter = $('.delete-filter');
    var $myTransactions = $('.my-transactions');
    var $sendTransactions = $('.send-transactions');
    var $receivedTransactions = $('.received-transactions');

    $btnFilter.click(function () {
        $filterContent.toggleClass('slide-menu');
        $filterContenTooltip.toggleClass('show-tooltip');
   });




    $myTransactions.click(function () {
        $ajaxpreloader.addClass('show-preloader');
        // Checks if filter yet active
        if ($myTransactions.hasClass('is-active')) {
            deleteFilter()
        } else {
            $.ajax({
                type:'GET',
                url: "/" + team + "/transactions.js?filter=mine", complete: function (result) {
                    $ajaxpreloader.removeClass('show-preloader');
                }, success: function () {
                    $btnFilter.html('My total transactions');
                    $deleteFilter.addClass('show-delete');
                    $myTransactions.addClass('is-active');
                    $sendTransactions.removeClass('is-active');
                    $receivedTransactions.removeClass('is-active');
                }
            });
        }
        return false
    });

    $sendTransactions.click(function () {
        $ajaxpreloader.addClass('show-preloader');
        // Checks if filter yet active
        if ($sendTransactions.hasClass('is-active')) {
            deleteFilter()
        } else {
            $.ajax({
                type: 'GET',
                url: "/" + team + "/transactions.js?filter=send", complete: function (result) {
                    $ajaxpreloader.removeClass('show-preloader');
                }, success: function () {
                    $btnFilter.html('My given transactions');
                    $deleteFilter.addClass('show-delete');
                    $sendTransactions.addClass('is-active');
                    $myTransactions.removeClass('is-active');
                    $receivedTransactions.removeClass('is-active');
                }
            });
        }
        return false
    });

    $receivedTransactions.click(function () {
        $ajaxpreloader.addClass('show-preloader');
        // Checks if filter yet active
        if ($receivedTransactions.hasClass('is-active')) {
            deleteFilter()
        } else {
            $.ajax({
                type: 'GET',
                url: "/" + team + "/transactions.js?filter=received", complete: function (result) {
                    $ajaxpreloader.removeClass('show-preloader');
                }, success: function () {
                    $btnFilter.html('My received transactions');
                    $deleteFilter.addClass('show-delete');
                    $receivedTransactions.addClass('is-active');
                    $myTransactions.removeClass('is-active');
                    $sendTransactions.removeClass('is-active');
                }
            });
        }
        return false
    });

    $('.all-transactions, .delete-filter').click(function () {
        deleteFilter()
    });

    // Get's all transactions
    function deleteFilter() {
        $.ajax({
            type:'GET',
            url: "/" + team + "/transactions.js?filter=all", complete: function (result) {
                $ajaxpreloader.removeClass('show-preloader');
            }, success: function () {
                $btnFilter.html('All transactions');
                $deleteFilter.removeClass('show-delete');
                $myTransactions.removeClass('is-active');
                $sendTransactions.removeClass('is-active');
                $receivedTransactions.removeClass('is-active');
            }
        });
    }

    $('.filter-content .menu-content').click(function () {
        $filterContent.removeClass('slide-menu');
        $filterContenTooltip.removeClass('show-tooltip');
    });
});