<?php
$title = 'Discos';
include('includes/header.tpl');
include('includes/topbar.tpl');
include('includes/player.tpl');
$current = RAIZ.'/discos';
include('includes/menu.tpl');
?>
<nav aria-label="breadcrumb">
  <ol class="breadcrumb">
    <li class="breadcrumb-item"><a href="<?= RAIZ?>">Home</a></li>
    <li class="breadcrumb-item active" aria-current="page">Discos</li>
  </ol>
</nav>
<?php if(!empty($discos)){?>
<h4>Discos</h4>
<div class="awallholder">
	<?php foreach($discos as $disco){extract($disco);?><a class="ajax awall" href="<?= RAIZ?>/discos/<?= $id?>/<?= urlencode($nomeartista.' '.$nome)?>"><div class="img capinhaWall" style="background-image:url('<?= addslashes($caminho)?>/disco.png');"></div></a><?php }?>
</div>
<?php }?>
<?php include('includes/footer.tpl');