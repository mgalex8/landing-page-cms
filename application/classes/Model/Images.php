<?php

defined('SYSPATH') or die('No direct script access.');

class Model_Images extends ORM
{
    protected $_table_name  = 'images';
    protected $_primary_key = 'id';    

    public function rules()
    {
        return array(                        
            'title' => array(
                array('not_empty')
            ),        
            'file' => array(
                array('not_empty')
            ),
        );
    }
    
}