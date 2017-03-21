jQuery(function() {
    return $('#transaction_receiver_name').autocomplete({
        source: $('#transaction_receiver_name').data('autocomplete-source'),
        autoFocus: true,
        maxShowItems: 5
    });
});

jQuery(function() {
    return $('#transaction_activity_name').autocomplete({
        source: $('#transaction_activity_name').data('autocomplete-source'),
        autoFocus: true,
        maxShowItems: 5
    });
});