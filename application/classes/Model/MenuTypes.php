<?php

defined('SYSPATH') or die('No direct script access.');

class Model_MenuTypes extends ORM
{
    protected $_table_name  = 'menu_types';
    protected $_primary_key = 'id';    

    public function rules()
    {
        return array(                        
            'name' => array(
                array('not_empty')
            ),
            'title' => array(
                array('not_empty')
            ),
        );
    }
    
}