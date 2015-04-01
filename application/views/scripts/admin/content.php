<h2><?php echo i18n($result['structure']['i18n'], $result['structure']['title']) ?></h2>
<div class="row space">
    <div class="span12 ">
    	<a class="btn btn-info" href="<?php echo $_SERVER['HTTP_REFERER']; ?>"><i class="icon-chevron-left icon-white"></i></a>
    	<a class="btn btn-success" href="<?php echo $result['add_category_url']; ?>"><i class="icon-ok icon-white"></i> <?php echo __('Add Category'); ?></a>
        <a class="btn btn-success" href="<?php echo $result['add_item_url']; ?>"><i class="icon-ok icon-white"></i> <?php echo __('Add Item'); ?></a>                
        <a class="btn btn-danger remove-btn"><i class="icon-remove icon-white"></i> <?php echo __('Delete selected'); ?></a>
    </div>    
</div>
<div class="row space">
    <div class="span12">
        <form id="delete-form" method="POST">
            <table class="table table-striped table-hover" id="user-table">
                <thead>
                    <tr>
                        <th class="span1 text-center"><input type="checkbox" /></th>
                        <th class="span1"></th>                                                
                        <th class="span3"><?php echo __('Name'); ?></th>
                        <th class="span2"><?php echo __('Active'); ?></th>
                        <th class="span3"><?php echo __('Date create'); ?></th>
                        <th class="span3"><?php echo __('Date update'); ?></th>
                        <th class="span3"></th>
                    </tr>
                </thead>
                <tbody>
<?php
    foreach ($result['content'] as $item):
		if ($item['is_category']): 
?>
            <tr class="category">
                <td class="text-center"><input type="checkbox" name="delete[<?php echo  $item['id']; ?>]" item-id="<?php echo $item['id']; ?>" /></td>
                <td class="text-center"><a href="<?php echo $item['edit_children_url']; ?>"><i class="icon-folder-open"></a></td>                                                        
                <td><a href="<?php echo $item['edit_children_url']; ?>"><?php echo $item['name']; ?></a></td>
                <td class="text-center"><?php if ($item['active']): ?><i class="icon-ok"><?php endif; ?></td>
                <td><?php echo $item['created_at']; ?></td>
                <td><?php echo $item['update_at']; ?></td>
                <td class="text-center">	                            	
                    <a class="btn btn-info" href="<?php echo $item['edit_children_url']; ?>">...</i></a>	                                
                    <a class="btn btn-success" href="<?php echo $item['edit_url']; ?>?id=<?php echo $item['id']; ?>"><i class="icon-pencil icon-white"></i></a>                                
                    <a class="btn btn-danger remove-image-btn" item-id="<?php echo $item['id']; ?>"><i class="icon-remove icon-white"></i></a>
                </td>
            </tr>
<?php	else: ?>
			<tr>
                <td class="text-center"><input type="checkbox" name="delete[<?php echo  $item['id']; ?>]" item-id="<?php echo $item['id']; ?>" /></td>
                <td class="text-center"><a href="<?php echo $item['edit_children_url']; ?>"><i class="icon-file"></td>                                                        
                <td><?php echo $item['name']; ?></td>
                <td><?php echo $item['active']; ?></td>
                <td><?php echo $item['created_at']; ?></td>
                <td><?php echo $item['update_at']; ?></td>
                <td class="text-center">	                            	
                    <a class="btn btn-success" href="<?php echo $item['edit_url']; ?>?id=<?php echo $item['id']; ?>"><i class="icon-pencil icon-white"></i></a>                                
                    <a class="btn btn-danger remove-image-btn" item-id="<?php echo $item['id']; ?>"><i class="icon-remove icon-white"></i></a>
                </td>
            </tr>
<?php
		endif;
	endforeach;
?>
                </tbody>
            </table>
        </form>
    </div>
</div>
<?php echo $pagination; ?>

<br/>

<script>
    jQuery(document).ready(function(){
        jQuery('.selectpicker').selectpicker();
                        
        var checkboxes = jQuery('td input[type=checkbox]'),
            disabling = function(){
                if (checkboxes.filter(':checked').length === 0){
                    jQuery('.remove-btn').addClass('disabled');
                    jQuery('.block-btn').addClass('disabled');
                    jQuery('.activate-btn').addClass('disabled');
                }
                else {
                    jQuery('.remove-btn').removeClass('disabled');
                    jQuery('.block-btn').removeClass('disabled');
                    jQuery('.activate-btn').removeClass('disabled');
                }                
            };
        jQuery('td input[type=checkbox]').on('change',function(){
            console.log(this);
            disabling();
        });
        
        jQuery(function(){
            jQuery('th input[type=checkbox]').on('change',function(){
                if (jQuery(this).is(':checked')){
                    jQuery('td input[type=checkbox]').prop('checked',true);
                }
                else{
                    jQuery('td input[type=checkbox]').prop('checked',false);
                }
                disabling();
            });
        });
        disabling();        
        
        jQuery('.remove-btn').on('click', function(){
            if ( !jQuery(this).is('.disabled')) {
                jQuery('#delete-form').submit();
            }
        });
        
        jQuery('.remove-image-btn').on('click', function(){
            var item_id = jQuery(this).attr('item-id');
            var cbox = jQuery('input[item-id='+item_id+']');
            cbox.prop('checked',true);
            jQuery('#delete-form').submit();
        });
        
    });
</script>