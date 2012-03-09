$(function(){
	$(":submit[data-target]").click(function() {
		var target = $(this).attr("data-target");
		console.log(target);
		$(target).submit();
	});
});