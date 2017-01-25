var clicks = 0;
function addKudos() {
    clicks += 1;
    document.getElementById('amountofclicks').innerHTML = clicks;
}



$(document).ready(function() {

    $('#button').on('click', function () {

        console.log('test', $('#amountofclicks').html());
        $.get("/kudo_guidelines?kudo_amount=" + parseInt($('#amountofclicks').html()), function (data) {

            console.log("getting guidelines", data);
            $(".guidelines_container").html(data);
            $('.guidelines_container').each(function () {
                // debugger
                var $this = $(this);
                for (var i = 0; i < data.length; i++) {
                    console.log("datarow", data[i][0], data[i][1])
                    data[i] = wrap_activity_in_li(data[i])
                }
                $this.html($('<ul>').html(data));
            });
        })
    });
    function wrap_activity_in_li(activity) {
        return activity = '<li>' + activity[0] + '<span>' + activity[1] + '</span>' + '</li>';

    }


});