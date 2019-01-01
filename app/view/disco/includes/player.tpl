<div id="playlist">
	<div class="closer" onclick="toggleHash('#playlist');$('body').toggleClass('noscroll');"><i class="fa fa-2x fa-fw fa-chevron-down"></i></div>
	<div class="table-wrapper"><table class="tabela" id="pl"><tbody></tbody></table></div>
	<table style="display: none;" id="plsauce">
		<tbody>
		<tr>
			<td><i class="fa fa-bars"></i></td>
			<td onclick="playMusica($(this).closest('tr').data('indice'));"><img src="{img}"></td>
			<td onclick="playMusica($(this).closest('tr').data('indice'));"><span class="titulo">{titulo}</span><br><small>{artista}</small></td>
			<td>
				<div class="btn-group">
					<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
						<i class="fa fa-2x fa-ellipsis-v"></i>
					</button>
					<ul class="dropdown-menu pull-right">
						<li onclick="playMusica($(this).closest('tr').data('indice'));">Reproduzir agora</li>
						<li onclick="toggleHash('#playlist');$('body').toggleClass('noscroll');gotoDisco($(this).closest('tr').data('indice'));">Ir para o álbum</li>
						<li onclick="toggleHash('#playlist');$('body').toggleClass('noscroll');gotoArtista($(this).closest('tr').data('indice'));">Ir para o artista</li>
						<li onclick="remFila($(this).closest('tr').data('indice'));">Remover da fila</li>
					</ul>
				</div>
			</td>
		</tr>
		</tbody>
	</table>
</div>
<div id="player-wrapper">
	<div class="capinha" onclick="if (window.fila.length>0){toggleHash('#playlist');$('body').toggleClass('noscroll');}"></div>
	<div id="agulha"></div>
	<audio id="player" src="" type="audio/mpeg" volume="1.0"></audio>
	<input type="range" class="ranger" tabstop="100" id="progresso" min="0" step="0.00001" value="0" disabled/>
	<div class="duracao"><span class="atual">00:00</span><span class="separador"> / </span><span class="total">00:00</span></div>
	<a href="javascript:;" class="controle anterior"><i class="fa fa-2x fa-fw fa-step-backward"></i></a>
	<a href="javascript:;" class="controle middle play"><i class="fa fa-2x fa-fw fa-depende"></i></a>
	<a href="javascript:;" class="controle proxima"><i class="fa fa-2x fa-fw fa-step-forward"></i></a>
	<div id="musica"></div>
	<button id="volume-wrapper" tabstop="78">
		<label for="menuclose"></label>
		<i class="fa fa-fw fa-2x fa-volume-up"></i>
		<input tabindex="-1" class="ranger" type="range" id="volume" min="0" step="0.01" value="1.0" max="1.0"/>
	</button>
</div>
<script type="text/javascript">
	(function(){
		var audio = $('audio#player')[0];
		var atual = $('.duracao .atual');
		var total = $('.duracao .total');
		var slider = $('#progresso');
		var middle = $('.controle.middle');
		var proxima = $('.controle.proxima');
		var anterior = $('.controle.anterior');
		var arrastando = false;
		var volumew = $('#volume-wrapper');
		var volume = $('#volume');

		proxima.on('click',function(){
			if (typeof fila[indice+1]!=='undefined'){
				indice++;
				playMusica(indice);
			}
		});
		anterior.on('click',function(){
			if (typeof fila[indice-1]!=='undefined'){
				indice--;
				playMusica(indice);
			}
		});

		volume.on('input',function(){
			$('#volume-wrapper').focus();
			var valor = parseFloat($(this).val());
			audio.volume = valor;
			if(valor=='0'){
				$('#volume-wrapper i').removeClass('fa-volume-up fa-volume-down').addClass('fa-volume-off');
			}else if(valor<0.5){
				$('#volume-wrapper i').removeClass('fa-volume-off fa-volume-up').addClass('fa-volume-down');
			}else{
				$('#volume-wrapper i').removeClass('fa-volume-off fa-volume-down').addClass('fa-volume-up');
			}
		})

		slider.on("mouseup touchend", function () {
		    arrastando = false;
		});
		slider.on("mousedown touchstart", function () {
			arrastando = true;
		});

		slider.on('change',function(){
			audio.currentTime = $(this).val();
		});

		$('#player-wrapper').on('click','.controle.play',function(){
			if (isNaN(audio.duration)) return;
			if (audio.currentTime == audio.duration){
				audio.currentTime = 0;
			}
			audio.play();
		});
		$('#player-wrapper').on('click','.controle.pause',function(){
			audio.pause();
		});

		var seg_total = 100;
		var seg_atual = 0;

		audio.onloadedmetadata = function(data) {
			slider.removeAttr('disabled');
			slider.attr('max',(audio.duration));
			var minutos = Math.floor(audio.duration / 60);
			var segundos = Math.floor(audio.duration - minutos * 60);
			seg_total = (minutos*60) + segundos;
			segundos = (((''+segundos).length)==1)?'0'+segundos:segundos;
			minutos = (((''+minutos).length)==1)?'0'+minutos:minutos;
			total.text(minutos+':'+segundos);
			atual.text('00:00');
		};
		var corpo = $('body');
		audio.onpause = function(data){
			middle.removeClass('pause').addClass('play');
			corpo.removeClass('play').addClass('pause');
		}
		audio.onplay = function(data){
			middle.removeClass('play').addClass('pause');
			corpo.removeClass('pause').addClass('play');
		}

		var agulha = $('#agulha');
		audio.ontimeupdate = function(data) {
			if (!arrastando){
				slider.val((audio.currentTime));
			}
			var minutos = Math.floor(audio.currentTime / 60);
			var segundos = Math.floor(audio.currentTime - minutos * 60);
			seg_atual = (minutos*60) + segundos;

			var porcentagem_play = (seg_atual*100)/seg_total;
			if (porcentagem_play == 100) porcentagem_play = 99;
			if (porcentagem_play == 0) porcentagem_play = 1;
			var porcentagem_agulha = -25*((100-porcentagem_play)/100);
			
			agulha.css('transform','rotate('+porcentagem_agulha+'deg)');

			segundos = (((''+segundos).length)==1)?'0'+segundos:segundos;
			minutos = (((''+minutos).length)==1)?'0'+minutos:minutos;
			atual.text(minutos+':'+segundos);
		};

		audio.onended = function(data){
			if (typeof fila[indice+1]!=='undefined'){
				indice++;
				playMusica(indice);
			}
		}

		$('body').one('click', function() {
		  context.resume();
		});
		$( "#pl tbody" ).sortable({
			handle: '.fa-bars',
			stop: function( event, ui ) {
				var from = ui.item.closest('.item').data('indice');
				var to = ui.item.index();
				loading();
				array_move(window.fila,from,to);
				if (window.indice == from){
					window.indice = to;
				}else if(from<window.indice && to>=window.indice){
					window.indice--;
				}else if(from>window.indice && to<=window.indice){
					window.indice++;
				}
				atualizaFila();
				stopLoading();
			}
		});
	})();
</script>