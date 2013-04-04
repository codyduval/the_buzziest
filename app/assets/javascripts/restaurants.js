$(function () {
	$(document).on('click', '#restaurants th a', function () {
    $.getScript(this.href);
    return false;
  });
	$('.mention_highlight').popover({template: '<div class="popover"><div class="arrow"></div><div class="popover-inner"><div class="popover-content"><p></p></div></div></div>'
  });
})
