<?php

defined('SYSPATH') or die('No direct script access.');

class Model_Users extends ORM
{
    protected $_table_name  = 'users';
    protected $_primary_key = 'id';    
    protected $_unique_key = 'username';

    public function rules()
    {
        return array(                        
            'username' => array(
                array('not_empty')
            ),            
        );
    }
    
    public function unique_key()
    {
        return $this->_unique_key;        
    }
}