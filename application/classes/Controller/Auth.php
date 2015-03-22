<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Auth extends Controller_Base 
{
	
	public $settings = array();

    public function __construct($request, $response)
    {
        parent::__construct($request, $response);
		
		$settings = ORM::factory('Settings')->where('name','=','admin')->find();
		if ($settings->loaded())
		{
			$this->settings = json_decode($settings->settings, true);
		}

        if (strtolower(Request::current()->directory()) == 'admin' && strtolower(Request::current()->controller()) != 'login')
        {
            //Check admin autentification
            if( !Auth::instance()->logged_in('admin') )
            {
                Session::instance()->set('requestedUrl', $this->request->uri());
                Controller::redirect( Route::get('admin')->uri(array('controller' => 'Login', 'action' => 'Index')) );
            }
        }                
    }
   
    public function display(& $view, $can_load = false) 
    {
    	$menu = ORM::factory('MenuItems')
    					->where('type_id', '=', $this->settings['admin_menu'])
    					->order_by('order','ASC')
						->find_all();
		$this->template->admin_menu = $menu;		
        $this->template->site_name = Kohana::$config->load('general')->site_name;
        $this->template->content = $view;
    }

}