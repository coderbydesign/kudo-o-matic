jQuery(function($) {
    // create a convenient toggleLoading function
    var toggleLoading = function() { console.log('Triggered') };

    $(document)
        // .on("ajax:beforeSend", '.like-me',toggleLoading)
        .on("ajax:complete", toggleLoading)
        .on("ajax:success", '.like-me', function(xhr, data, status) {
            console.log(status);
        });
});