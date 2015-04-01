<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Site_Index extends Controller_Base
{
    public $template = 'layouts/template-site';

    public function action_index()
    {        
        $view = View::factory('site/index');
        $this->template->title = 'Black Cat';
        
                
        $positions = ORM::factory('Positions')->find_all();
        $positions_data = array();
        foreach($positions as $position)
        {
            $key = $position->name;
            $positions_data[$key] = $position->text;        
        }
        
        $structures = ORM::factory('Structure')->find_all();
        $structures_data = array();
        foreach($structures as $struct)
        {
            $contents = ORM::factory('Content')->where('structure_id','=',$struct->id)->find_all();
            $items = array();
            foreach($contents as $content)
            {   
                $content_fields = json_decode($content->fields, false);
                $field_items = array();
                foreach ($content_fields as $key=>$value)
                {
                    $field = ORM::factory('Fields')->where('id','=',$key)->find();
                    if ($field->loaded())
                    {
                        $field_items[] = array(
                            'id' => $field->id,
                            'name' => $field->name,
                            'title' => $field->title,                            
                            'value' => $value,
                            'i18n' => $field->i18n,                            
                            'type' => $field->type,
                            'param1' => $field-param1,
                            'param2' => $field-param2,
                            'multiply' => $field->multiply,
                            'required' => $field->required,                            
                        );
                    }
                }                
                $items[] = array(
                    'id' => $content->id,
                    'structure_id' => $content->structure_id,
                    'parent_id' => $content->parent_id,
                    'name' => $content->name,
                    'text' => $content->text,
                    'fields' => $field_items,
                );
            }
            
            $key = $struct->name;
            $content[] = array(
                'id' => $struct->id,
                'name' => $struct->name,
                'title' => $struct->title,
                'i18n' => $struct->i18n,
                'items' => $items,
            );
        }        
        
        $view->content = $result;
        $view->positions = $positions_data;
        $view->result = array();        
	$this->display($view);
    }
    
} // end Controller_Admin_Users
