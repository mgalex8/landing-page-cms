<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Admin_Settings extends Controller_Auth
{
    public $template = 'layouts/admin';

    public function action_index()
    {   
        $view = View::factory('scripts/admin/settings');                            
        $this->template->title = __("Settings");
        
        $settings = array(
            'lang' => null,
            'admin_menu' => null,
        );
		
		//Find
        $edit = ORM::factory('Settings')->where('name','=','admin')->find();
        if($edit->loaded())
        {
            $id = $edit->id;
            $settings = json_decode($edit->settings, true);
        }                     
        
        //POST
        if(!empty($_POST)) 
        {        				   
            $post = array();                
            $post['lang'] = Arr::get($_POST, 'lang');
            $post['admin_menu'] = Arr::get($_POST, 'admin_menu');                
            $settings = $post;			

            // Save
            if (!empty($id))
            {
                $orm = ORM::factory('Settings', $id);
            }
            else
            {
                $orm = ORM::factory('Settings');
            }
			
            $orm->settings = json_encode($settings);
			$orm->name = 'admin';
            $orm->save();
        }		

        $result = array();		

        //Menus
        $menus = ORM::factory('MenuTypes')->find_all();
        $result['menus'] = $menus;

        //Languages
        $languages = ORM::factory('Languages')->find_all();
        $result['languages'] = $languages;
        
        //Action url
        $result['action_url'] = URL::base(true) . 'admin/settings';
                
        //Display
        $view->settings = $settings;
        $view->result = $result;        
        $this->display($view);
    }
        
} // end Controller_Admin_Users
