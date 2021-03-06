<?php

defined('SYSPATH') or die('No direct script access.');

class Model_Fields extends ORM
{
    protected $_table_name  = 'x_fields';
    protected $_primary_key = 'id';    

    public function rules()
    {
        return array( 
            'structure_id' => array(
                array('not_empty')
            ),
            'name' => array(
                array('not_empty')
            ),
        );
    }
    
}