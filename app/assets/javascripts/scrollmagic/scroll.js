// create a scene
$(document).ready(function () {
    var controllerLeft = new ScrollMagic.Controller();
    var controllerRight = new ScrollMagic.Controller();

    var containerLeft = new ScrollMagic.Scene({triggerElement: '.container-left'})
        .offset(325)
       .setPin('.fixed-div')
       .addTo(controllerLeft)

    var containerRight = new ScrollMagic.Scene({triggerElement: '.container-right'})
        .offset(325)
        .setPin('.fixed-div2')
        .addTo(controllerRight)
});