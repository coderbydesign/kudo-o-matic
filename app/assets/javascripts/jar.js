var worker = null;
var loadedPercentage = 0;

function increment() {
    $('#counter').html(loader.balanceCoins +'');
    $('#drink').css('top', (100-loadedPercentage*.9)+'%');

    if(loadedPercentage % 5 == 0){
        slice = loadedPercentage / 5
        $('#cubes div:nth-child(' + slice +')').fadeIn(100)
    }

    if(loadedPercentage == loader.balancePercentage) {
        loadedPercentage = 0;
        stopLoading(loader.balancePercentage);
        $(".dynamic").fadeIn(1000);
        $(".loadingmessage").hide();
    }
    else{
        loadedPercentage = loadedPercentage + 1
    }
}

function startLoading(bp) {
    $('#cubes div').hide();
    worker = setInterval(increment , 60);
}
function stopLoading(bp) {
    console.log("stoploading")
    clearInterval(worker);
    setText(bp)
}

function stuff(){

}

$('.input_field').focus(
    function(){
        $(this).parent('div').css('background-color','black');
    }).blur(
    function(){
        $(this).parent('div').css('border-style','dashed');
    });


$(document).ready(function(){
    $(".dynamic").hide();
    window.loader = $('.loader').data()
    if(window.location.pathname == '/'){
        startLoading();
    }
})

$(window).load(function(){
    $(".loader").addClass("movement");
});


