$(function(){
	$('.panel-body').each(function(){
		var hi = $(this).attr('class');
		var mk = new RegExp(/\d+$/);
		var m = mk.exec(hi);
		nt = $('.nt'+m).html()
		if( $(this).hasClass('mk'+m) && nt != null ){
			$('.nt'+m).parents('article').hide();
			$(this).append(
				'<div class="well well-sm"> \
					<span class="label label-default">笔记</span> \
					<div class="noteCont">' + nt +'</div> \
				</div>'
			);
		}
	});
});