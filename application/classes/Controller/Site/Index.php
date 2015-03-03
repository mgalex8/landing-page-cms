<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Site_Index extends Controller_Base
{
    public $template = 'layouts/template-site';

    public function action_index()
    {        
        $view = View::factory('site/index');
        $this->template->title = 'Black Cat';
        
                
        $positions = ORM::factory('Positions')->find_all();
        $positions_data = array();
        foreach($positions as $position)
        {
            $key = $position->name;
            $positions_data[$key] = $position->text;        
        }
        $view->positions = $positions_data;
        $view->result = array();        
	$this->display($view);
    }
    
} // end Controller_Admin_Users
