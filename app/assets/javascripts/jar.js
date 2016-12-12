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

function setText(bp){
    if (bp >= 100){
        $(".dynamicmessage").html("FULL! Yes! Very good everyone, this calls for a celebration ");
    }else if (bp > 90){
        $(".dynamicmessage").html("ALMOST FULL, WE GOT THIS! COME ON! ");
    }else if (bp > 80){
        $(".dynamicmessage").html("Over 3 quarters full. The end is in sight! ");
    }else if (bp > 70){
        $(".dynamicmessage").html("Not full yet, why is the jar not full yet? ");
    }else if (bp > 60){
        $(".dynamicmessage").html("Over the halfway mark");
    }else if (bp > 50){
        $(".dynamicmessage").html("Half full or half empty? That is the question ");
    }else if (bp > 40){
        $(".dynamicmessage").html("In need of more coins");
    }else if (bp > 30){
        $(".dynamicmessage").html("Hungry for more coins ");
    }else if (bp > 20){
        $(".dynamicmessage").html("Like a newborn baby and in need of it's life essence: Kudo coins. ");
    }else if (bp > 0){
        $(".dynamicmessage").html("New. So lets get crackin'. ");
    }
};

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


