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

    $('#media-attachment').on("change", function () {
        $('.attachment-content').addClass('show-attachment');
        $('.attachment-tooltip').addClass('show-tooltip');
    });

    $('#media-attachment').change(function () {
        var $pathname = ($('#media-attachment').val());
        var splitPath = $pathname.split("fakepath\\")[1];
        $('.file-name').html(splitPath);
    });

    function offsetAttachment() {
        var $addAttachment = $('.add-attachment');
        var $offsetTop = $addAttachment.offset().top;
        var $offsetLeft = $addAttachment.offset().left;
        var $height = $addAttachment.height();
        $('.attachment-content').css({ top: $offsetTop + ($height * 2.5), left: $offsetLeft - 8  });
    }

    offsetAttachment();

    $(window).resize(function () {
        offsetAttachment();
    });

    $('.close-message').click(function () {
        offsetAttachment();
    });

    $('.destroy-attachment').click(function () {
        var $el = $('#media-attachment');
        $el.wrap('<form>').closest('form').get(0).reset();
        $el.unwrap();
        $('.attachment-content').removeClass('show-attachment');
    })
});