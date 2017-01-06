$(document).on("ready", function(){
    
    let refine_by = []
    
    // Reset all
    function resetBoxes(){
        $(".each-result").show()
        $(".form-check-input").attr("checked", false)
    }
    
    // When a 'Refine by' box is checked...
    $(".form-check-input").click(function(){ 
        addRefine($(this).val())
        showRefined()
    })
    
    // Add its value to refine_by (or remove if present)
    function addRefine(x){
        if ($.inArray(x, refine_by) == -1){
            refine_by.push($.trim(x))
        }
        else {
            refine_by.splice($.inArray(x, refine_by), 1)
        }
        console.log(refine_by)
    }
    
    // Hide/show .search-results according to refine_by contents
    function showRefined(){
        $(".each-result").each(function(count){
            let this_city = $.trim($(this).find(".org-city").text())
            let this_zip = $.trim($(this).find(".org-zip").text())
            if (refine_by.length == 0){
                $(this).show()
            }
            else if ($.inArray(this_city, refine_by) == -1){
                $(this).hide()
            } else {
                $(this).show()
            }
        })
    }
    
    resetBoxes()
})

/* When a box is checked:
Add its value to an array 
Loop through array
*/ 


