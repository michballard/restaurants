$(document).ready(function() {

  $('.endorsements-link').on('click', function(event){
      var endorsementCount = $(this).siblings('.endorsements_count');

      event.preventDefault();

      $.post(this.href, function(response){
        endorsementCount.text(response.new_endorsement_count);
    })
  })
})
