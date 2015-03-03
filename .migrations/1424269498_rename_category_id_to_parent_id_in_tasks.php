<?php defined('SYSPATH') OR die('No direct script access.');
/**
* create_table($table_name, $fields, array('id' => TRUE, 'options' => ''))
* drop_table($table_name)
* rename_table($old_name, $new_name)
* add_column($table_name, $column_name, $params)
* rename_column($table_name, $column_name, $new_column_name)
* change_column($table_name, $column_name, $params)
* remove_column($table_name, $column_name)
* add_index($table_name, $index_name, $columns, $index_type = 'normal')
* remove_index($table_name, $index_name)
*/
class Rename_Category_Id_To_Parent_Id_In_Tasks extends Migration {

	public function up()
	{
		$this->rename_column('tasks', 'category_id', 'parent_id');
	}
	
	public function down()
	{
		$this->rename_column('tasks', 'parent_id', 'category_id');
	}
}
