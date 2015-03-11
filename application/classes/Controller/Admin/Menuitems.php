<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Admin_Menuitems extends Controller_Auth
{
    public $template = 'layouts/admin';
    
    public $modelName = 'MenuItems';

    
    public function action_index()
    {
        $type_id = Arr::get($_GET, 'type', null);
        $type = ORM::factory('MenuTypes', $type_id);
        if(!$type->loaded())
        {             
            throw HTTP_Exception::factory(404, 'Menu not found!');
        }
        
        if (!empty($_POST['delete'])) {
            $this->_delete(array_keys($_POST['delete']));
        }
        $view = View::factory('scripts/admin/menu_items');
        $page = intval(Arr::get($_GET, 'page', 1));
        if ($page < 1) {
            $page = 1;
        }        
        $view->page = $page;
        $per_page = 10;       
        
        $this->template->title = "Menu {" . $type->title . '}';        
        $pagination_view = new View('pagination/pages');
        $pagination_view->page = $page;
        $pagination_view->perpage = $per_page;        
        $pagination_view->count_all = ORM::factory( $this->modelName )->where('type_id','=',$type_id)->count_all();
        $view->pagination = $pagination_view->render();                
        
        $menuItems = array();
        $orm = ORM::factory( $this->modelName )
                        ->where('type_id','=',$type_id)
                        ->order_by('id','asc')
                        ->limit($per_page)
                        ->offset(($page - 1) * $per_page)
                        ->find_all(); 
        foreach ($orm as $item)
        {
            $newItem = array(
                'id' => $item->id,
                'name' => $item->name,                
                'i18n' => $item->i18n,                                
                'edit_url' => URL::base(true) . '/admin/menuitems/addedit?type=' . $type_id . '&id=' . $item->id,
            );
            if (!empty($item->href))
            {
                $newItem['link'] = $item->href;
            }
            else
            {
                $newItem['link'] = URL::base(true);
                $newItem['link'].= Route::get($item->route)->uri(array('controller' => $item->controller, 'action' => $item->action));
                $newItem['link'].= !empty($item->qs) ? ('?'.$item->qs) : '';
            }
            $menuItems[] = $newItem;
        }
        
        $view->result = array(
            'menu_items' => $menuItems,      
            'add_url' => URL::base(true) . '/admin/menuitems/addedit?type=' . $type_id,
        );        
	$this->display($view);
    }
    

    public function action_addedit()
    {
        $type_id = Arr::get($_GET, 'type', null);
        $orm = ORM::factory('MenuTypes', $type_id);
        if(!$orm->loaded())
        {             
            throw HTTP_Exception::factory(404, 'Menu Type not found!');
        }
        
        $view = View::factory('scripts/admin/menu_item_add');
        $errors = array();        
        $id = Arr::get($_GET, 'id', '');
        
        if(empty($id)) {
            $action = 'Add';
            $this->template->title = __("Add Menu");
            $menu_item = array(
                'id'=>'', 
                'name'=>'',                   
                'i18n'=>'',
                'type_id'=>$type_id,
                'href' => '',
                'route' => '',
                'controller' => '',
                'action' => '',
                'qs' => '',
                'classes' => '',
            );
        }   
        else {
            $action = 'Edit';
            $this->template->title = __("Edit Menu");
            
            $edit = ORM::factory( $this->modelName, $id);
            if($edit->loaded())
            {
                 $menu_item = array(
                     'id' => $id,
                     'name' => $edit->name,                     
                     'i18n' => $edit->i18n,                     
                     'type_id'=>$edit->type_id,
                     'href' => $edit->href,
                     'route' => $edit->route,
                     'controller' => $edit->controller,
                     'action' => $edit->action,
                     'qs' => $edit->qs,
                     'classes' => $edit->classes,
                 );
            }
            else
            {
                throw HTTP_Exception::factory(404, 'Menu Item not found!');
            }
        }
        
        if(!empty($_POST)) 
        {   
            $post = array();
            $post['name'] = Arr::get($_POST, 'name');            
            $post['i18n'] = Arr::get($_POST, 'i18n', null);            
            $post['type_id'] = Arr::get($_POST, 'type_id', null);
            $post['href'] = Arr::get($_POST, 'href', null);
            $post['route'] = Arr::get($_POST, 'route', null);
            $post['controller'] = Arr::get($_POST, 'controller', null);
            $post['action'] = Arr::get($_POST, 'action', null);
            $post['qs'] = Arr::get($_POST, 'qs', null);
            $post['classes'] = Arr::get($_POST, 'classes', null);
            
            $menu_item = $post;
            
            // Validation
            $errors = array();
            if (empty($post['name'])) {
                $errors['name'] = __("Empty name");
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
                $route = Route::get('admin')->uri(array('controller' => 'menuitems', 'action' => 'index'));
                $qs = '?type=' . $type_id . '&id=' . $id;
                Controller::redirect( URL::base(true) . $route . $qs );
            }
        } 
                
        $view->result = array(  
            'title' => __($action . ' Menu Item'),
            'action_url' => URL::base(true) . '/admin/menuitems/addedit?type=' . $type_id . '&id=' . $id,
            'menu_item' => $menu_item,
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
