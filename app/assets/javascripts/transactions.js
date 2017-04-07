jQuery(function() {
    return $('#transaction_receiver_name').autocomplete({
        source: $('#transaction_receiver_name').data('autocomplete-source'),
        autoFocus: true,
        maxShowItems: 5
    });
});

// jQuery(function() {
//     return $('#transaction_activity_name').autocomplete({
//         source: $('#transaction_activity_name').data('autocomplete-source'),
//         autoFocus: true,
//         maxShowItems: 5
//     });
// });

function showDiv() {
    $('#create-transaction-container').slideDown(750);
}

function hideDiv() {
    $('#create-transaction-container').slideUp(750);
}

function showGoals() {
    $('.chart--second-goal').slideToggle("slow");
}

function showMenu() {
    $('.dropdown-content').slideToggle("slow");
}

function showFilters() {
    $('.hidden-menu').slideToggle("slow");
}

$(function () {
    $('span').click(function () {
        $(this).find('i').toggleClass('fa-chevron-down fa-chevron-up')
    });
});

$(function () {
    $('.current-user').click(function () {
        $(this).find('i').toggleClass('fa-bars fa-chevron-up')
    })
});

$(function () {
    $('.filter-option').click(function () {
        $(this).find('i').toggleClass('fa-square-o fa-check-square-o')
    })
});

function showError() {
    $('#info').fadeIn(750)
}

if ($('.error').length) {  // return's true if element is present
    // show or hide another div
    $('#create-transaction-container').show();
}
