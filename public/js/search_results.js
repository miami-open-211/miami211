$(document).on("ready", function(){
    
    let refine_by = []
    
    // Reset all checkboxes
    function resetBoxes(){
        $(".each-result").show()
        $(".each-result").trigger("marker:show");
        $(".form-check-input").attr("checked", false)
    }
    
    // When a 'Refine by' box is checked...
    $(".form-check-input").click(function(){ 
        addRefine($(this).val())
        showRefined()
    })
    
    // Add its value to refine_by (or remove if present)
    function addRefine(x){
        if ($.inArray(x, refine_by) === -1){
            refine_by.push($.trim(x))
        }
        else {
            refine_by.splice($.inArray(x, refine_by), 1)
        }
//        console.log(refine_by)
    }
    
    // Hide/show .search-results according to refine_by contents
    function showRefined(){
        let count = 0
        $(".each-result").each(function(){
            let this_city = $.trim($(this).attr("data-city"))
            let this_zip = $.trim($(this).attr("data-zip"))
            if (refine_by.length === 0){
                $(this).show()
                count++
            } else if (($.inArray(this_city, refine_by) === -1) && ($.inArray(this_zip, refine_by) === -1)){
                $(this).hide();
                $(this).trigger("marker:hide");
            } else {
                $(this).show();
                $(this).trigger("marker:show");
                count++
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
    
    // Collapse descriptions by default
    $(".each-result").click(function(){
        $(this).find(".full-description").toggleClass("collapsed");
        $(this).toggleClass("expanded");
    });
    
    resetBoxes()
})