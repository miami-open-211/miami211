$(document).on("ready", function(){
    
    let radius;
    
    // Reset all checkboxes
    function resetBoxes(){
        $(".form-check-input").attr("checked", false)
    }
    
    // When a 'Refine by Distance' value is selected...
    $("#radius").change(function(){ 
        resetBoxes()
        radius = Number($(this).find("option:selected").val())
        console.log(radius)
        showRefined()
    })
    
    // Hide/show .search-results according to distance
    function showRefined(){
        let count = 0
        $(".each-result").each(function(){
            const this_distance = Number($(this).attr("data-distance"))
            if (radius >= this_distance){
                $(this).show();
                $(this).trigger("marker:show")
                $(this).trigger("distance:display");
                count++
            } else {
                $(this).hide();
                $(this).trigger("marker:hide")
            }
        })
        numberResults(count)
    }
    
    // Update #number-results
    function numberResults(count){
        let word = " results"
        if (count === 1){
            word = " result"
        }
        $("#number-results").text(count + word)
    }

})