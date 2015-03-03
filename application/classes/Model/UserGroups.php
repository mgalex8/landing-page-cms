<?php

defined('SYSPATH') or die('No direct script access.');

class Model_UserGroups extends ORM
{
    protected $_table_name  = 'user_groups';
    protected $_primary_key = 'id';    

    public function rules()
    {
        return array();
    }
    
}