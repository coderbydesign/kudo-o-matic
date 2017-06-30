$(document).ready(function () {
    $('#like-me').on('ajax:success', function(e, data, status, xhr) {
        console.log('Done');
    })
});