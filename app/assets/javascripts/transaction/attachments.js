$(document).ready(function () {
    $('.add-attachment').click(function () {
        $('#media-attachment').click();
    });

    $('#media-attachment').change(function (event) {
        var files = event.target.files;
        var image = files[0];
        var reader = new FileReader();
        reader.onload = function(file) {
            var img = new Image();
            img.src = file.target.result;
            $('.attachment-preview').html(img)
        };
        reader.readAsDataURL(image)
    });

    $('#media-attachment').one("change", function () {
        console.log('change')
        $('.attachment-content').addClass('show-attachment');
        $('.attachment-tooltip').addClass('show-tooltip');
    });

    $('#media-attachment').change(function () {
        var $pathname = ($('#media-attachment').val());
        var splitPath = $pathname.split("fakepath\\")[1];
        $('.file-name').html(splitPath);
    });

    function heightAttachment() {
        var $addAttachment = $('.add-attachment');
        var $offsetTop = $addAttachment.offset().top;
        var $height = $addAttachment.height();
        $('.attachment-content').css({ top: $offsetTop + ($height * 2.5)});
    }

    heightAttachment();

    $(window).resize(function () {
        heightAttachment();
    });

    $('.close-message').click(function () {
        heightAttachment();
    });

    $('.add-attachment').draggable(function () {
        
    })
});