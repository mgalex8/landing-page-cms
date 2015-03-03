<?php

defined('SYSPATH') or die('No direct script access.');

class Controller_Base extends Controller_Template {

    public function __construct($request, $response) {
        parent::__construct($request, $response);
    }

    public function display(& $view, $can_load = false) {
        $this->template->site_name = Kohana::$config->load('general')->site_name;
        $this->template->content = $view;
    }

    public function display_ajax($view) {
        $this->auto_render = false;
        echo $view;
    }

}
