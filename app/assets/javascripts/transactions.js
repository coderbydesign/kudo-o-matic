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
    $('.transaction-filters').slideToggle("slow");
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

$(document).ready(function() {
    $('.filter-option').click(function (e) {
        e.preventDefault();
        if ($('.filter-option i').hasClass('fa-check-square-o')) {
            $.ajax({
                type:'GET',
                url: "/dashboard.js?filter=mine", success: function (result) {

                },
                error: function (xhr, error) {
                    console.log('error', xhr, error)
                }
            });
        } else {
            $.ajax({
                type:'GET',
                url: "/dashboard.js?filter=all", success: function (result) {
                    console.log('else');
                }
            });
        }
    });
});

// if ($('.filter-option i').hasClass('fa-check-square-o')) {
//     $.ajax({
//         url: "both", success: function (result) {
//             $("#results").html(result).show();//html(result);
//         }
//     });
//     // $("#results").load("both");
// } else {
//     $.ajax({
//         url: "all", success: function (result) {
//             $("#results").html(result).show();//html(result);
//         }
//     });
//     // $("#results").load("all");
// }


// $(document).ready(function(){
//     $(".filter-option.sent").click(function() {
//         var filter = $(this).html();
//
//         $(".timeline-container").hide();
//
//
//     });
// });


// window.onload = function () {
//     var input = document.querySelector('input[type=checkbox]');
//     var a;
//
//     function check() {
//         if (input.checked) {
//             a = '- @transactions.each do |transaction|';
//         } else {
//             a = "not checked";
//         }
//         document.getElementsByClassName('timeline-container').innerHTML = a;
//     }
//     input.onchange = check;
// };
// $(document).ready(function(){
//     $(".filter-option.sent").click(function() {
//
//         if ($('.checkbox').is(":checked")) {
//             $.ajax({
//                 url: "transactions/new", success: function (result) {
//                     $("#results").html(result).show();//html(result);
//                     $("#create-transaction-container").hide();
//                     // $('.filter-option.sent').find('i').removeClass('fa-square-o');
//                     // $('.filter-option.sent').find('i').addClass('fa-check-square-o');
//                 }
//             });
//         }
//         else {
//             $.ajax({
//                 url: "transactions/new", success: function (result) {
//                     $("#results").html(result).hide();//html(result);
//                     $("#create-transaction-container").hide();
//                     // $('.filter-option.sent').find('i').removeClass('fa-square-o');
//                     // $('.filter-option.sent').find('i').addClass('fa-check-square-o');
//                 }
//             });
//         }
//     });
// });
// if($('#popup').find('p.filled-text').length != 0)
// if ($("#about").hasClass("opened")) {
//     $("#about").animate({right: -700 +"px"}, 2000);
// }



