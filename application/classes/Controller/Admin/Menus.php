<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Admin_Menus extends Controller_Auth
{
    public $template = 'layouts/admin';
    
    public $modelName = 'MenuTypes';

    
    public function action_index()
    {
        if (!empty($_POST['delete'])) {
            $this->_delete(array_keys($_POST['delete']));
        }
        $view = View::factory('scripts/admin/menu_types');
        $page = intval(Arr::get($_GET, 'page', 1));
        if ($page < 1) {
            $page = 1;
        }        
        $view->page = $page;
        $per_page = 10;       
        
        $this->template->title = "Menus";        
        $pagination_view = new View('pagination/pages');
        $pagination_view->page = $page;
        $pagination_view->perpage = $per_page;        
        $pagination_view->count_all = ORM::factory( $this->modelName )->count_all();
        $view->pagination = $pagination_view->render();                
        
        $menus = array();
        $orm = ORM::factory( $this->modelName )
                        ->order_by('id','asc')
                        ->limit($per_page)
                        ->offset(($page - 1) * $per_page)
                        ->find_all(); 
        foreach ($orm as $item)
        {
            $menus[] = array(
                'id' => $item->id,
                'name' => $item->name,
                'title' => $item->title,
                'i18n' => $item->i18n,                
                'edit_menu_url' => URL::base(true) . 'admin/menuitems?type=' . $item->id,
                'edit_url' => URL::base(true) . 'admin/menus/addedit?id=' . $item->id,
            );
        }
        
        $view->result = array(
            'menus' => $menus,
            'add_url' => URL::base(true) . 'admin/menus/addedit',
            
        );        
	$this->display($view);
    }
    

    public function action_addedit()
    {
        $view = View::factory('scripts/admin/menu_type_add');
        $errors = array();        
        $id = Arr::get($_GET, 'id', '');
        
        if(empty($id)) {
            $action = 'Add';
            $this->template->title = __("Add Menu");
            $menu_type = array(
                'id'=>'', 
                'name'=>'', 
                'title'=>'',   
                'i18n'=>'',
            );
        }   
        else {
            $action = 'Edit';
            $this->template->title = __("Edit Menu");
            
            $edit = ORM::factory( $this->modelName, $id);
            if($edit->loaded())
            {
                 $menu_type = array(
                     'id' => $id,
                     'name' => $edit->name,
                     'title' => $edit->title,                     
                 );
            }
            else
            {
                throw HTTP_Exception::factory(404, 'Menu not found!');
            }
        }
        
        if(!empty($_POST)) 
        {   
            $post = array();
            $post['name'] = Arr::get($_POST, 'name');
            $post['title'] = Arr::get($_POST, 'title');
            $menu_type = $post;
            
            // Validation
            $errors = array();
            if (empty($post['name'])) {
                $errors['name'] = __("Empty ID");
            }
            if (empty($post['title'])) {
                $errors['title'] = __("Empty name");
            }             
            
            if (!$errors)
            {            
                // Save
                if ($action == "Add") {            
                    ORM::factory( $this->modelName )
                            ->values($post)
                            ->save();
                }
                else {
                    ORM::factory( $this->modelName, $id )
                            ->values($post)
                            ->save();
                }
                // Redirect
                $route = Route::get('admin')->uri(array('controller' => 'menus', 'action' => 'index'));                            
                Controller::redirect( URL::base(true) . $route);
            }
        } 
                
        $view->result = array(  
            'title' => __($action . ' Menu'),
            'action_url' => URL::base(true) . 'admin/menus/addedit?id=' . $id,
            'menu' => $menu_type,
            'errors' => $errors,
        );
        $this->display($view);
    }
    
    
    protected function _delete($ids = null)
    {
        if (!empty($ids))
        {
            $orm = ORM::factory($this->modelName);

            if ( is_array($ids) )
            {
                $orm->where('id', 'in', $ids);
            }
            else
            {
                $orm->where('id', '=', $ids);
            }
            $itemToDelete = $orm->find_all();
            if(count($itemToDelete) > 0)
            {
                foreach ($itemToDelete as $item)
                {
                    $item->delete();
                }
            }
            
        }
    }    
        
} // end Controller_Admin_Users
