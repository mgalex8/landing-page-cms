<?php

defined('SYSPATH') or die('No direct script access.');

class Model_Fields extends ORM
{
    protected $_table_name  = 'x_fields';
    protected $_primary_key = 'id';    

    public function rules()
    {
        return array(                        
            'name' => array(
                array('not_empty')
            ),
        );
    }
    
}