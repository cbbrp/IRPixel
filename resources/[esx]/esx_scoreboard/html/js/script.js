var visible = false;
var shows = {
	mecano: true,
	weazel: true,
	ambulance: true,
	taxi: true,
	government: true
}

$(function (){
	// Title Fade
	var ih = 0;
	setInterval(function() {
		$('.header h3').fadeOut();
		$(".header h3:eq("+ih+")").fadeIn();
	  	if(ih == 1) {
			ih = 0;
	  	} else {
			ih++;
	  	};
	}, 2000);
	window.addEventListener('message', function(event){
		switch(event.data.action){
			case 'toggle':
				if(visible){
					$('.container').css('height', '0px');
					this.setTimeout(() => {
						$('#wrap').fadeOut();
					}, 1000)
				}else{
					$('#wrap').fadeIn();
					this.setTimeout(() => {
						$('.container').css('height', '200px');
					}, 500)
				};
				visible = !visible;
				break;
			case 'close':
				$('.container').css('height', '0px');
				this.setTimeout(() => {
					$('#wrap').fadeOut();
				}, 1000)
				visible = false;
				break;
			case 'updateInfo':
				if(event.data.data){
					var data = event.data.data;
					for(var k in data){
						if (shows[k]) {
							$(`.${k} p`).html(data[k]);
						}
					};

					$('#Vadmins').html(data.admins);
					$('#Vcount').html(data.total);
					Jewelery(data.police)
					Bank(data.police)
					Shop(data.police)
				};
				break;
			default:
				console.log('Case vared shode peyda nashod!');
				break;
		};
	}, false);
});

function Jewelery(cops){
	if(cops >= 4){
		$(`.jewelery`).css('border', '2px #ffffff solid');
		$(`.jewelery img`).attr('src', './images/Robb/JewelryActive.png');
		$(`.jewelery`).addClass('glow');
	}else{
		$(`.jewelery`).css('border', '2px #858585 solid');
		$(`.jewelery img`).attr('src', './images/Robb/JewelryDeactive.png');
		$(`.jewelery`).removeClass('glow');
	};
};

function Bank(cops){
	if(cops >= 10){
		$(`.centeralbank`).css('border', '2px #ffffff solid');
		$(`.centeralbank img`).attr('src', './images/Robb/CBankActive.png');
		$(`.centeralbank`).addClass('glow');
	}else{
		$(`.centeralbank`).css('border', '2px #858585 solid');
		$(`.centeralbank img`).attr('src', './images/Robb/CBankDeactive.png');
		$(`.centeralbank`).removeClass('glow');
	};
};

function Shop(cops){
	if(cops >= 3){
		$(`.shop`).css('border', '2px #ffffff solid');
		$(`.shop img`).attr('src', './images/Robb/ShopActive.png');
		$(`.shop`).addClass('glow');
	}else{
		$(`.shop`).css('border', '2px #858585 solid');
		$(`.shop img`).attr('src', './images/Robb/ShopDeactive.png');
		$(`.shop`).removeClass('glow');
	};
};