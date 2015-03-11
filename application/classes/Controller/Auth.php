<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Auth extends Controller_Base {

   public function __construct($request, $response)
   {
        parent::__construct($request, $response);

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

}