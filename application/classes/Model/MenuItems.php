<?php

defined('SYSPATH') or die('No direct script access.');

class Model_MenuItems extends ORM
{
    protected $_table_name  = 'menu_items';
    protected $_primary_key = 'id';    

    public function rules()
    {
        return array(                        
            'type_id' => array(
                array('not_empty')
            ),
            'name' => array(
                array('not_empty')
            ),
        );
    }
    
}