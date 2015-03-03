<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Admin_Fields extends Controller_Auth
{
    public $template = 'layouts/admin';
    
    public $modelName = 'Fields';

    
    public function action_index()
    {
        if (!empty($_POST['delete'])) {
            $this->_delete(array_keys($_POST['delete']));
        }
        $view = View::factory('scripts/admin/fields');
        $page = intval(Arr::get($_GET, 'page', 1));
        if ($page < 1) {
            $page = 1;
        }        
        $view->page = $page;
        $per_page = 10;       
        
        $this->template->title = "Fields";        
        $pagination_view = new View('pagination/pages');
        $pagination_view->page = $page;
        $pagination_view->perpage = $per_page;        
        $pagination_view->count_all = ORM::factory( $this->modelName )->count_all();
        $view->pagination = $pagination_view->render();                
        
        $structures = array();
        $orm = ORM::factory( $this->modelName )
                        ->order_by('id','asc')
                        ->limit($per_page)
                        ->offset(($page - 1) * $per_page)
                        ->find_all(); 
        foreach ($orm as $item)
        {
            $structures[] = array(
                'id' => $item->id,
                'name' => $item->name,
                'title' => $item->title,
                'i18n' => $item->i18n,                                
            );
        }
        
        $view->result = array(
            'structures' => $structures,
            'add_url' => URL::base(true) . '/admin/fields/addedit',
            'edit_url' => URL::base(true) . '/admin/fields/addedit',
        );        
	$this->display($view);
    }
    

    public function action_addedit()
    {
        $view = View::factory('scripts/admin/field_add');
        $errors = array();        
        $id = Arr::get($_GET, 'id', '');
        
        if(empty($id)) {
            $action = 'Add';
            $this->template->title = __("Add Field");
            $field = array(
                'id'=>'', 
                'name'=>'', 
                'title'=>'',   
                'i18n'=>'',
            );
        }   
        else {
            $action = 'Edit';
            $this->template->title = __("Edit Field");
            
            $edit = ORM::factory( $this->modelName, $id);
            if($edit->loaded())
            {
                 $field = array(
                     'id' => $id,
                     'name' => $edit->name,
                     'title' => $edit->title,
                     'i18n' => $edit->i18n,                     
                 );
            }
            else
            {
                throw HTTP_Exception::factory(404, 'Field not found!');
            }
        }
        
        if(!empty($_POST)) 
        {   
            $post = array();
            $post['name'] = Arr::get($_POST, 'name');
            $post['title'] = Arr::get($_POST, 'title');
            $post['text'] = Arr::get($_POST, 'text', null);
            $post['i18n'] = Arr::get($_POST, 'i18n', null);
            $field = $post;
            
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
                $route = Route::get('admin')->uri(array('controller' => 'fields', 'action' => 'index'));
                $qs = (!empty($id)) ? ('?id='.$id) : '';            
                Controller::redirect( URL::base(true) . $route . $qs );
            }
        } 
                
        $view->result = array(  
            'title' => __($action . ' Structure'),
            'action_url' => URL::base(true) . '/admin/fields/addedit?id=' . $id,
            'field' => $field,
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
