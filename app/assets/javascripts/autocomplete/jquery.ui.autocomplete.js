$(document).ready(function () {
    return $('#transaction_receiver_name').autocomplete ({
        source: $('#transaction_receiver_name').data('autocomplete-source'),
        autoFocus: true,
        maxShowItems: 5
    });
});