$( document ).ready(function() {
	$(function() {
		$('#drag1').draggable();
	});
	$(function() {
		$('#drag2').draggable();
	});
	$(function() {
		$('#drag3').draggable();
	});
	$(function() {
		$('#drag4').draggable();
	});
	$(function() {
		$('#drag5').draggable();
	});
	$(function() {
		$('#drag6').draggable();
	});
	$(function() {
		$('#drag7').draggable();
	});
	$(function() {
		$('#drag8').draggable();
	});
	$(function() {
		$('#drag9').draggable();
	});
	$(function() {
		$('#drag10').draggable();
	});
	$(function() {
		$('#drag11').draggable();
	});
	/* $( ".p_klick" ).click(function() {
				$('.ul').show();
	}); */
	var maskBlock = $('.klikinner');
	maskBlock.click(function(){
       maskBlock.removeClass('active');
       $(this).addClass('active');
	});
	$( ".lend1" ).click(function() {
				$('.okno1').show();
				$('.klik3').hide();
				$(this).css("color","#069e2a")
	});
	$( ".lend2" ).click(function() {
				$('.okno2').show();
				$('.klik3').hide();
				$(this).css("color","#069e2a")
	});
	$( ".lend3" ).click(function() {
				$('.okno3').show();
				$('.klik3').hide();
				$(this).css("color","#069e2a")
	});
	$( ".lend4" ).click(function() {
				$('.okno4').show();
				$('.klik3').hide();
				$(this).css("color","#069e2a")
	});
	$( ".lend5" ).click(function() {
				$('.okno5').show();
				$('.klik3').hide();
				$(this).css("color","#069e2a")
	});
	$( ".lend6" ).click(function() {
				$('.okno6').show();
				$('.klik3').hide();
				$(this).css("color","#069e2a")
	});
	$( ".lend7" ).click(function() {
				$('.okno7').show();
				$('.klik3').hide();
				$(this).css("color","#069e2a")
	});
	$( ".lend8" ).click(function() {
				$('.okno8').show();
				$('.klik3').hide();
				$(this).css("color","#069e2a")
	});
	$( ".lend9" ).click(function() {
				$('.okno9').show();
				$('.klik3').hide();
				$(this).css("color","#069e2a")
	});
	$( ".lend10" ).click(function() {
				$('.okno10').show();
				$('.klik3').hide();
				$(this).css("color","#069e2a")
	});
	$( ".lend11" ).click(function() {
				$('.okno11').show();
				$('.klik3').hide();
				$(this).css("color","#069e2a")
	});
	$('.close').click(function(){
				$(this).parent().hide();
	});
	$( ".close1" ).click(function() {
				$('.lend1').css("color","#000");
				return;
	});
	$( ".close2" ).click(function() {
				$('.lend2').css("color","#000")
	});
	$( ".close3" ).click(function() {
				$('.lend3').css("color","#000")
	});
	$( ".close4" ).click(function() {
				$('.lend4').css("color","#000")
	});
	$( ".close5" ).click(function() {
				$('.lend5').css("color","#000")
	});
	$( ".close6" ).click(function() {
				$('.lend6').css("color","#000")
	});
	$( ".close7" ).click(function() {
				$('.lend7').css("color","#000")
	});
	$( ".close8" ).click(function() {
				$('.lend8').css("color","#000")
	});
	$( ".close9" ).click(function() {
				$('.lend9').css("color","#000")
	});
	$( ".close10" ).click(function() {
				$('.lend10').css("color","#000")
	});
	$( ".close11" ).click(function() {
				$('.lend11').css("color","#000")
	});
	/* $(".klikinner").click(function () {
		$(".klik3").hide();
		var index = $(this).index();
		index++;
		$('.opendiv'+index).show();
		$(".klikinner").removeClass("active");
		$(this).addClass("active");		
		}); */
	$(".ssilka").click(function () {
		$(".klik3").show();
	});
	$(function(){
		$('#slider').anythingSlider({
			autoPlay: true,                 
			delay: 5000,   
			resumeDelay : 15000,
			animationTime: 600
		});
	});
	$(function () {
		$('#slider2').anythingSlider({
		autoPlay: true,                 
		delay: 3000,   
		resumeDelay : 15000,
		animationTime: 600  
	});
	});
	new cbpScroller( document.getElementById( 'cbp-so-scroller' ) );
  var decimal_places = 1;
  var decimal_factor = decimal_places === 0 ? 1 : decimal_places;
  $('#lines111').animateNumber(
    {
      number: 180,
    },
    7000
  )
  $('#lines211').animateNumber(
    {
      number: 10,
    },
    5000
  )
  $('#lines311').animateNumber(
    {
      number: 85,
    },
    7000
  )

	$( document ).ready(function() {
		$(".minis").click(function () {
		var index = $(this).index();
		index++;
		$('.mini'+index).show();
		$(".minis").removeClass("actives");
		$(this).addClass("actives");		
		});
	});	
	$('a[href*=#]').bind("click", function(e){
      var anchor = $(this);
      $('html, body').stop().animate({
         scrollTop: $(anchor.attr('href')).offset().top
      }, 1000);
      e.preventDefault();
	});
       /*  $(window).scroll(function(){

            var bo = $("body").scrollTop();

            $('#lines111').text(bo);

            if ( bo > 500 ) { $("#lines111").animateNumber(
			{
			number:180,
			},
			7000
			); };

        }); */

    $( ".s1" ).click(function() {
				$('.sait1').show();
	});
	$( ".s2" ).click(function() {
				$('.sait2').show();
	});
	$( ".s3" ).click(function() {
				$('.sait3').show();
	});
	$( ".s4" ).click(function() {
				$('.sait4').show();
	});
	$( ".s5" ).click(function() {
				$('.sait5').show();
	});
	$( ".s6" ).click(function() {
				$('.sait6').show();
	});
	$( ".s7" ).click(function() {
				$('.sait7').show();
	});
	$( ".s8" ).click(function() {
				$('.sait8').show();
	});
	$( ".s9" ).click(function() {
				$('.sait9').show();
	});
	$( ".s10" ).click(function() {
				$('.sait10').show();
	});
	$( ".s11" ).click(function() {
				$('.sait11').show();
	});
	$('.podrobno').click(function(){
				$(this).hide();
	});

});