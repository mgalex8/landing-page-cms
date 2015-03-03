<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Admin_Users extends Controller_Auth
{
    public $template = 'layouts/admin';
    
    public $modelName = 'Users';

    public function action_index()
    {
        if (!empty($_POST['delete']))
        {
            $this->_delete(array_keys($_POST['delete']));
        }
        $view = View::factory('scripts/admin/users');
        $page = intval(Arr::get($_GET, 'page', 1));                        
        if ($page < 1) {
            $page = 1;
        }        
        $view->page = $page;
        $per_page = 10;
        
        $this->template->title = "Users";
        $pagination_view = new View('pagination/pages');
        $pagination_view->page = $page;
        $pagination_view->perpage = $per_page;        
        $pagination_view->count_all = ORM::factory( $this->modelName )->count_all();
        $view->pagination = $pagination_view->render();                
        
        $users = array();        
        $orm = ORM::factory( $this->modelName )
                        ->order_by('id','asc')
                        ->limit($per_page)
                        ->offset(($page - 1) * $per_page)
                        ->find_all();              
        foreach ($orm as $item)
        {
            if ($item->last_login) {
                $last_login = date('Y-m-d H:i:s', $item->last_login);
            }
            else {
                $last_login = '';
            }
            $users[] = array(
                'id' => $item->id,
                'username' => $item->username,
                'email' => $item->email,
                'last_login' => $last_login,
                'created' => $item->created,
            );
        }
        $view->result = array(
            'users' => $users,
            'add_url' => URL::base(true) . 'admin/users/addedit',
            'edit_url' => URL::base(true) . 'admin/users/addedit',
        );
	$this->display($view);
    }

    public function action_addedit()
    {
        $view = View::factory('scripts/admin/user_add');
        $errors = array();        
        $id = Arr::get($_GET, 'id', '');
        
        if(empty($id)) {
            $action = 'Add';
            $this->template->title = __("Add User");
            $user = array(
                'id'=>'', 
                'username'=>'', 
                'email'=>'',
                'group_id'=>'',
            );
        }   
        else {
            $action = 'Edit';
            $this->template->title = __("Edit User");
            
            $edit = ORM::factory( $this->modelName, $id);
            if($edit->loaded())
            {
                 $user = array(
                     'id' => $id,
                     'username' => $edit->username,
                     'email' => $edit->email,  
                     'group_id' => $edit->group_id,  
                 );
            }
            else
            {
                throw HTTP_Exception::factory(404, 'User not found!');
            }
        }
        
        if(!empty($_POST)) 
        {   
            $post = array();
            $post['username'] = Arr::get($_POST, 'username', null);
            $post['email'] = Arr::get($_POST, 'email', null);
            $post['group_id'] = Arr::get($_POST, 'group_id', null);
            $password = Arr::get($_POST, 'password', null);
            $confirm_password = Arr::get($_POST, 'password2', null);
            $user = $post;            
            
            // Validation
            $errors = array();
            if (empty($post['username'])) {
                $errors['username'] = __("Empty username");
            }
            if (empty($post['email'])) {
                $errors['email'] = __("Empty email");
            }
            if (empty($password)) {                
                $errors['password'] = __("Empty password");
            }
            if (empty($confirm_password)) {                
                $errors['password2'] = __("Confirm password");
            }
            
            if (!$errors)
            {   
                if ($password == $confirm_password)
                {
                    $pwd = Auth::instance()->hash_password($password);                

                    $data = $post;
                    $data['password'] = $pwd;
                    $data['email'] = Arr::get($_POST, 'email', null);
                    $data['created'] = time(); 

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
                    $route = Route::get('admin')->uri(array('controller' => 'users', 'action' => 'index'));
                    $qs = (!empty($id)) ? ('?id='.$id) : '';            
                    Controller::redirect( URL::base(true) . $route . $qs );
                }
                else {
                     $errors['password2'] = __("Confirm password");               
                }
            }
        } 
        
        $groups = array();
        $orm = ORM::factory('UserGroups')->find_all();
        foreach ($orm as $group) {
            $groups[] = array(
                'id' => $group->id,
                'name' => $group->name,
                'title' => $group->title,                
            );
        }
                
        $view->result = array(  
            'title' => __($action . ' User'),
            'action_url' => URL::base(true) . 'admin/users/addedit?id=' . $id,
            'user' => $user,
            'groups' => $groups,
            'errors' => $errors,
        );
        $this->display($view);
    }
    
    protected function _delete($idUsers = null)
    {
        if (!empty($idUsers))
        {
            $user = ORM::factory('User');

            if ( is_array($idUsers) )
            {
                $user->where('id', 'in', $idUsers);
            }
            else
            {
                $user->where('id', '=', $idUsers);
            }
            $userToDelete = $user->find_all();
            if(count($userToDelete) > 0)
            {
                foreach ($userToDelete as $usr)
                {
                    $usr->delete();
                }
            }
            
        }
    }   

} // end Controller_Admin_Users
