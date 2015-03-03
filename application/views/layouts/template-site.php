<!DOCTYPE html>
<html>
<head>
	<title><?php if ( !empty($title) ):
            echo $title;
        else:
            echo 'Black Cat';
        endif;
        ?></title>
	<meta charset="utf-8"/>
	<link rel="stylesheet" href="<?php echo URL::base(true) ?>css/font.css"/>
	<link rel="stylesheet" href="<?php echo URL::base(true) ?>css/reset.css"/>
	<link rel="stylesheet" href="<?php echo URL::base(true) ?>css/style.css"/>
	<link rel="stylesheet" href="<?php echo URL::base(true) ?>css/anythingslider.css"/>
	<link href="http://code.jquery.com/ui/1.9.1/themes/base/jquery-ui.css" rel="stylesheet">
	<script src="http://yandex.st/jquery/1.8.3/jquery.min.js"></script>
	<script src="<?php echo URL::base(true) ?>js/jquery.anythingslider.js"></script>
	<script src="<?php echo URL::base(true) ?>js/script.js"></script>
	<script src="<?php echo URL::base(true) ?>js/cbpScroller.js"></script>
	<script src="<?php echo URL::base(true) ?>js/modernizr.custom.js"></script>
	<script src="<?php echo URL::base(true) ?>js/classie.js"></script>
	<script src="<?php echo URL::base(true) ?>js/jquery.color.min.js"></script>
	<script src="<?php echo URL::base(true) ?>js/jquery.animateNumber.min.js"></script>
	<script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>
</head>
<body id="o_nas">
    
	<?php echo $content ?>
    
</body>
</html>
