<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Admin_Content extends Controller_Auth
{	
    public $template = 'layouts/admin';
	
	protected $modelName = 'Content';
    
    public function action_index()
    {
    	//Structure
    	$structure = Arr::get($_GET, 'structure', null);
		$orm = ORM::factory('Structures')->where('name','=',$structure)->find();
        if($orm->loaded())
        {
             $structure = array(
                 'id' => $orm->id,
                 'name' => $orm->name,
                 'title' => $orm->title,
                 'i18n' => $orm->i18n,                     
             );
        }
        else
        {
            throw HTTP_Exception::factory(404, 'Structure not found!');
        }
		
		//Content		
        if (!empty($_POST['delete'])) {
            $this->_delete(array_keys($_POST['delete']));
        }	
        $view = View::factory('scripts/admin/content');
        $page = intval(Arr::get($_GET, 'page', 1));
        if ($page < 1) {
            $page = 1;
        }        
        $view->page = $page;
        $per_page = 10;       
        
        $this->template->title = "Content";        
        $pagination_view = new View('pagination/pages');
        $pagination_view->page = $page;
        $pagination_view->perpage = $per_page;        
        $pagination_view->count_all = ORM::factory( $this->modelName )->count_all();
        $view->pagination = $pagination_view->render();                
        
        $content = array();
        $orm = ORM::factory( $this->modelName )
						->where('structure_id','=',$structure['id'])
                        ->order_by('id','asc')
                        ->limit($per_page)
                        ->offset(($page - 1) * $per_page)
                        ->find_all(); 
        foreach ($orm as $item)
        {        	
            $content[] = array(
                'id' => $item->id,
                'structure_id' => $item->structure_id,
                'parent_id' => $item->parent_id,
                'is_category' => $item->is_category,
                'name' => $item->name,                         
                'edit_category_url' => URL::base(true) . 'admin/content/category?structure=' . $structure['id'],
            );
        }
        
        $view->result = array(
        	'structure' => $structure,
            'content' => $content,
            'add_url' => URL::base(true) . 'admin/content/addedit?structure=' . $structure['id'],
            'edit_url' => URL::base(true) . 'admin/content/addedit?structure=' . $structure['id'],
            'add_category_url' => URL::base(true) . 'admin/content/addedit_category?structure=' . $structure['id'],
            'edit_category_url' => URL::base(true) . 'admin/content/addedit_category?structure=' . $structure['id'],
        );        
		$this->display($view);
    }
    

    public function action_addedit()
    {
    	//Structure
    	$structureName = Arr::get($_GET, 'structure', null);
		$structure = ORM::factory('Structures')->where('name','=',$structureName)->find();
        if(!$structure->loaded())
        {             
            throw HTTP_Exception::factory(404, 'Structure not found!');
        }

		//Content
        $view = View::factory('scripts/admin/content_add');
        $errors = array();
        $id = Arr::get($_GET, 'id', '');
        
        if(empty($id)) {
            $action = 'Add';
            $this->template->title = __("Add Item");
            $content = array(
                'id'=>'', 
                'name'=>'', 
                'text'=>'',     
            );
        }   
        else {
            $action = 'Edit';
            $this->template->title = __("Edit Item");
            
            $edit = ORM::factory( $this->modelName, $id);
            if($edit->loaded())
            {
                 $content = array(
                     'id' => $id,
                     'name' => $edit->name,
                     'title' => $edit->text,                                          
                 );
            }
            else
            {
                throw HTTP_Exception::factory(404, 'Content not found!');
            }
        }
        
        if(!empty($_POST)) 
        {   
            $post = array();
            $post['name'] = Arr::get($_POST, 'name');
            $post['title'] = Arr::get($_POST, 'title');
            $post['text'] = Arr::get($_POST, 'text', null);            
            $structure = $post;
            
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
                $route = Route::get('admin')->uri(array('controller' => 'content', 'action' => 'index'));
                $qs = (!empty($id)) ? ('?id='.$id) : '';            
                Controller::redirect( URL::base(true) . $route . $qs );
            }
        } 
                
        $view->result = array(  
            'title' => __($action . ' Item'),
            'action_url' => URL::base(true) . 'admin/structures/addedit?id=' . $id,
            'content' => $content,
            'errors' => $errors,
        );
        $this->display($view);
    }

	public function action_addedit_category()
    {
        $view = View::factory('scripts/admin/content_category_add');
        $errors = array();        
        $id = Arr::get($_GET, 'id', '');
        
        if(empty($id)) {
            $action = 'Add';
            $this->template->title = __("Add Structure");
            $structure = array(
                'id'=>'', 
                'name'=>'', 
                'title'=>'',   
                'i18n'=>'',
            );
        }   
        else {
            $action = 'Edit';
            $this->template->title = __("Edit Structure");
            
            $edit = ORM::factory( $this->modelName, $id);
            if($edit->loaded())
            {
                 $structure = array(
                     'id' => $id,
                     'name' => $edit->name,
                     'title' => $edit->title,
                     'i18n' => $edit->i18n,                     
                 );
            }
            else
            {
                throw HTTP_Exception::factory(404, 'Structure not found!');
            }
        }
        
        if(!empty($_POST)) 
        {   
            $post = array();
            $post['name'] = Arr::get($_POST, 'name');
            $post['title'] = Arr::get($_POST, 'title');
            $post['text'] = Arr::get($_POST, 'text', null);
            $post['i18n'] = Arr::get($_POST, 'i18n', null);
            $structure = $post;
            
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
                $route = Route::get('admin')->uri(array('controller' => 'structures', 'action' => 'index'));
                $qs = (!empty($id)) ? ('?id='.$id) : '';            
                Controller::redirect( URL::base(true) . $route . $qs );
            }
        } 
                
        $view->result = array(  
            'title' => __($action . ' Structure'),
            'action_url' => URL::base(true) . 'admin/structures/addedit?id=' . $id,
            'structure' => $structure,
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
