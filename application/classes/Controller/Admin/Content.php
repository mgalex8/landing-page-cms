<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Admin_Content extends Controller_Auth
{	
    public $template = 'layouts/admin';
	
	protected $modelName = 'Content';
    
    public function action_index()
    {
    	//Structure
    	$structureName = Arr::get($_GET, 'structure', null);
		$orm = ORM::factory('Structures')->where('name','=',$structureName)->find();
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
		
		//Parent
		$parentId = Arr::get($_GET, 'parent', 0);
		if ($parentId)
		{
			$parent = ORM::factory( $this->modelName, $parentId );
	        if(!$parent->loaded())
	        {             
	            throw HTTP_Exception::factory(404, 'Parent ID not found!');
	        }
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
        
		//Find
        $content = array();
        $orm = ORM::factory( $this->modelName )
						->where('structure_id','=',$structure['id'])
						->and_where('parent_id','=',$parentId)
						->order_by('is_category','desc')
                        ->order_by('id','asc')
                        ->limit($per_page)
                        ->offset(($page - 1) * $per_page)
                        ->find_all(); 
        foreach ($orm as $item)
        {        	
            $newItem = array(
                'id' => $item->id,
                'structure_id' => $item->structure_id,
                'parent_id' => $item->parent_id,
                'is_category' => $item->is_category,
                'active' => $item->active,
                'created_at' => $item->created_at,
                'update_at' => $item->update_at,
                'name' => $item->name,
            );
			if ($item->is_category)
			{				
                $newItem['edit_url'] = URL::base(true) . 'admin/content/category?structure=' . $structureName . '&id=' . $item->id;
				$newItem['edit_children_url'] = URL::base(true) . 'admin/content?structure=' . $structureName . '&parent=' . $item->id;
			}
			else 
			{
				$newItem['edit_url'] = URL::base(true) . 'admin/content/addedit?structure=' . $structureName . '&id=' . $item->id;
			}
			$content[] = $newItem;
        }
        
        $view->result = array(
        	'structure' => $structure,
            'content' => $content,
            'add_item_url' => URL::base(true) . 'admin/content/addedit?structure=' . $structureName . '&parent=' . $parentId,
            'add_category_url' => URL::base(true) . 'admin/content/category?structure=' . $structureName . '&parent=' . $parentId,            
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
		//Parent
		$parentId = Arr::get($_GET, 'parent', 0);
		if ($parentId)
		{
			$parent = ORM::factory( $this->modelName, $parentId );
	        if(!$parent->loaded())
	        {             
	            throw HTTP_Exception::factory(404, 'Parent ID not found!');
	        }
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
                $qs = '?structure=' . $structureName . '&parent=' . $parentId;            
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

	public function action_category()
    {
    	//Structure
    	$structureName = Arr::get($_GET, 'structure', null);
		$structure = ORM::factory('Structures')->where('name','=',$structureName)->find();
        if(!$structure->loaded())
        {             
            throw HTTP_Exception::factory(404, 'Structure not found!');
        }
		//Parent
		$parentId = Arr::get($_GET, 'parent', 0);
		if ($parentId)
		{
			$parent = ORM::factory( $this->modelName, $parentId );
	        if(!$parent->loaded())
	        {             
	            throw HTTP_Exception::factory(404, 'Parent ID not found!');
	        }
		}
		
		//Content
        $view = View::factory('scripts/admin/content_category_add');
        $errors = array();        
        $id = Arr::get($_GET, 'id', '');
        
        if(empty($id)) {
            $action = 'Add';
            $this->template->title = __("Add Category");
            $category = array(
                'id'=>'', 
                'name'=>'', 
                'text'=>'',
                'active'=>'',               
            );
        }   
        else {
            $action = 'Edit';
            $this->template->title = __("Edit Category");
            
            $edit = ORM::factory( $this->modelName, $id);
            if($edit->loaded())
            {
                 $category = array(
                     'id' => $id,
                     'name' => $edit->name,
                     'text' => $edit->text,
                     'active' => $edit->active,                                           
                 );
            }
            else
            {
                throw HTTP_Exception::factory(404, 'Category not found!');
            }
        }
        
        if(!empty($_POST)) 
        {   
            $post = array();
            $post['name'] = Arr::get($_POST, 'name');            
            $post['text'] = Arr::get($_POST, 'text', null);            
            $category = $post;
            
            // Validation
            $errors = array();
            if (empty($post['name'])) {
                $errors['name'] = __("Empty name");
            }                   
            
            if (!$errors)
            {            	
				$category['structure_id'] = $structure->id;
				$category['parent_id'] = $parentId;
				$category['is_category'] = 1;												
				
                // Save
                if ($action == "Add") {
                	$category['active'] = 1;            
                    ORM::factory( $this->modelName )
                            ->values( $category )
                            ->save();
                }
                else {
                	$category['active'] = (Arr::get($_POST, 'active', '') == 'on');;
                	$category['update_at'] = date('Y-m-d H:i:s');
                    ORM::factory( $this->modelName, $id )
                            ->values( $category )
                            ->save();
                }
                // Redirect                
                $route = Route::get('admin')->uri(array('controller' => 'content', 'action' => 'index'));				
                $qs = '?structure=' . $structureName . '&parent=' . $parentId;            
                Controller::redirect( URL::base(true) . $route . $qs );
            }
        } 

		$action_url = URL::base(true) . 'admin/content/category?id=' . $id . '&structure=' . $structureName;
		$action_url .= (!empty($parentId)) ? '&parent='.$parentId : '';
                
        $view->result = array(  
            'title' => __($action . ' Category'),
            'action_url' => $action_url,
            'category' => $category,
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
