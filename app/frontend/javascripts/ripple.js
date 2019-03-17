(function() {
    var ripple, ripples, RippleEffect,loc, cover, coversize, x, y, i, num;
    
    ripples = document.querySelectorAll('.ripple');
  
    RippleEffect = function(e) {
    ripple = this;
    cover = document.createElement('span');
    coversize = ripple.offsetWidth;
    loc = ripple.getBoundingClientRect();
    x = e.pageX - loc.left - window.pageXOffset - (coversize / 2);
    y = e.pageY - loc.top - window.pageYOffset - (coversize / 2);
    pos = 'top:' + y + 'px; left:' + x + 'px; height:' + coversize + 'px; width:' + coversize + 'px;';
  
    ripple.appendChild(cover);
    cover.setAttribute('style', pos);
    cover.setAttribute('class', 'rp-effect');
    
    setTimeout(function() {
        var list = document.getElementsByClassName( "rp-effect" ) ;
        for(var i =list.length-1;i>=0; i--){
            list[i].parentNode.removeChild(list[i]);
        }
    }, 2000)};

    for (i = 0, num = ripples.length; i < num; i++) {
        ripple = ripples[i];
        ripple.addEventListener('mousedown', RippleEffect);
    }
}());