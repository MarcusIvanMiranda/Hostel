window.onload = function(){
    var btnLandscape = document.getElementById("btnLandscape");
    var btnPortrait = document.getElementById("btnPortrait");
    btnLandscape.onclick = function(){ changeOrientation("landscape"); }
    btnPortrait.onclick = function(){ changeOrientation("portrait"); }

    function changeOrientation(orientation){
        if(document.body.className != orientation) {
            document.body.className = orientation;
        }
    }
}
