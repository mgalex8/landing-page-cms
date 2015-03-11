<!DOCTYPE html>
<head>
    <title><?php if ( !empty($title) ):
        echo $title;
    else:
        echo 'Home Page';
    endif;
    ?></title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <!-- jQuery -->
    <script src="http://code.jquery.com/jquery-latest.js"></script>
    <script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js"></script>
    <link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/themes/ui-lightness/jquery-ui.min.css" rel="stylesheet" media="screen">
    <!-- Bootstrap -->
    <link href="<?php echo URL::base(true) ?>bootstrap/css/admin/bootstrap.css" rel="stylesheet" media="screen">
    <link href="<?php echo URL::base(true) ?>bootstrap/css/admin/bootstrap-select.min.css" rel="stylesheet" media="screen">
    <link href="<?php echo URL::base(true) ?>bootstrap/css/admin/style.css" rel="stylesheet" media="screen">
    <script src="<?php echo URL::base(true) ?>bootstrap/js/admin/bootstrap.min.js"></script>
    <script src="<?php echo URL::base(true) ?>bootstrap/js/admin/bootstrap-select.min.js"></script>
    <script src="<?php echo URL::base(true) ?>bootstrap/js/admin/datepicker/js/bootstrap-datepicker.js"></script>
    <link href="<?php echo URL::base(true) ?>bootstrap/js/admin/datepicker/css/datepicker.css" rel="stylesheet" media="screen">
</head>
<body>

        <div class="navbar navbar-fixed-top">
            <div class="navbar-inner">
                <div class="container">
                    <a class="brand" href="/"><?php echo Kohana::$config->load('general')->get('site_name') ?></a>
                    <?php if (Auth::instance()->logged_in('admin')) { ?>
                    <ul class="nav">
                        <li <?php if (Request::$current->controller() == 'slider') echo 'class="active"' ?>>
                            <a href="<?php echo URL::base() . Route::get('admin')->uri(array('controller' => 'slider', 'action' => 'index')) ?>"><?php echo __('Slider') ?></a>
                        </li>                        
                        <li <?php if (Request::$current->controller() == 'services') echo 'class="active"' ?>>
                            <a href="<?php echo URL::base() . Route::get('admin')->uri(array('controller' => 'services', 'action' => 'index')) ?>"><?php echo __('Services') ?></a>
                        </li>
                        <li <?php if (Request::$current->controller() == 'portfolio') echo 'class="active"' ?>>
                            <a href="<?php echo URL::base() . Route::get('admin')->uri(array('controller' => 'portfolio', 'action' => 'index')) ?>"><?php echo __('Portfolio') ?></a>
                        </li>
                        <li <?php if (Request::$current->controller() == 'reviews') echo 'class="active"' ?>>
                            <a href="<?php echo URL::base() . Route::get('admin')->uri(array('controller' => 'reviews', 'action' => 'index')) ?>"><?php echo __('Reviews') ?></a>
                        </li>
                        <li <?php if (Request::$current->controller() == 'positions') echo 'class="active"' ?>>
                            <a href="<?php echo URL::base() . Route::get('admin')->uri(array('controller' => 'positions', 'action' => 'index')) ?>"><?php echo __('Positions') ?></a>
                        </li>                        
                    </ul>
                    <form class="navbar-form pull-right">
                        <ul class="nav">                            
                            <li><a title="<?php echo __('Structures'); ?>" class="btn btn-default"href="<?php echo URL::base() . Route::get('admin')->uri(array('controller' => 'structures', 'action' => 'index')) ?>"><i class="icon-indent-left"></i></a></li>
                            <li><a title="<?php echo __('Menus'); ?>" class="btn btn-default" href="<?php echo URL::base() . Route::get('admin')->uri(array('controller' => 'menus', 'action' => 'index')) ?>"><i class="icon-list"></i></a></li>
                            <li><a title="<?php echo __('Users'); ?>" class="btn btn-default" href="<?php echo URL::base() . Route::get('admin')->uri(array('controller' => 'users', 'action' => 'index')) ?>"><i class="icon-user"></i></a></li>
                            <li><a title="<?php echo __('Settings'); ?>" class="btn btn-default" href="<?php echo URL::base() . Route::get('admin')->uri(array('controller' => 'settings', 'action' => 'index')) ?>"><i class="icon-cog"></i></a></li>
                            <li><a href="<?php echo URL::base() . Route::get('admin')->uri(array('controller' => 'login', 'action' => 'logout')) ?>"><?php echo __('Logout') ?></a></li>
                        </ul>
                    </form>
                    <?php } ?>
                </div>
            </div>
        </div>

        <div class="container" style='margin-top: 40px'>

            <?php echo $content ?>

        </div>
    </body>
</html>